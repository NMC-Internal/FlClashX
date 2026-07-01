import 'dart:async';
import 'dart:convert';

import 'package:flclashx/models/models.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'constant.dart';

class Preferences {

  factory Preferences() {
    _instance ??= Preferences._internal();
    return _instance!;
  }

  Preferences._internal() {
    SharedPreferences.getInstance()
        .then((value) => sharedPreferencesCompleter.complete(value))
        .onError((_, __) => sharedPreferencesCompleter.complete(null));
  }
  static Preferences? _instance;
  Completer<SharedPreferences?> sharedPreferencesCompleter = Completer();

  // Auth credentials (access + refresh token, ADR 0021) live in the platform
  // Keychain/Keystore, not plaintext SharedPreferences.
  final FlutterSecureStorage _secureStorage = const FlutterSecureStorage(
    aOptions: AndroidOptions(encryptedSharedPreferences: true),
  );

  Future<bool> get isInit async =>
      await sharedPreferencesCompleter.future != null;

  Future<ClashConfig?> getClashConfig() async {
    final preferences = await sharedPreferencesCompleter.future;
    final clashConfigString = preferences?.getString(clashConfigKey);
    if (clashConfigString == null) return null;
    final clashConfigMap = json.decode(clashConfigString);
    return ClashConfig.fromJson(clashConfigMap);
  }

  Future<Config?> getConfig() async {
    final preferences = await sharedPreferencesCompleter.future;
    final configString = preferences?.getString(configKey);
    if (configString == null) return null;
    final configMap = json.decode(configString);
    return Config.compatibleFromJson(configMap);
  }

  Future<bool> saveConfig(Config config) async {
    final preferences = await sharedPreferencesCompleter.future;
    return await preferences?.setString(
          configKey,
          json.encode(config),
        ) ??
        false;
  }

  Future<void> clearClashConfig() async {
    final preferences = await sharedPreferencesCompleter.future;
    preferences?.remove(clashConfigKey);
  }

  // Auth token (access JWT) — stored in secure storage (ADR 0021). Any legacy
  // token still sitting in plaintext SharedPreferences is migrated on first read
  // (read-old → write-new → clear-old) so existing users are not logged out.
  Future<String?> getAuthToken() async {
    final secure = await _secureStorage.read(key: authTokenKey);
    if (secure != null) return secure;
    return _migrateLegacyAuthToken();
  }

  Future<bool> setAuthToken(String token) async {
    await _secureStorage.write(key: authTokenKey, value: token);
    return true;
  }

  Future<void> clearAuthToken() async {
    await _secureStorage.delete(key: authTokenKey);
    // Also drop any legacy plaintext copy so it can't resurface.
    final preferences = await sharedPreferencesCompleter.future;
    await preferences?.remove(authTokenKey);
  }

  // Refresh token (opaque, long-lived, ADR 0021) — secure storage only, never
  // written to SharedPreferences.
  Future<String?> getRefreshToken() async =>
      _secureStorage.read(key: refreshTokenKey);

  Future<bool> setRefreshToken(String token) async {
    await _secureStorage.write(key: refreshTokenKey, value: token);
    return true;
  }

  Future<void> clearRefreshToken() async {
    await _secureStorage.delete(key: refreshTokenKey);
  }

  /// Stores the (access, refresh) pair together, e.g. after sign-in or a
  /// successful refresh. A null [refreshToken] leaves any existing one intact
  /// (the backend may omit it), but the normal flow always supplies both.
  Future<void> setAuthTokens(String accessToken, String? refreshToken) async {
    await setAuthToken(accessToken);
    if (refreshToken != null && refreshToken.isNotEmpty) {
      await setRefreshToken(refreshToken);
    }
  }

  /// Clears every auth credential (access + refresh, plaintext + secure). Called
  /// on logout and on session expiry.
  Future<void> clearAuthTokens() async {
    await clearAuthToken();
    await clearRefreshToken();
  }

  /// One-time migration of a pre-ADR-0021 plaintext access token from
  /// SharedPreferences into secure storage. Returns the migrated token (or null
  /// if there was none). Idempotent: once moved, the old key is removed.
  Future<String?> _migrateLegacyAuthToken() async {
    final preferences = await sharedPreferencesCompleter.future;
    final legacy = preferences?.getString(authTokenKey);
    if (legacy == null || legacy.isEmpty) return null;
    await _secureStorage.write(key: authTokenKey, value: legacy);
    await preferences?.remove(authTokenKey);
    return legacy;
  }

  Future<String?> getUserEmail() async {
    final preferences = await sharedPreferencesCompleter.future;
    return preferences?.getString(userEmailKey);
  }

  Future<bool> setUserEmail(String email) async {
    final preferences = await sharedPreferencesCompleter.future;
    return await preferences?.setString(userEmailKey, email) ?? false;
  }

  Future<void> clearUserEmail() async {
    final preferences = await sharedPreferencesCompleter.future;
    await preferences?.remove(userEmailKey);
  }

  Future<void> clearPreferences() async {
    final sharedPreferencesIns = await sharedPreferencesCompleter.future;
    sharedPreferencesIns?.clear();
    // SharedPreferences.clear() doesn't touch the Keychain/Keystore, so wipe the
    // secure-storage credentials explicitly (ADR 0021).
    await clearAuthTokens();
  }
}

final preferences = Preferences();
