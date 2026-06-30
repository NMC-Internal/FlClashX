import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flclashx/common/app_localizations.dart';
import 'package:flclashx/common/constant.dart';
import 'package:flclashx/models/models.dart';

/// Kinds of auth failures, used to pick a localized message in the UI.
enum AuthErrorKind {
  invalidCredentials,
  emailTaken,
  network,
  server,
  /// 401 on an authenticated request: the session expired / token is no longer
  /// valid. The new UI drops to guest mode + a "session expired" toast; the old
  /// UI logs out. Distinct from [invalidCredentials] (a failed login attempt).
  sessionExpired,
  unknown,
}

/// Typed exception thrown by [AuthApi]. [message] is already localized and
/// safe to show to the user.
class AuthException implements Exception {
  const AuthException(this.kind, this.message);

  final AuthErrorKind kind;
  final String message;

  @override
  String toString() => 'AuthException($kind): $message';
}

/// Subscription provisioning lifecycle as reported by `GET /v1/me`
/// (ADR 0009). While [provisioning] the subscription URL itself answers
/// 409 "subscription not ready".
abstract final class SubscriptionStatus {
  static const provisioning = 'provisioning';
  static const active = 'active';
  static const failed = 'failed';
}

/// Result of `POST /v1/identities/telegram/link-init` (ADR 0015/0018): an opaque
/// single-use code plus a ready `t.me/<bot>?start=<code>` deep link (empty when the
/// bot username is not configured server-side).
class TelegramLinkInit {
  const TelegramLinkInit({required this.code, required this.deepLink});

  factory TelegramLinkInit.fromJson(Map<String, Object?> json) => TelegramLinkInit(
        code: json['code'] as String? ?? '',
        deepLink: json['deep_link'] as String? ?? '',
      );

  final String code;
  final String deepLink;
}

/// Thin client for the auth/me backend contract (ADR 0014 social login, ADR 0010).
///
/// Endpoints (base = [backendBaseUrl]):
/// - `POST /v1/auth/google {id_token}` -> `200 {"token":"<jwt>"}`
///   (verifies the Google ID token; first sign-in also creates the account + trial)
/// - `GET  /v1/me  (Authorization: Bearer <jwt>)` -> the account view (ADR 0010)
class AuthApi {
  AuthApi({Dio? dio, String? baseUrl})
      : _dio = dio ??
            Dio(
              BaseOptions(
                baseUrl: baseUrl ?? backendBaseUrl,
                connectTimeout: const Duration(seconds: 15),
                receiveTimeout: const Duration(seconds: 15),
                contentType: Headers.jsonContentType,
                responseType: ResponseType.json,
                // Don't throw on non-2xx; we map status codes ourselves below.
                validateStatus: (_) => true,
              ),
            );

  final Dio _dio;

  /// Exchanges a verified Google ID token for our JWT (ADR 0014). The first
  /// sign-in for an identity creates the account + trial server-side.
  /// Used on Android/iOS/macOS (native sign-in).
  Future<String> google(String idToken) =>
      _googleAuth('/v1/auth/google', {'id_token': idToken});

  /// Desktop (Windows/Linux): sends the browser PKCE authorization code for the
  /// backend to exchange (the OAuth secret stays server-side).
  Future<String> googleDesktop(String code, String codeVerifier, String redirectUri) =>
      _googleAuth('/v1/auth/google/desktop', {
        'code': code,
        'code_verifier': codeVerifier,
        'redirect_uri': redirectUri,
      });

  Future<String> _googleAuth(String path, Map<String, Object?> data) async {
    final Response<dynamic> response;
    try {
      response = await _dio.post<dynamic>(path, data: data);
    } on DioException catch (e) {
      throw _mapDioException(e);
    }

    final status = response.statusCode ?? 0;
    if (status == HttpStatus.ok || status == HttpStatus.created) {
      final token = _extractToken(response.data);
      if (token == null || token.isEmpty) {
        throw AuthException(
          AuthErrorKind.server,
          appLocalizations.authErrorServer,
        );
      }
      return token;
    }

    // 401/400 = the backend rejected the Google credential (bad/expired/wrong audience).
    if (status == HttpStatus.unauthorized || status == HttpStatus.badRequest) {
      throw AuthException(
        AuthErrorKind.invalidCredentials,
        appLocalizations.authGoogleFailed,
      );
    }
    throw _mapStatus(status);
  }

  /// Fetches the authenticated account view (`GET /v1/me` v2, ADR 0010):
  /// email, the list of subscriptions, trial eligibility and device limit.
  ///
  /// An account with NO subscription is valid and returns a [Me] with an empty
  /// subscriptions list (NOT an error). A 401 (token rejected) or 404 (the account
  /// no longer exists) throws [AuthErrorKind.sessionExpired] so the caller drops to
  /// guest mode / logs out — the stored token can no longer be used either way.
  Future<Me> getMe(String token) async {
    final Response<dynamic> response;
    try {
      response = await _dio.get<dynamic>(
        '/v1/me',
        options: Options(
          headers: {'Authorization': 'Bearer $token'},
        ),
      );
    } on DioException catch (e) {
      throw _mapDioException(e);
    }

    final status = response.statusCode ?? 0;
    if (status == HttpStatus.unauthorized || status == HttpStatus.notFound) {
      throw AuthException(
        AuthErrorKind.sessionExpired,
        appLocalizations.authErrorSessionExpired,
      );
    }
    if (status != HttpStatus.ok) {
      throw _mapStatus(status);
    }

    final data = response.data;
    if (data is! Map) {
      throw AuthException(
        AuthErrorKind.server,
        appLocalizations.authErrorServer,
      );
    }
    return Me.fromJson(Map<String, Object?>.from(data));
  }

