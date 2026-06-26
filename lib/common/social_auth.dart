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

  /// Tears down any persisted native session for this provider (called on
  /// logout). Must be a safe no-op when nothing is signed in.
  Future<void> signOut();
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
    final signIn = _nativeClient();
    if (signIn == null) {
      throw const SocialAuthException(
        'Google iOS/macOS client ID is not configured (GOOGLE_IOS_CLIENT_ID)',
      );
    }
    // Clear any persisted session BEFORE signing in. google_sign_in caches the
    // Google account (refresh token) in the platform keychain and silently
    // replays it, so a session minted under a previous OAuth client survives
    // app logout/reinstall and yields an ID token whose `aud` the backend
    // rejects. Signing out first forces a fresh account pick and a token minted
    // under the CURRENT client, and lets the user switch Google accounts.
    try {
      await signIn.signOut();
    } catch (_) {
      // No cached session (or offline) — nothing to clear; sign in interactively.
    }
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

  /// Clears the cached native Google session (Android/iOS/macOS); safe to call
  /// when nothing is signed in, and a no-op on Windows/Linux (the browser flow
  /// keeps no client-side session — the backend exchanges the auth code).
  @override
  Future<void> signOut() async {
    final signIn = _nativeClient();
    if (signIn == null) return;
    try {
      await signIn.signOut();
    } catch (_) {
      // Nothing signed in (or offline) — there is nothing to tear down.
    }
  }

  /// Builds the configured native client, or `null` on Apple platforms when the
  /// client ID is missing — constructing GoogleSignIn there triggers an
  /// uncatchable native "No active configuration" crash, so callers must guard.
  /// Also `null` off the native platforms (Windows/Linux use the browser flow).
  /// Android resolves its client from google-services.json + the signing SHA, so
  /// it takes no runtime clientId.
  GoogleSignIn? _nativeClient() {
    if (!(Platform.isAndroid || Platform.isIOS || Platform.isMacOS)) return null;
    final isApple = Platform.isIOS || Platform.isMacOS;
    if (isApple && googleIosClientId.isEmpty) return null;
    return GoogleSignIn(
      // clientId = the iOS/macOS OAuth client (Apple only). Becomes the
      // GIDConfiguration's client identifier the native SDK requires.
      clientId: isApple ? googleIosClientId : null,
      // serverClientId = the Web OAuth client; makes the issued ID token's
      // audience match what the backend validates.
      serverClientId: googleServerClientId.isEmpty ? null : googleServerClientId,
      scopes: const ['openid', 'email', 'profile'],
    );
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
    const redirectUri = 'http://127.0.0.1:$_desktopPort';

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
