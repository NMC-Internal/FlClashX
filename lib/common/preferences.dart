import 'dart:async';
import 'dart:convert';

import 'package:flclashx/models/models.dart';
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

  // TODO(auth): the auth token is currently stored in SharedPreferences for
  // simplicity. Migrate to flutter_secure_storage (Keychain/Keystore) once that
  // dependency is added, since a JWT is a sensitive credential.
  Future<String?> getAuthToken() async {
    final preferences = await sharedPreferencesCompleter.future;
    return preferences?.getString(authTokenKey);
  }

  Future<bool> setAuthToken(String token) async {
    final preferences = await sharedPreferencesCompleter.future;
    return await preferences?.setString(authTokenKey, token) ?? false;
  }

  Future<void> clearAuthToken() async {
    final preferences = await sharedPreferencesCompleter.future;
    await preferences?.remove(authTokenKey);
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
  }
}

final preferences = Preferences();
