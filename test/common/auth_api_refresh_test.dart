import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flclashx/common/auth_api.dart';
import 'package:flclashx/common/constant.dart';
import 'package:flclashx/common/preferences.dart';
import 'package:flclashx/l10n/l10n.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http_mock_adapter/http_mock_adapter.dart';

/// Unit tests for the transparent JWT refresh-on-401 Dio interceptor in
/// [AuthApi] (ADR 0021, `lib/common/auth_api.dart`).
///
/// The interceptor lives in `BaseOptions.validateStatus == (_) => true` land:
/// a 401 arrives as a normal [Response], so it hooks `onResponse`, calls
/// `POST /v1/auth/refresh`, persists the rotated pair via the global
/// [preferences] singleton, and replays the original request once (guarded by
/// `request.extra['auth_retried']`; auth endpoints are never refreshed).
///
/// We drive it with an injected mock-adapter [Dio] (so no real network) and a
/// method-channel stub for `flutter_secure_storage` (so the refresh token can
/// be read and the rotated pair written without a real Keychain/Keystore).
///
/// The two `/v1/me` responses (pre-refresh 401 vs. post-refresh 200) are told
/// apart by their `Authorization` header — `http_mock_adapter` matches headers
/// as a subset, so `Bearer <old>` and `Bearer <new>` select different mocks.
void main() {
  const secureChannel =
      MethodChannel('plugins.it_nomads.com/flutter_secure_storage');

  const oldAccess = 'old-access-jwt';
  const oldRefresh = 'old-refresh-opaque';
  const newAccess = 'new-access-jwt';
  const newRefresh = 'new-refresh-opaque';

  /// In-memory stand-in for the platform secure store. Seeded per-test.
  late Map<String, String> secureStore;

  Dio buildDio() => Dio(
        BaseOptions(
          baseUrl: backendBaseUrl,
          // Mirror the production AuthApi Dio: 401 must arrive as a Response
          // (not a DioException) so the onResponse refresh hook fires.
          validateStatus: (_) => true,
        ),
      );

  setUpAll(() async {
    TestWidgetsFlutterBinding.ensureInitialized();
    // `appLocalizations` (a top-level final = AppLocalizations.current) asserts
    // a loaded instance; the sessionExpired path reads a localized string.
    await AppLocalizations.load(const Locale('en'));
  });

  setUp(() {
    secureStore = {};
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(secureChannel, (call) async {
      final args = (call.arguments as Map).cast<String, dynamic>();
      final key = args['key'] as String?;
      switch (call.method) {
        case 'read':
          return secureStore[key];
        case 'write':
          secureStore[key!] = args['value'] as String;
          return null;
        case 'delete':
          secureStore.remove(key);
          return null;
        case 'containsKey':
          return secureStore.containsKey(key);
        case 'readAll':
          return Map<String, String>.from(secureStore);
        case 'deleteAll':
          secureStore.clear();
          return null;
        default:
          return null;
      }
    });
  });

  tearDown(() {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(secureChannel, null);
  });

  group('AuthApi refresh-on-401 interceptor (ADR 0021)', () {
    test(
        'a) 401 -> refresh 200 -> original request is retried with the new '
        'Bearer and the rotated pair is persisted + notified', () async {
      secureStore[refreshTokenKey] = oldRefresh;

      final dio = buildDio();
      DioAdapter(dio: dio)
        // First /v1/me (old token) is unauthorized.
        ..onGet(
          '/v1/me',
          (server) =>
              server.reply(HttpStatus.unauthorized, {'error': 'expired'}),
          headers: {'Authorization': 'Bearer $oldAccess'},
        )
        // The refresh call rotates the pair.
        ..onPost(
          '/v1/auth/refresh',
          (server) => server.reply(HttpStatus.ok, {
            'token': newAccess,
            'refresh_token': newRefresh,
          }),
          data: {'refresh_token': oldRefresh},
        )
        // Replayed /v1/me carries the new token and succeeds.
        ..onGet(
          '/v1/me',
          (server) => server.reply(HttpStatus.ok, {
            'email': 'user@example.com',
            'trial_eligible': false,
            'device_limit': 1,
            'subscriptions': <dynamic>[],
          }),
          headers: {'Authorization': 'Bearer $newAccess'},
        );

      AuthTokens? notified;
      final api = AuthApi(dio: dio)..onTokensRefreshed = (t) => notified = t;

      // getMe must transparently recover from the 401 and return the account.
      final me = await api.getMe(oldAccess);
      expect(me.email, 'user@example.com');

      // The rotated pair was surfaced to the app...
      expect(notified, isNotNull);
      expect(notified!.accessToken, newAccess);
      expect(notified!.refreshToken, newRefresh);

      // ...and persisted to secure storage.
      expect(secureStore[authTokenKey], newAccess);
      expect(secureStore[refreshTokenKey], newRefresh);
    });

    test(
        'b) refresh failure surfaces the original 401 as sessionExpired with no '
        'infinite loop', () async {
      secureStore[refreshTokenKey] = oldRefresh;

      final dio = buildDio();
      DioAdapter(dio: dio)
        ..onGet(
          '/v1/me',
          (server) =>
              server.reply(HttpStatus.unauthorized, {'error': 'expired'}),
          headers: {'Authorization': 'Bearer $oldAccess'},
        )
        // The refresh token is dead -> backend answers 401.
        ..onPost(
          '/v1/auth/refresh',
          (server) =>
              server.reply(HttpStatus.unauthorized, {'error': 'revoked'}),
          data: {'refresh_token': oldRefresh},
        );

      AuthTokens? notified;
      final api = AuthApi(dio: dio)..onTokensRefreshed = (t) => notified = t;

      await expectLater(
        api.getMe(oldAccess),
        throwsA(
          isA<AuthException>().having(
            (e) => e.kind,
            'kind',
            AuthErrorKind.sessionExpired,
          ),
        ),
      );

      // Refresh failed -> nothing rotated, nothing persisted.
      expect(notified, isNull);
      expect(secureStore[authTokenKey], isNull);
      expect(secureStore[refreshTokenKey], oldRefresh);
    });

    test(
        'c) a 401 on an /v1/auth/* endpoint itself is NOT refreshed (no loop)',
        () async {
      // A refresh token IS present, to prove the skip is about the endpoint,
      // not a missing credential.
      secureStore[refreshTokenKey] = oldRefresh;

      final dio = buildDio();
      // No /v1/auth/refresh mock is registered: the mock adapter throws on any
      // unmocked route (failOnMissingMock), so if the interceptor wrongly tried
      // to refresh the auth endpoint this test would fail loudly instead of
      // returning the mapped credential error.
      DioAdapter(dio: dio).onPost(
        '/v1/auth/google',
        (server) =>
            server.reply(HttpStatus.unauthorized, {'error': 'bad id_token'}),
        data: {'id_token': 'bad-id-token'},
      );

      final api = AuthApi(dio: dio);

      // 401 on the auth endpoint maps straight to invalidCredentials — it must
      // never be intercepted/refreshed.
      // No /v1/auth/refresh mock is registered; had the interceptor tried to
      // refresh this auth endpoint, the mock adapter would have thrown an
      // "unmocked route" AssertionError instead of the mapped credential error.
      await expectLater(
        api.google('bad-id-token'),
        throwsA(
          isA<AuthException>().having(
            (e) => e.kind,
            'kind',
            AuthErrorKind.invalidCredentials,
          ),
        ),
      );
    });
  });
}
