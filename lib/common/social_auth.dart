import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:crypto/crypto.dart';
import 'package:flclashx/common/constant.dart';
import 'package:flutter/services.dart';
import 'package:flutter_web_auth_2/flutter_web_auth_2.dart';
import 'package:google_sign_in/google_sign_in.dart';

/// Social-login providers (ADR 0014). Apple lands later as another implementation.
enum SocialProvider { google, apple }

/// A social sign-in failure that is safe to surface to the user. Distinct from a
/// user cancellation, which is represented by a `null` credential (not an error).
class SocialAuthException implements Exception {
  const SocialAuthException(this.message);
  final String message;
  @override
  String toString() => 'SocialAuthException: $message';
}

/// The result of a provider sign-in. On Android/iOS/macOS the native SDK yields
/// an [IdTokenCredential] directly; on Windows/Linux the browser flow yields an
/// [AuthCodeCredential] that the BACKEND exchanges (the OAuth secret stays
/// server-side — never in the client).
sealed class SocialCredential {}

class IdTokenCredential extends SocialCredential {
  IdTokenCredential(this.idToken);
  final String idToken;
}

class AuthCodeCredential extends SocialCredential {
  AuthCodeCredential({
    required this.code,
    required this.codeVerifier,
    required this.redirectUri,
  });
  final String code;
  final String codeVerifier;
  final String redirectUri;
}

/// Obtains a provider credential. Returns `null` when the user cancels; throws
/// [SocialAuthException] on a real failure.
abstract interface class SocialAuthProvider {
  SocialProvider get provider;
  Future<SocialCredential?> obtainCredential();
}

/// Google sign-in. Native `google_sign_in` on Android/iOS/macOS; a maintained
/// browser flow (`flutter_web_auth_2`) on Windows/Linux that returns an auth
/// code for the backend to exchange.
class GoogleAuthProvider implements SocialAuthProvider {
  const GoogleAuthProvider();

  // Fixed loopback port for the desktop browser redirect. Google "Desktop app"
  // clients accept any 127.0.0.1 port; flutter_web_auth_2 needs it in the scheme.
  static const _desktopPort = 8765;

  @override
  SocialProvider get provider => SocialProvider.google;

  @override
  Future<SocialCredential?> obtainCredential() {
    if (Platform.isAndroid || Platform.isIOS || Platform.isMacOS) {
      return _nativeIdToken();
    }
    if (Platform.isWindows || Platform.isLinux) {
      return _desktopAuthCode();
    }
    throw const SocialAuthException('Google sign-in is not supported on this platform');
  }

  // ── Android / iOS / macOS: native plugin (no secret) ───────────────────────
  Future<SocialCredential?> _nativeIdToken() async {
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
      return IdTokenCredential(idToken);
    } on SocialAuthException {
      rethrow;
    } catch (e) {
      throw SocialAuthException('Google sign-in failed: $e');
    }
  }

  // ── Windows / Linux: browser PKCE → auth code (backend exchanges it) ────────
  Future<SocialCredential?> _desktopAuthCode() async {
    if (googleDesktopClientId.isEmpty) {
      throw const SocialAuthException('Google desktop client ID is not configured');
    }

    final verifier = _randomUrlSafe(32);
    final challenge = base64Url
        .encode(sha256.convert(ascii.encode(verifier)).bytes)
        .replaceAll('=', '');
    final state = _randomUrlSafe(24);
    final redirectUri = 'http://127.0.0.1:$_desktopPort';

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

    final String result;
    try {
      result = await FlutterWebAuth2.authenticate(
        url: authUrl.toString(),
        callbackUrlScheme: redirectUri,
      );
    } on PlatformException catch (e) {
      if (e.code == 'CANCELED') return null; // user cancelled
      throw SocialAuthException('Google sign-in failed: ${e.message}');
    }

    final params = Uri.parse(result).queryParameters;
    if (params['error'] != null) {
      throw SocialAuthException('Google returned an error: ${params['error']}');
    }
    if (params['state'] != state) {
      throw const SocialAuthException('OAuth state mismatch');
    }
    final code = params['code'];
    if (code == null || code.isEmpty) return null;

    return AuthCodeCredential(code: code, codeVerifier: verifier, redirectUri: redirectUri);
  }

  static String _randomUrlSafe(int bytes) {
    final rnd = Random.secure();
    final buf = List<int>.generate(bytes, (_) => rnd.nextInt(256));
    return base64Url.encode(buf).replaceAll('=', '');
  }
}

/// The Google provider singleton used by the auth sheet.
const googleAuth = GoogleAuthProvider();
