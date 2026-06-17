import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:crypto/crypto.dart';
import 'package:flclashx/common/constant.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';

/// Social-login providers (ADR 0014). Apple lands later as another implementation.
enum SocialProvider { google, apple }

/// A social sign-in failure that is safe to surface to the user. Distinct from a
/// user cancellation, which is represented by a `null` id-token (not an error).
class SocialAuthException implements Exception {
  const SocialAuthException(this.message);
  final String message;
  @override
  String toString() => 'SocialAuthException: $message';
}

/// Obtains a provider ID token to exchange with our backend. Returns `null` when
/// the user cancels; throws [SocialAuthException] on a real failure.
abstract interface class SocialAuthProvider {
  SocialProvider get provider;
  Future<String?> obtainIdToken();
}

/// Google sign-in. Uses the native `google_sign_in` plugin on Android/iOS and a
/// PKCE OAuth loopback (system browser + localhost listener) on desktop
/// (macOS/Windows/Linux), where the plugin isn't available.
class GoogleAuthProvider implements SocialAuthProvider {
  const GoogleAuthProvider();

  @override
  SocialProvider get provider => SocialProvider.google;

  @override
  Future<String?> obtainIdToken() {
    if (Platform.isAndroid || Platform.isIOS) {
      return _pluginIdToken();
    }
    return _desktopLoopbackIdToken();
  }

  // ── Mobile: native plugin ──────────────────────────────────────────────────
  Future<String?> _pluginIdToken() async {
    final signIn = GoogleSignIn(
      // serverClientId = the Web OAuth client; makes the issued ID token's
      // audience match what the backend validates.
      serverClientId: googleServerClientId.isEmpty ? null : googleServerClientId,
      scopes: const ['openid', 'email', 'profile'],
    );
    try {
      final account = await signIn.signIn();
      if (account == null) return null; // cancelled
      final auth = await account.authentication;
      final idToken = auth.idToken;
      if (idToken == null || idToken.isEmpty) {
        throw const SocialAuthException('Google returned no ID token');
      }
      return idToken;
    } on SocialAuthException {
      rethrow;
    } catch (e) {
      throw SocialAuthException('Google sign-in failed: $e');
    }
  }

  // ── Desktop: PKCE loopback ─────────────────────────────────────────────────
  Future<String?> _desktopLoopbackIdToken() async {
    if (googleDesktopClientId.isEmpty) {
      throw const SocialAuthException('Google desktop client ID is not configured');
    }

    final verifier = _randomUrlSafe(32);
    final challenge = base64Url
        .encode(sha256.convert(ascii.encode(verifier)).bytes)
        .replaceAll('=', '');
    final state = _randomUrlSafe(24);

    final server = await HttpServer.bind(InternetAddress.loopbackIPv4, 0);
    final redirectUri = 'http://127.0.0.1:${server.port}';

    final authUrl = Uri.https('accounts.google.com', '/o/oauth2/v2/auth', {
      'response_type': 'code',
      'client_id': googleDesktopClientId,
      'redirect_uri': redirectUri,
      'scope': 'openid email profile',
      'code_challenge': challenge,
      'code_challenge_method': 'S256',
      'state': state,
      'prompt': 'select_account',
    });

    if (!await launchUrl(authUrl, mode: LaunchMode.externalApplication)) {
      await server.close(force: true);
      throw const SocialAuthException('Could not open the browser for Google sign-in');
    }

    final code = await _awaitRedirectCode(server, state);
    if (code == null) return null; // cancelled / no code

    return _exchangeCode(code, verifier, redirectUri);
  }

  Future<String?> _awaitRedirectCode(HttpServer server, String expectedState) async {
    try {
      await for (final request in server) {
        final params = request.uri.queryParameters;
        request.response
          ..statusCode = HttpStatus.ok
          ..headers.contentType = ContentType.html
          ..write(_closePageHtml);
        await request.response.close();

        final error = params['error'];
        if (error != null) {
          throw SocialAuthException('Google returned an error: $error');
        }
        if (params['state'] != expectedState) {
          throw const SocialAuthException('OAuth state mismatch');
        }
        return params['code'];
      }
    } finally {
      await server.close(force: true);
    }
    return null;
  }

  Future<String?> _exchangeCode(String code, String verifier, String redirectUri) async {
    final resp = await http.post(
      Uri.https('oauth2.googleapis.com', '/token'),
      body: {
        'grant_type': 'authorization_code',
        'code': code,
        'client_id': googleDesktopClientId,
        if (googleDesktopClientSecret.isNotEmpty)
          'client_secret': googleDesktopClientSecret,
        'redirect_uri': redirectUri,
        'code_verifier': verifier,
      },
    );
    if (resp.statusCode != HttpStatus.ok) {
      throw SocialAuthException('Token exchange failed (${resp.statusCode})');
    }
    final body = jsonDecode(resp.body);
    final idToken = body is Map ? body['id_token'] : null;
    if (idToken is! String || idToken.isEmpty) {
      throw const SocialAuthException('No ID token in the token response');
    }
    return idToken;
  }

  static String _randomUrlSafe(int bytes) {
    final rnd = Random.secure();
    final buf = List<int>.generate(bytes, (_) => rnd.nextInt(256));
    return base64Url.encode(buf).replaceAll('=', '');
  }

  static const _closePageHtml =
      '<!doctype html><html><body style="font-family:sans-serif;text-align:center;padding-top:3rem">'
      '<h2>Fantomask VPN</h2><p>You can close this window and return to the app.</p>'
      '</body></html>';
}

/// The Google provider singleton used by the auth sheet.
const googleAuth = GoogleAuthProvider();
