import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flclashx/common/app_localizations.dart';
import 'package:flclashx/common/constant.dart';
import 'package:flclashx/common/preferences.dart';
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

/// A short-lived access token + long-lived opaque refresh token (ADR 0021).
/// Returned by the Google sign-in endpoints and by `POST /v1/auth/refresh`.
/// [refreshToken] may be empty when talking to a backend that predates the
/// refresh contract (the access token then just runs to its short TTL).
class AuthTokens {
  const AuthTokens({required this.accessToken, required this.refreshToken});

  final String accessToken;
  final String refreshToken;
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

  factory TelegramLinkInit.fromJson(Map<String, Object?> json) =>
      TelegramLinkInit(
        code: json['code'] as String? ?? '',
        deepLink: json['deep_link'] as String? ?? '',
      );

  final String code;
  final String deepLink;
}

/// Result of `POST /v1/promo/validate` (ADR 0016): a code's reward (+days/+traffic)
/// and/or discount. On the client only REWARD codes are redeemable — a discount code
/// applies to a bot/Telegram-Payments invoice, which the client has no checkout for.
class PromoPreview {
  const PromoPreview({
    required this.rewardDays,
    required this.rewardTrafficBytes,
    required this.discountPercent,
    required this.discountFixedRub,
  });

  factory PromoPreview.fromJson(Map<String, Object?> json) => PromoPreview(
        rewardDays: (json['reward_days'] as num?)?.toInt() ?? 0,
        rewardTrafficBytes:
            (json['reward_traffic_bytes'] as num?)?.toInt() ?? 0,
        discountPercent: (json['discount_percent'] as num?)?.toInt() ?? 0,
        discountFixedRub: (json['discount_fixed_rub'] as num?)?.toInt() ?? 0,
      );

  final int rewardDays;
  final int rewardTrafficBytes;
  final int discountPercent;
  final int discountFixedRub;

  /// A reward code grants +days/+traffic (applied to Remnawave); only these are
  /// redeemable from the client. A code with only a discount is bot/payment-only.
  bool get isReward => rewardDays > 0 || rewardTrafficBytes > 0;
}

/// Result of `POST /v1/referral/attribute` (ADR 0020): the welcome bonus granted to
/// a NEW account that entered a referrer's code. Attribution is best-effort at
/// sign-in; the bonus surfaces on the next `/v1/me`. [attributed] is false when
/// nothing applied.
class ReferralResult {
  const ReferralResult({
    required this.attributed,
    required this.welcomeDays,
    required this.welcomeTrafficBytes,
    required this.welcomeDiscountPercent,
  });

  factory ReferralResult.fromJson(Map<String, Object?> json) => ReferralResult(
        attributed: json['attributed'] as bool? ?? false,
        welcomeDays: (json['welcome_days'] as num?)?.toInt() ?? 0,
        welcomeTrafficBytes:
            (json['welcome_traffic_bytes'] as num?)?.toInt() ?? 0,
        welcomeDiscountPercent:
            (json['welcome_discount_percent'] as num?)?.toInt() ?? 0,
      );

  final bool attributed;
  final int welcomeDays;
  final int welcomeTrafficBytes;
  final int welcomeDiscountPercent;
}

/// Result of `GET /v1/referral/info` (ADR 0020): the account's own referral code +
/// share link plus headline stats. [link] is a `t.me/<bot>?start=ref_<code>` deep
/// link and is EMPTY when the bot username is not configured server-side (the share
/// action then falls back to copying [code] alone) — same `omitempty` shape as
/// [TelegramLinkInit].
class ReferralInfo {
  const ReferralInfo({
    required this.code,
    required this.link,
    required this.invitedCount,
    required this.earnedDays,
    required this.commissionPercent,
    required this.signupBonusDays,
    required this.welcomeDays,
    required this.welcomeTrafficBytes,
    required this.welcomeDiscountPercent,
  });

  factory ReferralInfo.fromJson(Map<String, Object?> json) => ReferralInfo(
        code: json['code'] as String? ?? '',
        link: json['link'] as String? ?? '',
        invitedCount: (json['invited_count'] as num?)?.toInt() ?? 0,
        earnedDays: (json['earned_days'] as num?)?.toInt() ?? 0,
        commissionPercent: (json['commission_percent'] as num?)?.toInt() ?? 0,
        signupBonusDays: (json['signup_bonus_days'] as num?)?.toInt() ?? 0,
        welcomeDays: (json['welcome_days'] as num?)?.toInt() ?? 0,
        welcomeTrafficBytes:
            (json['welcome_traffic_bytes'] as num?)?.toInt() ?? 0,
        welcomeDiscountPercent:
            (json['welcome_discount_percent'] as num?)?.toInt() ?? 0,
      );

