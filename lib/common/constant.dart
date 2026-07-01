import 'dart:io';
import 'dart:math';
import 'dart:ui';

import 'package:collection/collection.dart';
import 'package:flclashx/common/common.dart';
import 'package:flclashx/enum/enum.dart';
import 'package:flclashx/models/models.dart';
import 'package:flutter/material.dart';

const appName = "Fantomask VPN";
const appHelperService = "FlClashHelperService";
const coreName = "clashx.meta";
const browserUa =
    "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/120.0.0.0 Safari/537.36";
const packageName = "net.fantomask.vpn";
// Backend base URL is injected at build time via
// `--dart-define=BACKEND_URL=https://...`. Defaults to the local dev backend.
const backendBaseUrl = String.fromEnvironment(
  'BACKEND_URL',
  defaultValue: 'http://127.0.0.1:8080',
);

// Google OAuth (ADR 0014), injected at build time via --dart-define. No client
// secret is needed here — Android/iOS/macOS use native clients (no secret), and
// the Windows/Linux desktop flow only builds the auth URL with the desktop
// client ID; the code is exchanged on the backend (which holds the secret).
// - googleServerClientId: the Web client ID, passed to google_sign_in on mobile
//   so the issued ID token's audience matches what the backend validates.
// - googleIosClientId: the iOS/macOS OAuth client ID. The native GoogleSignIn SDK
//   needs it to build its configuration; without it the SDK throws "No active
//   configuration" (it is the GIDClientID, supplied here instead of Info.plist).
//   Not a secret — iOS/macOS client IDs are public. Empty on Android (the native
//   client there is resolved from google-services.json + the signing SHA).
// - googleDesktopClientId: the "Desktop app" client ID for the Windows/Linux
//   browser PKCE flow.
const googleServerClientId = String.fromEnvironment('GOOGLE_SERVER_CLIENT_ID');
const googleIosClientId = String.fromEnvironment('GOOGLE_IOS_CLIENT_ID');
const googleDesktopClientId = String.fromEnvironment('GOOGLE_DESKTOP_CLIENT_ID');
final unixSocketPath = "/tmp/FlClashXSocket_${Random().nextInt(10000)}.sock";
const helperPort = 47890;
const maxTextScale = 1.4;
const minTextScale = 0.8;
final baseInfoEdgeInsets = EdgeInsets.symmetric(
  vertical: 16.ap,
  horizontal: 16.ap,
);

final defaultTextScaleFactor =
    WidgetsBinding.instance.platformDispatcher.textScaleFactor;
const httpTimeoutDuration = Duration(milliseconds: 5000);
const moreDuration = Duration(milliseconds: 100);
const animateDuration = Duration(milliseconds: 100);
const midDuration = Duration(milliseconds: 200);
const commonDuration = Duration(milliseconds: 300);
const defaultUpdateDuration = Duration(days: 1);
const mmdbFileName = "geoip.metadb";
const asnFileName = "ASN.mmdb";
const geoIpFileName = "GeoIP.dat";
const geoSiteFileName = "GeoSite.dat";
final double kHeaderHeight = system.isDesktop
    ? !Platform.isMacOS
        ? 40
        : 28
    : 0;
const profilesDirectoryName = "profiles";
const localhost = "127.0.0.1";
const clashConfigKey = "clash_config";
const configKey = "config";
const authTokenKey = "auth_token";
// Long-lived opaque refresh token (ADR 0021). Stored, like the access token, in
// flutter_secure_storage (Keychain/Keystore) — never plaintext.
const refreshTokenKey = "refresh_token";
const userEmailKey = "user_email";
const double dialogCommonWidth = 300;
const repository = "pluralplay/FlClashX";
const defaultExternalController = "127.0.0.1:9090";
const maxMobileWidth = 600;
const maxLaptopWidth = 840;
const defaultTestUrl = "https://www.gstatic.com/generate_204";
final commonFilter = ImageFilter.blur(
  sigmaX: 2.5,
  sigmaY: 2.5,
  tileMode: TileMode.mirror,
);

const navigationItemListEquality = ListEquality<NavigationItem>();
const connectionListEquality = ListEquality<Connection>();
const stringListEquality = ListEquality<String>();
const intListEquality = ListEquality<int>();
const logListEquality = ListEquality<Log>();
const groupListEquality = ListEquality<Group>();
const externalProviderListEquality = ListEquality<ExternalProvider>();
const packageListEquality = ListEquality<Package>();
const hotKeyActionListEquality = ListEquality<HotKeyAction>();
const stringAndStringMapEquality = MapEquality<String, String>();
const stringAndStringMapEntryIterableEquality =
    IterableEquality<MapEntry<String, String>>();
const delayMapEquality = MapEquality<String, Map<String, int?>>();
const stringSetEquality = SetEquality<String>();
const keyboardModifierListEquality = SetEquality<KeyboardModifier>();

const viewModeColumnsMap = {
  ViewMode.mobile: [2, 1],
  ViewMode.laptop: [3, 2],
  ViewMode.desktop: [4, 3],
};

// const proxiesStoreKey = PageStorageKey<String>('proxies');
// const toolsStoreKey = PageStorageKey<String>('tools');
// const profilesStoreKey = PageStorageKey<String>('profiles');

const defaultPrimaryColor = 0xFF40C987;

double getWidgetHeight(num lines) => max(lines * 84 + (lines - 1) * 16, 0).ap;

const maxLength = 150;

const mainIsolate = "FlClashXMainIsolate";

const serviceIsolate = "FlClashXServiceIsolate";

const defaultPrimaryColors = [
  defaultPrimaryColor,
  0xFF2E86DE,
  0xFF2FD3A6,
  0xFFF2A93B,
  0xFF6C7A89,
];

const scriptTemplate = """
const main = (config) => {
  return config;
}""";
