import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flclashx/common/app_localizations.dart';
import 'package:flclashx/common/constant.dart';

/// Kinds of auth failures, used to pick a localized message in the UI.
enum AuthErrorKind {
  invalidCredentials,
  emailTaken,
  network,
  server,
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

/// Thin client for the auth/me backend contract (ADR 0008).
///
/// Endpoints (base = [backendBaseUrl]):
/// - `POST /v1/auth/register {email,password}` -> `201 {"token":"<jwt>"}`
/// - `POST /v1/auth/login    {email,password}` -> `200 {"token":"<jwt>"}`
/// - `GET  /v1/me  (Authorization: Bearer <jwt>)` ->
///       `200 {"email":"...","subscription_url":"<url>"}`
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

  /// Registers a new account, returning the JWT on success.
  Future<String> register(String email, String password) =>
      _authRequest('/v1/auth/register', email, password, isRegister: true);

  /// Logs in, returning the JWT on success.
  Future<String> login(String email, String password) =>
      _authRequest('/v1/auth/login', email, password, isRegister: false);

  Future<String> _authRequest(
    String path,
    String email,
    String password, {
    required bool isRegister,
  }) async {
    final Response<dynamic> response;
    try {
      response = await _dio.post<dynamic>(
        path,
        data: {'email': email, 'password': password},
      );
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

    if (isRegister && status == HttpStatus.conflict) {
      throw AuthException(
        AuthErrorKind.emailTaken,
        appLocalizations.authErrorEmailTaken,
      );
    }
    if (!isRegister &&
        (status == HttpStatus.unauthorized ||
            status == HttpStatus.badRequest)) {
      throw AuthException(
        AuthErrorKind.invalidCredentials,
        appLocalizations.authErrorInvalidCredentials,
      );
    }
    throw _mapStatus(status);
  }

  /// Fetches the current user's email and subscription URL using the token.
  Future<({String email, String subscriptionUrl})> getMe(String token) async {
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
    if (status == HttpStatus.unauthorized) {
      throw AuthException(
        AuthErrorKind.invalidCredentials,
        appLocalizations.authErrorInvalidCredentials,
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
    final subscriptionUrl = (data['subscription_url'] as String?) ?? '';
    if (subscriptionUrl.isEmpty) {
      throw AuthException(
        AuthErrorKind.server,
        appLocalizations.authErrorServer,
      );
    }
    return (
      email: (data['email'] as String?) ?? '',
      subscriptionUrl: subscriptionUrl,
    );
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