  final String code;
  final String link;
  final int invitedCount;
  final int earnedDays;
  final int commissionPercent;
  final int signupBonusDays;
  final int welcomeDays;
  final int welcomeTrafficBytes;
  final int welcomeDiscountPercent;
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
            ) {
    // NOTE: BaseOptions.validateStatus is `(_) => true`, so a 401 arrives as a
    // normal Response (not a DioException) — the refresh hook therefore lives in
    // onResponse, not onError. A custom Dio passed in by a test may not carry
    // that validateStatus; guarding both is unnecessary since our sole caller
    // uses the default.
    _dio.interceptors.add(
      InterceptorsWrapper(onResponse: _onResponse),
    );
  }

  final Dio _dio;

  /// Invoked after a transparent token refresh with the new (access, refresh)
  /// pair. Wired up at app start so the in-memory `authTokenProvider` follows the
  /// rotated access token (see `auth_state.dart` / app bootstrap). Optional so
  /// the api works headless (tests) without Riverpod.
  void Function(AuthTokens tokens)? onTokensRefreshed;

  /// Guards against concurrent refreshes: many in-flight requests can 401 at
  /// once when the access token expires; they all await the same refresh.
  Future<AuthTokens?>? _inFlightRefresh;

  /// Extra options key flagging a request that has already been retried after a
  /// refresh, so a second 401 propagates instead of looping.
  static const _retriedFlag = 'auth_retried';

  /// Dio 401 hook (ADR 0021): transparently refresh the access token once and
  /// replay the original request. Runs in onResponse because validateStatus lets
  /// every status through as a Response. On any failure it passes the original
  /// 401 response along so per-call code maps it to [AuthErrorKind.sessionExpired].
  Future<void> _onResponse(
      Response<dynamic> response, ResponseInterceptorHandler handler) async {
    final request = response.requestOptions;

    final isUnauthorized = response.statusCode == HttpStatus.unauthorized;
    final alreadyRetried = request.extra[_retriedFlag] == true;
    // Never try to refresh the auth endpoints themselves (login/refresh/logout):
    // a 401 there is a real credential failure, and refreshing the refresh call
    // would recurse.
    final isAuthEndpoint = request.path.startsWith('/v1/auth/');

    if (!isUnauthorized || alreadyRetried || isAuthEndpoint) {
      handler.next(response);
      return;
    }

    final refreshToken = await preferences.getRefreshToken();
    if (refreshToken == null || refreshToken.isEmpty) {
      handler.next(response);
      return;
    }

    final AuthTokens? tokens;
    try {
      tokens = await _refreshOnce(refreshToken);
    } catch (_) {
      handler.next(response);
      return;
    }
    if (tokens == null) {
      handler.next(response); // refresh token dead → fall through to 401
      return;
    }

    // Persist + notify, then replay the original request with the new token.
    await preferences.setAuthTokens(tokens.accessToken, tokens.refreshToken);
    onTokensRefreshed?.call(tokens);

    request.extra[_retriedFlag] = true;
    if (request.headers.containsKey('Authorization')) {
      request.headers['Authorization'] = 'Bearer ${tokens.accessToken}';
    }
    try {
      final retried = await _dio.fetch<dynamic>(request);
      handler.resolve(retried);
    } on DioException catch (e) {
      // Replay failed at the transport level — surface the original 401 so the
      // caller's sessionExpired mapping still applies.
      if (e.response != null) {
        handler.resolve(e.response!);
      } else {
        handler.next(response);
      }
    }
  }

  /// Coalesces concurrent refreshes into a single `/v1/auth/refresh` round-trip.
  /// Returns the new pair, or null if the refresh token is no longer valid
  /// (backend 401 → the caller falls through to sessionExpired).
  Future<AuthTokens?> _refreshOnce(String refreshToken) =>
      _inFlightRefresh ??= () async {
        try {
          return await _postRefresh(refreshToken);
        } finally {
          _inFlightRefresh = null;
        }
      }();

  Future<AuthTokens?> _postRefresh(String refreshToken) async {
    final Response<dynamic> response;
    try {
      response = await _dio.post<dynamic>(
        '/v1/auth/refresh',
        data: {'refresh_token': refreshToken},
      );
    } on DioException {
      return null; // network error — treat as "couldn't refresh"
    }
    if (response.statusCode == HttpStatus.ok) {
      final tokens = _extractTokens(response.data);
      if (tokens != null && tokens.accessToken.isNotEmpty) return tokens;
    }
    return null; // 401/invalid → refresh token dead
  }

  /// Exchanges a verified Google ID token for our token pair (ADR 0014/0021).
  /// The first sign-in for an identity creates the account + trial server-side.
  /// Used on Android/iOS/macOS (native sign-in).
  Future<AuthTokens> google(String idToken) =>
      _googleAuth('/v1/auth/google', {'id_token': idToken});

  /// Desktop (Windows/Linux): sends the browser PKCE authorization code for the
  /// backend to exchange (the OAuth secret stays server-side).
  Future<AuthTokens> googleDesktop(
          String code, String codeVerifier, String redirectUri) =>
      _googleAuth('/v1/auth/google/desktop', {
        'code': code,
        'code_verifier': codeVerifier,
        'redirect_uri': redirectUri,
      });

  Future<AuthTokens> _googleAuth(String path, Map<String, Object?> data) async {
    final Response<dynamic> response;
    try {
      response = await _dio.post<dynamic>(path, data: data);
    } on DioException catch (e) {
      throw _mapDioException(e);
    }

    final status = response.statusCode ?? 0;
    if (status == HttpStatus.ok || status == HttpStatus.created) {
      final tokens = _extractTokens(response.data);
      if (tokens == null || tokens.accessToken.isEmpty) {
        throw AuthException(
          AuthErrorKind.server,
          appLocalizations.authErrorServer,
        );
      }
      return tokens;
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

  /// Best-effort logout (ADR 0021): `POST /v1/auth/logout {refresh_token}` so the
  /// backend revokes the refresh token immediately (the short-lived access token
  /// then dies on its own). Idempotent server-side; any failure is swallowed so
  /// logout never blocks on the network. Callers still clear local state after.
  Future<void> logout(String refreshToken) async {
    if (refreshToken.isEmpty) return;
    try {
      await _dio.post<dynamic>(
        '/v1/auth/logout',
        data: {'refresh_token': refreshToken},
      );
    } on DioException {
      // best-effort — a failed revoke must not block local logout
    }
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
  Future<void> purchasePlan(String token, String planCode,
      {String? receipt}) async {
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
    if (status == HttpStatus.notImplemented) {
      // Backend payments are disabled (ADR 0019: PAYMENTS_TEST_MODE off, no real
      // IAP yet) -> a clear "billing not active" notice, not a generic 5xx error.
      throw AuthException(
        AuthErrorKind.server,
        appLocalizations.billingNotActive,
      );
    }
    throw _mapStatus(status);
  }

  /// Validates a promo code (ADR 0016): `POST /v1/promo/validate` (Bearer) ->
  /// [PromoPreview]. Lets the caller tell a reward code (redeemable here) from a
  /// discount code (bot-only) before applying. 404/400/409 -> a localized
  /// "invalid/unusable" error; 401 -> sessionExpired.
  Future<PromoPreview> validatePromo(String token, String code) async {
    final Response<dynamic> response;
    try {
      response = await _dio.post<dynamic>(
        '/v1/promo/validate',
        data: {'code': code},
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );
    } on DioException catch (e) {
      throw _mapDioException(e);
    }

    final status = response.statusCode ?? 0;
    if (status == HttpStatus.ok) {
      final data = response.data;
      if (data is! Map) {
        throw AuthException(
            AuthErrorKind.server, appLocalizations.authErrorServer);
      }
      return PromoPreview.fromJson(Map<String, Object?>.from(data));
    }
    if (status == HttpStatus.unauthorized) {
      throw AuthException(AuthErrorKind.sessionExpired,
          appLocalizations.authErrorSessionExpired);
    }
    if (status == HttpStatus.notFound ||
        status == HttpStatus.badRequest ||
        status == HttpStatus.conflict) {
      throw AuthException(
          AuthErrorKind.invalidCredentials, appLocalizations.promoInvalid);
    }
    throw _mapStatus(status);
  }

  /// Redeems a REWARD promo code (ADR 0016): `POST /v1/promo/apply` (Bearer). On 200
  /// the reward (+days/+traffic) is applied to the account's subscription in
  /// Remnawave; the caller refreshes `/v1/me` to surface it. 404/400/409 (unknown /
  /// unusable / already used / no active subscription) -> a localized error; 401 ->
  /// sessionExpired.
  Future<void> applyPromo(String token, String code) async {
    final Response<dynamic> response;
    try {
      response = await _dio.post<dynamic>(
        '/v1/promo/apply',
        data: {'code': code},
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );
    } on DioException catch (e) {
      throw _mapDioException(e);
    }

    final status = response.statusCode ?? 0;
    if (status == HttpStatus.ok) {
      return; // reward applied; a /v1/me refresh surfaces the new expiry/traffic
    }
    if (status == HttpStatus.unauthorized) {
      throw AuthException(AuthErrorKind.sessionExpired,
          appLocalizations.authErrorSessionExpired);
    }
    if (status == HttpStatus.notFound ||
        status == HttpStatus.badRequest ||
        status == HttpStatus.conflict) {
      throw AuthException(
          AuthErrorKind.invalidCredentials, appLocalizations.promoInvalid);
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
      throw AuthException(
          AuthErrorKind.server, appLocalizations.authErrorServer);
    }
    return TelegramLinkInit.fromJson(Map<String, Object?>.from(data));
  }

  /// Attributes a referrer's code to THIS account (ADR 0020):
  /// `POST /v1/referral/attribute {code}` (Bearer) -> [ReferralResult]. 404 (unknown
  /// code) / 400 (bad request) / 409 (own code OR already has a referrer) collapse to
  /// a localized "invalid code" error (the two 409s differ only by the backend's
  /// untranslated message, as [applyPromo] does). 401 -> sessionExpired.
  Future<ReferralResult> applyReferral(String token, String code) async {
    final Response<dynamic> response;
    try {
      response = await _dio.post<dynamic>(
        '/v1/referral/attribute',
        data: {'code': code},
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );
    } on DioException catch (e) {
      throw _mapDioException(e);
    }

    final status = response.statusCode ?? 0;
    if (status == HttpStatus.ok) {
      final data = response.data;
      if (data is! Map) {
        throw AuthException(
            AuthErrorKind.server, appLocalizations.authErrorServer);
      }
      return ReferralResult.fromJson(Map<String, Object?>.from(data));
    }
    if (status == HttpStatus.unauthorized) {
      throw AuthException(AuthErrorKind.sessionExpired,
          appLocalizations.authErrorSessionExpired);
    }
    if (status == HttpStatus.notFound ||
        status == HttpStatus.badRequest ||
        status == HttpStatus.conflict) {
      throw AuthException(
          AuthErrorKind.invalidCredentials, appLocalizations.referralInvalid);
    }
    throw _mapStatus(status);
  }

  /// Fetches the account's own referral code/link + stats (ADR 0020):
  /// `GET /v1/referral/info` (Bearer) -> [ReferralInfo]. 401 -> sessionExpired.
  /// Same shape as [linkInitTelegram].
  Future<ReferralInfo> fetchReferralInfo(String token) async {
    final Response<dynamic> response;
    try {
      response = await _dio.get<dynamic>(
        '/v1/referral/info',
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );
    } on DioException catch (e) {
      throw _mapDioException(e);
    }

    final status = response.statusCode ?? 0;
    if (status == HttpStatus.unauthorized) {
      throw AuthException(AuthErrorKind.sessionExpired,
          appLocalizations.authErrorSessionExpired);
    }
    if (status != HttpStatus.ok) {
      throw _mapStatus(status);
    }

    final data = response.data;
    if (data is! Map) {
      throw AuthException(
          AuthErrorKind.server, appLocalizations.authErrorServer);
    }
    return ReferralInfo.fromJson(Map<String, Object?>.from(data));
  }

  /// Parses `{token, refresh_token}` (ADR 0021). `refresh_token` is optional —
  /// a backend that predates the contract returns only `token`, in which case
  /// the pair carries an empty refresh token (short sessions, no auto-refresh).
  AuthTokens? _extractTokens(dynamic data) {
    if (data is Map) {
      final token = data['token'];
      if (token is String) {
        final refresh = data['refresh_token'];
        return AuthTokens(
          accessToken: token,
          refreshToken: refresh is String ? refresh : '',
        );
      }
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