  /// Claims the account's single trial (ADR 0017 §3): `POST /v1/trial/claim`
  /// (Bearer). The trial provisions asynchronously, so the caller refreshes
  /// `/v1/me` afterwards to surface the new (provisioning→active) subscription.
  ///
  /// Idempotent from the UI's point of view: 204 (granted) and 409 (already
  /// claimed) both return normally — either way the account now has its trial.
  /// 401/404 (token rejected / account gone) throw [AuthErrorKind.sessionExpired]
  /// so the caller drops to guest; other statuses throw a generic error.
  Future<void> claimTrial(String token) async {
    final Response<dynamic> response;
    try {
      response = await _dio.post<dynamic>(
        '/v1/trial/claim',
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );
    } on DioException catch (e) {
      throw _mapDioException(e);
    }

    final status = response.statusCode ?? 0;
    if (status == HttpStatus.noContent || status == HttpStatus.conflict) {
      return; // granted, or already had it — both mean "trial exists now"
    }
    if (status == HttpStatus.unauthorized || status == HttpStatus.notFound) {
      throw AuthException(
        AuthErrorKind.sessionExpired,
        appLocalizations.authErrorSessionExpired,
      );
    }
    throw _mapStatus(status);
  }

  /// Buys a plan via the env-gated TEST checkout (ADR 0019): `POST /v1/checkout`
  /// (Bearer) with `{plan_code, receipt?}`. In the backend's test mode this
  /// provisions the subscription WITHOUT any charge; the subscription provisions
  /// asynchronously, so the caller refreshes `/v1/me` afterwards to surface it.
  ///
  /// 204 (provisioned) returns normally. 401 (token rejected) throws
  /// [AuthErrorKind.sessionExpired] so the caller drops to guest. Other statuses
  /// throw a generic error — notably 501 when the backend has payments disabled
  /// (PAYMENTS_TEST_MODE off), and 403/404 for a non-purchasable/unknown plan.
  ///
  /// [receipt] is reserved for the future real store-IAP path (Google Play / App
  /// Store) and is ignored by the backend in test mode.
  Future<void> purchasePlan(String token, String planCode, {String? receipt}) async {
    final Response<dynamic> response;
    try {
      response = await _dio.post<dynamic>(
        '/v1/checkout',
        data: {
          'plan_code': planCode,
          if (receipt != null) 'receipt': receipt,
        },
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );
    } on DioException catch (e) {
      throw _mapDioException(e);
    }

    final status = response.statusCode ?? 0;
    if (status == HttpStatus.noContent) {
      return; // provisioned (test mode); /v1/me will surface the subscription
    }
    if (status == HttpStatus.unauthorized) {
      throw AuthException(
        AuthErrorKind.sessionExpired,
        appLocalizations.authErrorSessionExpired,
      );
    }
    throw _mapStatus(status);
  }

  /// Starts linking a Telegram account to THIS account (ADR 0015/0018):
  /// `POST /v1/identities/telegram/link-init` (Bearer) -> `{code, deep_link}`.
  /// The user opens the deep link in the bot to attach Telegram; the backend then
  /// reflects what they bought via the bot in `/v1/me` (adopt-on-/me). A 401 throws
  /// [AuthErrorKind.sessionExpired].
  Future<TelegramLinkInit> linkInitTelegram(String token) async {
    final Response<dynamic> response;
    try {
      response = await _dio.post<dynamic>(
        '/v1/identities/telegram/link-init',
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );
    } on DioException catch (e) {
      throw _mapDioException(e);
    }

    final status = response.statusCode ?? 0;
    if (status == HttpStatus.unauthorized) {
      throw AuthException(
        AuthErrorKind.sessionExpired,
        appLocalizations.authErrorSessionExpired,
      );
    }
    if (status != HttpStatus.ok) {
      throw _mapStatus(status);
    }

    final data = response.data;
    if (data is! Map) {
      throw AuthException(AuthErrorKind.server, appLocalizations.authErrorServer);
    }
    return TelegramLinkInit.fromJson(Map<String, Object?>.from(data));
  }

  String? _extractToken(dynamic data) {
    if (data is Map) {
      final token = data['token'];
      if (token is String) return token;
    }
    return null;
  }

  AuthException _mapDioException(DioException e) {
    switch (e.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
      case DioExceptionType.connectionError:
        return AuthException(
          AuthErrorKind.network,
          appLocalizations.authErrorNetwork,
        );
      case DioExceptionType.badResponse:
        return _mapStatus(e.response?.statusCode ?? 0);
      case DioExceptionType.cancel:
      case DioExceptionType.badCertificate:
      case DioExceptionType.unknown:
        if (e.error is SocketException) {
          return AuthException(
            AuthErrorKind.network,
            appLocalizations.authErrorNetwork,
          );
        }
        return AuthException(
          AuthErrorKind.unknown,
          appLocalizations.authErrorUnknown,
        );
    }
  }

  AuthException _mapStatus(int status) {
    if (status >= 500) {
      return AuthException(
        AuthErrorKind.server,
        appLocalizations.authErrorServer,
      );
    }
    return AuthException(
      AuthErrorKind.unknown,
      appLocalizations.authErrorUnknown,
    );
  }
}

final authApi = AuthApi();
