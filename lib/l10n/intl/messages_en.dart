// DO NOT EDIT. This is code generated via package:intl/generate_localized.dart
// This is a library that provides messages for a en locale. All the
// messages from the main program should be duplicated here with the same
// function name.

// Ignore issues from commonly used lints in this file.
// ignore_for_file:unnecessary_brace_in_string_interps, unnecessary_new
// ignore_for_file:prefer_single_quotes,comment_references, directives_ordering
// ignore_for_file:annotate_overrides,prefer_generic_function_type_aliases
// ignore_for_file:unused_import, file_names, avoid_escaping_inner_quotes
// ignore_for_file:unnecessary_string_interpolations, unnecessary_string_escapes

import 'package:intl/intl.dart';
import 'package:intl/message_lookup_by_library.dart';

final messages = new MessageLookup();

typedef String MessageIfAbsent(String messageStr, List<dynamic> args);

class MessageLookup extends MessageLookupByLibrary {
  String get localeName => 'en';

  static String m0(app) => "About ${app}";

  static String m1(days, date) => "Expires in ${days} days · ${date}";

  static String m2(limit) => "of ${limit}";

  static String m3(used, total) => "${used} of ${total} used";

  static String m4(duration) => "Connected · ${duration}";

  static String m5(label) =>
      "Are you sure you want to delete the selected ${label}?";

  static String m6(label) =>
      "Are you sure you want to delete the current ${label}?";

  static String m7(label) => "${label} cannot be empty";

  static String m8(label) => "Current ${label} already exists";

  static String m9(code) => "Open the bot and send this code: ${code}";

  static String m10(label) => "No ${label} at the moment";

  static String m11(label) => "${label} must be a number";

  static String m12(days) => "${days} days access";

  static String m13(count) => "${count} device";

  static String m14(count) => "${count} devices";

  static String m15(name) => "${name} plan";

  static String m16(size) => "${size} traffic";

  static String m17(label) => "${label} must be between 1024 and 49151";

  static String m18(days) => "Welcome bonus applied: +${days} days";

  static String m19(percent) => "Commission: ${percent}%";

  static String m20(days) => "Earned: ${days} days";

  static String m21(count) => "Invited: ${count}";

  static String m22(count) => "${count} items have been selected";

  static String m23(days) => "Your subscription expires in ${days} day(s)";

  static String m24(label) => "${label} must be a url";

  final messages = _notInlinedMessages(_notInlinedMessages);
  static Map<String, Function> _notInlinedMessages(_) => <String, Function>{
    "about": MessageLookupByLibrary.simpleMessage("About"),
    "aboutApp": m0,
    "accessControl": MessageLookupByLibrary.simpleMessage("AccessControl"),
    "accessControlAllowDesc": MessageLookupByLibrary.simpleMessage(
      "Only allow selected app to enter VPN",
    ),
    "accessControlDesc": MessageLookupByLibrary.simpleMessage(
      "Configure application access proxy",
    ),
    "accessControlNotAllowDesc": MessageLookupByLibrary.simpleMessage(
      "The selected application will be excluded from VPN",
    ),
    "account": MessageLookupByLibrary.simpleMessage("Account"),
    "accountEmailUnknown": MessageLookupByLibrary.simpleMessage(
      "Unknown email",
    ),
    "accountExpiresInDays": m1,
    "accountLoadError": MessageLookupByLibrary.simpleMessage(
      "Could not load your account.",
    ),
    "accountNoSubscription": MessageLookupByLibrary.simpleMessage(
      "No active subscription yet",
    ),
    "accountOfLimit": m2,
    "accountSignedIn": MessageLookupByLibrary.simpleMessage("Signed in"),
    "accountTrafficRemaining": m3,
    "action": MessageLookupByLibrary.simpleMessage("Action"),
    "action_mode": MessageLookupByLibrary.simpleMessage("Switch mode"),
    "action_proxy": MessageLookupByLibrary.simpleMessage("System proxy"),
    "action_start": MessageLookupByLibrary.simpleMessage("Start/Stop"),
    "action_tun": MessageLookupByLibrary.simpleMessage("TUN"),
    "action_view": MessageLookupByLibrary.simpleMessage("Show/Hide"),
    "activityDailyTraffic": MessageLookupByLibrary.simpleMessage(
      "Daily traffic",
    ),
    "activityDemo": MessageLookupByLibrary.simpleMessage("demo"),
    "activityDownloaded": MessageLookupByLibrary.simpleMessage("Downloaded"),
    "activityDuration": MessageLookupByLibrary.simpleMessage("Duration"),
    "activityLive": MessageLookupByLibrary.simpleMessage("Live"),
    "activityThroughput": MessageLookupByLibrary.simpleMessage("Throughput"),
    "activityUploaded": MessageLookupByLibrary.simpleMessage("Uploaded"),
    "activityUsageWeek": MessageLookupByLibrary.simpleMessage(
      "Usage · last 7 days",
    ),
    "add": MessageLookupByLibrary.simpleMessage("Add"),
    "addRule": MessageLookupByLibrary.simpleMessage("Add rule"),
    "addedOriginRules": MessageLookupByLibrary.simpleMessage(
      "Attach on the original rules",
    ),
    "address": MessageLookupByLibrary.simpleMessage("Address"),
    "addressHelp": MessageLookupByLibrary.simpleMessage(
      "WebDAV server address",
    ),
    "addressTip": MessageLookupByLibrary.simpleMessage(
      "Please enter a valid WebDAV address",
    ),
    "adminAutoLaunch": MessageLookupByLibrary.simpleMessage(
      "Admin auto launch",
    ),
    "adminAutoLaunchDesc": MessageLookupByLibrary.simpleMessage(
      "Boot up by using admin mode",
    ),
    "ago": MessageLookupByLibrary.simpleMessage(" Ago"),
    "agree": MessageLookupByLibrary.simpleMessage("Agree"),
    "allApps": MessageLookupByLibrary.simpleMessage("All apps"),
    "allowBypass": MessageLookupByLibrary.simpleMessage(
      "Allow applications to bypass VPN",
    ),
    "allowBypassDesc": MessageLookupByLibrary.simpleMessage(
      "Some apps can bypass VPN when turned on",
    ),
    "allowLan": MessageLookupByLibrary.simpleMessage("AllowLan"),
    "allowLanDesc": MessageLookupByLibrary.simpleMessage(
      "Allow access proxy through the LAN",
    ),
    "announcement": MessageLookupByLibrary.simpleMessage("Announcement"),
    "app": MessageLookupByLibrary.simpleMessage("App"),
    "appAccessControl": MessageLookupByLibrary.simpleMessage(
      "App access control",
    ),
    "appDesc": MessageLookupByLibrary.simpleMessage(
      "Processing app related settings",
    ),
    "appleComingSoon": MessageLookupByLibrary.simpleMessage(
      "Continue with Apple (soon)",
    ),
    "application": MessageLookupByLibrary.simpleMessage("Application Settings"),
    "applicationDesc": MessageLookupByLibrary.simpleMessage(
      "Standard application settings",
    ),
    "authEmailInvalid": MessageLookupByLibrary.simpleMessage(
      "Please enter a valid email",
    ),
    "authEmailRequired": MessageLookupByLibrary.simpleMessage(
      "Please enter your email",
    ),
    "authErrorNetwork": MessageLookupByLibrary.simpleMessage(
      "Network error. Please check your connection and try again",
    ),
    "authErrorServer": MessageLookupByLibrary.simpleMessage(
      "Server error. Please try again later",
    ),
    "authErrorSessionExpired": MessageLookupByLibrary.simpleMessage(
      "Session expired. Please sign in again",
    ),
    "authErrorUnknown": MessageLookupByLibrary.simpleMessage(
      "Something went wrong. Please try again",
    ),
    "authGoogleFailed": MessageLookupByLibrary.simpleMessage(
      "Could not sign in with Google. Please try again.",
    ),
    "authLegal": MessageLookupByLibrary.simpleMessage(
      "By continuing you agree to our Terms of Service and Privacy Policy.",
    ),
    "authPasswordRequired": MessageLookupByLibrary.simpleMessage(
      "Please enter your password",
    ),
    "authPasswordTooShort": MessageLookupByLibrary.simpleMessage(
      "Password must be at least 8 characters",
    ),
    "authSignInSubtitle": MessageLookupByLibrary.simpleMessage(
      "Sign in to claim your free trial and manage your subscription.",
    ),
    "authSignInTitle": MessageLookupByLibrary.simpleMessage("Sign in"),
    "auto": MessageLookupByLibrary.simpleMessage("Auto"),
    "autoCheckUpdate": MessageLookupByLibrary.simpleMessage(
      "Auto check updates",
    ),
    "autoCheckUpdateDesc": MessageLookupByLibrary.simpleMessage(
      "Auto check for updates when the app starts",
    ),
    "autoCloseConnections": MessageLookupByLibrary.simpleMessage(
      "Auto close connections",
    ),
    "autoCloseConnectionsDesc": MessageLookupByLibrary.simpleMessage(
      "Auto close connections after change node",
    ),
    "autoLaunch": MessageLookupByLibrary.simpleMessage("Auto launch"),
    "autoLaunchDesc": MessageLookupByLibrary.simpleMessage(
      "Follow the system self startup",
    ),
    "autoRun": MessageLookupByLibrary.simpleMessage("AutoRun"),
    "autoRunDesc": MessageLookupByLibrary.simpleMessage(
      "Auto run when the application is opened",
    ),
    "autoSetSystemDns": MessageLookupByLibrary.simpleMessage(
      "Auto set system DNS",
    ),
    "autoUpdate": MessageLookupByLibrary.simpleMessage("Auto update"),
    "autoUpdateInterval": MessageLookupByLibrary.simpleMessage(
      "Auto update interval (minutes)",
    ),
    "backup": MessageLookupByLibrary.simpleMessage("Backup"),
    "backupAndRecovery": MessageLookupByLibrary.simpleMessage(
      "Backup and Recovery",
    ),
    "backupAndRecoveryDesc": MessageLookupByLibrary.simpleMessage(
      "Sync data via WebDAV or file",
    ),
    "backupSuccess": MessageLookupByLibrary.simpleMessage("Backup success"),
    "basicConfig": MessageLookupByLibrary.simpleMessage("Basic configuration"),
    "basicConfigDesc": MessageLookupByLibrary.simpleMessage(
      "Modify the basic configuration globally",
    ),
    "billingNotActive": MessageLookupByLibrary.simpleMessage(
      "Billing is not active yet",
    ),
    "bind": MessageLookupByLibrary.simpleMessage("Bind"),
    "blacklistMode": MessageLookupByLibrary.simpleMessage("Blacklist mode"),
    "bypassDomain": MessageLookupByLibrary.simpleMessage("Bypass domain"),
    "bypassDomainDesc": MessageLookupByLibrary.simpleMessage(
      "Only takes effect when the system proxy is enabled",
    ),
    "cacheCorrupt": MessageLookupByLibrary.simpleMessage(
      "The cache is corrupt. Do you want to clear it?",
    ),
    "cancel": MessageLookupByLibrary.simpleMessage("Cancel"),
    "cancelFilterSystemApp": MessageLookupByLibrary.simpleMessage(
      "Cancel filter system app",
    ),
    "cancelSelectAll": MessageLookupByLibrary.simpleMessage(
      "Cancel select all",
    ),
    "changeServer": MessageLookupByLibrary.simpleMessage("Change Server"),
    "checkError": MessageLookupByLibrary.simpleMessage("Check error"),
    "checkUpdate": MessageLookupByLibrary.simpleMessage("Check for updates"),
    "checkUpdateError": MessageLookupByLibrary.simpleMessage(
      "The current application is already the latest version",
    ),
    "checking": MessageLookupByLibrary.simpleMessage("Checking..."),
    "chooseAPlan": MessageLookupByLibrary.simpleMessage("Choose a plan"),
    "choosePlan": MessageLookupByLibrary.simpleMessage("Choose plan"),
    "chooseServer": MessageLookupByLibrary.simpleMessage("Choose server"),
    "clearData": MessageLookupByLibrary.simpleMessage("Clear Data"),
    "clearDataTip": MessageLookupByLibrary.simpleMessage(
      "This will delete all app data and restart the application. Are you sure?",
    ),
    "clipboardExport": MessageLookupByLibrary.simpleMessage("Export clipboard"),
    "clipboardImport": MessageLookupByLibrary.simpleMessage("Clipboard import"),
    "color": MessageLookupByLibrary.simpleMessage("Color"),
    "colorSchemes": MessageLookupByLibrary.simpleMessage("Color schemes"),
    "columns": MessageLookupByLibrary.simpleMessage("Columns"),
    "compatible": MessageLookupByLibrary.simpleMessage("Compatibility mode"),
    "compatibleDesc": MessageLookupByLibrary.simpleMessage(
      "Opening it will lose part of its application ability and gain the support of full amount of Clash.",
    ),
    "confirm": MessageLookupByLibrary.simpleMessage("Confirm"),
    "connectConnected": MessageLookupByLibrary.simpleMessage("Connected"),
    "connectConnectedFor": m4,
    "connectExpiredHint": MessageLookupByLibrary.simpleMessage(
      "Renew to keep protecting your traffic",
    ),
    "connectExpiredTitle": MessageLookupByLibrary.simpleMessage(
      "Subscription expired",
    ),
    "connectExpiresLabel": MessageLookupByLibrary.simpleMessage("Expires"),
    "connectFailedHint": MessageLookupByLibrary.simpleMessage(
      "Something went wrong. Please try again.",
    ),
    "connectFailedTitle": MessageLookupByLibrary.simpleMessage(
      "Provisioning failed",
    ),
    "connectGetPlanHint": MessageLookupByLibrary.simpleMessage(
      "Get a plan to start protecting your traffic",
    ),
    "connectNotProtected": MessageLookupByLibrary.simpleMessage(
      "Not protected",
    ),
    "connectProtected": MessageLookupByLibrary.simpleMessage("Protected"),
    "connectProvisioning": MessageLookupByLibrary.simpleMessage(
      "Setting up your subscription…",
    ),
    "connectProvisioningHint": MessageLookupByLibrary.simpleMessage(
      "This usually takes a few seconds",
    ),
    "connectTapToConnect": MessageLookupByLibrary.simpleMessage(
      "Tap to connect",
    ),
    "connectionSettings": MessageLookupByLibrary.simpleMessage(
      "Connection settings",
    ),
    "connectionSettingsSub": MessageLookupByLibrary.simpleMessage(
      "General · Network · DNS",
    ),
    "connections": MessageLookupByLibrary.simpleMessage("Connections"),
    "connectionsDesc": MessageLookupByLibrary.simpleMessage(
      "View current connections data",
    ),
    "connectivity": MessageLookupByLibrary.simpleMessage("Connectivity："),
    "contactMe": MessageLookupByLibrary.simpleMessage("Contact me"),
    "content": MessageLookupByLibrary.simpleMessage("Content"),
    "contentScheme": MessageLookupByLibrary.simpleMessage("Content"),
    "continueWithGoogle": MessageLookupByLibrary.simpleMessage(
      "Continue with Google",
    ),
    "copy": MessageLookupByLibrary.simpleMessage("Copy"),
    "copyEnvVar": MessageLookupByLibrary.simpleMessage(
      "Copying environment variables",
    ),
    "copyLink": MessageLookupByLibrary.simpleMessage("Copy link"),
    "copySuccess": MessageLookupByLibrary.simpleMessage("Copy success"),
    "core": MessageLookupByLibrary.simpleMessage("Core"),
    "coreInfo": MessageLookupByLibrary.simpleMessage("Core info"),
    "country": MessageLookupByLibrary.simpleMessage("Country"),
    "crashTest": MessageLookupByLibrary.simpleMessage("Crash test"),
    "create": MessageLookupByLibrary.simpleMessage("Create"),
    "cut": MessageLookupByLibrary.simpleMessage("Cut"),
    "dark": MessageLookupByLibrary.simpleMessage("Dark"),
    "dashboard": MessageLookupByLibrary.simpleMessage("Dashboard"),
    "day": MessageLookupByLibrary.simpleMessage("day"),
    "days": MessageLookupByLibrary.simpleMessage("days"),
    "daysGenitive": MessageLookupByLibrary.simpleMessage("days"),
    "defaultNameserver": MessageLookupByLibrary.simpleMessage(
      "Default nameserver",
    ),
    "defaultNameserverDesc": MessageLookupByLibrary.simpleMessage(
      "For resolving DNS server",
    ),
    "defaultSort": MessageLookupByLibrary.simpleMessage("Sort by default"),
    "defaultText": MessageLookupByLibrary.simpleMessage("Default"),
    "delay": MessageLookupByLibrary.simpleMessage("Delay"),
    "delaySort": MessageLookupByLibrary.simpleMessage("Sort by delay"),
    "delete": MessageLookupByLibrary.simpleMessage("Delete"),
    "deleteMultipTip": m5,
    "deleteTip": m6,
    "desc": MessageLookupByLibrary.simpleMessage(
      "A multi-platform proxy client based on ClashMeta, simple and easy to use, open-source and ad-free.",
    ),
    "detectionTip": MessageLookupByLibrary.simpleMessage(
      "Relying on third-party api is for reference only",
    ),
    "developerMode": MessageLookupByLibrary.simpleMessage("Developer mode"),
    "developerModeEnableTip": MessageLookupByLibrary.simpleMessage(
      "Developer mode is enabled.",
    ),
    "direct": MessageLookupByLibrary.simpleMessage("Direct"),
    "discoverNewVersion": MessageLookupByLibrary.simpleMessage(
      "Discover the new version",
    ),
    "discovery": MessageLookupByLibrary.simpleMessage(
      "Discovery a new version",
    ),
    "dnsDesc": MessageLookupByLibrary.simpleMessage(
      "Update DNS related settings",
    ),
    "dnsMode": MessageLookupByLibrary.simpleMessage("DNS mode"),
    "doYouWantToPass": MessageLookupByLibrary.simpleMessage(
      "Adding profile from",
    ),
    "domain": MessageLookupByLibrary.simpleMessage("Domain"),
    "download": MessageLookupByLibrary.simpleMessage("Download"),
    "edit": MessageLookupByLibrary.simpleMessage("Edit"),
    "emptyTip": m7,
    "en": MessageLookupByLibrary.simpleMessage("English"),
    "enableLogs": MessageLookupByLibrary.simpleMessage("Enable logs"),
    "enableOverride": MessageLookupByLibrary.simpleMessage("Enable override"),
    "entries": MessageLookupByLibrary.simpleMessage(" entries"),
    "errorTitle": MessageLookupByLibrary.simpleMessage("Error"),
    "exclude": MessageLookupByLibrary.simpleMessage("Hidden from recent tasks"),
    "excludeDesc": MessageLookupByLibrary.simpleMessage(
      "When the app is in the background, the app is hidden from the recent task",
    ),
    "existsTip": m8,
    "exit": MessageLookupByLibrary.simpleMessage("Exit"),
    "expand": MessageLookupByLibrary.simpleMessage("Standard"),
    "expirationTime": MessageLookupByLibrary.simpleMessage("Expiration time"),
    "expiresOn": MessageLookupByLibrary.simpleMessage("Expires on"),
    "exportFile": MessageLookupByLibrary.simpleMessage("Export file"),
    "exportLogs": MessageLookupByLibrary.simpleMessage("Export logs"),
    "exportSuccess": MessageLookupByLibrary.simpleMessage("Export Success"),
    "expressiveScheme": MessageLookupByLibrary.simpleMessage("Expressive"),
    "externalController": MessageLookupByLibrary.simpleMessage(
      "ExternalController",
    ),
    "externalControllerDesc": MessageLookupByLibrary.simpleMessage(
      "Once enabled, the Clash kernel can be controlled on port 9090",
    ),
    "externalLink": MessageLookupByLibrary.simpleMessage("External link"),
    "externalResources": MessageLookupByLibrary.simpleMessage(
      "External resources",
    ),
    "fakeipFilter": MessageLookupByLibrary.simpleMessage("Fakeip filter"),
    "fakeipRange": MessageLookupByLibrary.simpleMessage("Fakeip range"),
    "fallback": MessageLookupByLibrary.simpleMessage("Fallback"),
    "fallbackDesc": MessageLookupByLibrary.simpleMessage(
      "Generally use offshore DNS",
    ),
    "fallbackFilter": MessageLookupByLibrary.simpleMessage("Fallback filter"),
    "fidelityScheme": MessageLookupByLibrary.simpleMessage("Fidelity"),
    "file": MessageLookupByLibrary.simpleMessage("File"),
    "fileDesc": MessageLookupByLibrary.simpleMessage("Directly upload profile"),
    "fileIsUpdate": MessageLookupByLibrary.simpleMessage(
      "The file has been modified. Do you want to save the changes?",
    ),
    "filterSystemApp": MessageLookupByLibrary.simpleMessage(
      "Filter system app",
    ),
    "findProcessMode": MessageLookupByLibrary.simpleMessage("Find process"),
    "findProcessModeDesc": MessageLookupByLibrary.simpleMessage(
      "There is a certain performance loss after opening",
    ),
    "fontFamily": MessageLookupByLibrary.simpleMessage("FontFamily"),
    "fourColumns": MessageLookupByLibrary.simpleMessage("Four columns"),
    "fruitSaladScheme": MessageLookupByLibrary.simpleMessage("FruitSalad"),
    "general": MessageLookupByLibrary.simpleMessage("General"),
    "generalDesc": MessageLookupByLibrary.simpleMessage(
      "Modify general settings",
    ),
    "geoData": MessageLookupByLibrary.simpleMessage("GeoData"),
    "geodataLoader": MessageLookupByLibrary.simpleMessage(
      "Geo Low Memory Mode",
    ),
    "geodataLoaderDesc": MessageLookupByLibrary.simpleMessage(
      "Enabling will use the Geo low memory loader",
    ),
    "geoipCode": MessageLookupByLibrary.simpleMessage("Geoip code"),
    "getOriginRules": MessageLookupByLibrary.simpleMessage(
      "Get original rules",
    ),
    "global": MessageLookupByLibrary.simpleMessage("Global"),
    "go": MessageLookupByLibrary.simpleMessage("Go"),
    "goDownload": MessageLookupByLibrary.simpleMessage("Go to download"),
    "gratitude": MessageLookupByLibrary.simpleMessage("Gratitude"),
    "hasCacheChange": MessageLookupByLibrary.simpleMessage(
      "Do you want to cache the changes?",
    ),
    "haveAccountLogin": MessageLookupByLibrary.simpleMessage(
      "Already have an account? Log in",
    ),
    "hostsDesc": MessageLookupByLibrary.simpleMessage("Add Hosts"),
    "hotkeyConflict": MessageLookupByLibrary.simpleMessage("Hotkey conflict"),
    "hotkeyManagement": MessageLookupByLibrary.simpleMessage(
      "Hotkey Management",
    ),
    "hotkeyManagementDesc": MessageLookupByLibrary.simpleMessage(
      "Use keyboard to control applications",
    ),
    "hour": MessageLookupByLibrary.simpleMessage("hour"),
    "hours": MessageLookupByLibrary.simpleMessage("Hours"),
    "hoursGenitive": MessageLookupByLibrary.simpleMessage("hours"),
    "hoursPlural": MessageLookupByLibrary.simpleMessage("hours"),
    "icon": MessageLookupByLibrary.simpleMessage("Icon"),
    "iconConfiguration": MessageLookupByLibrary.simpleMessage(
      "Icon configuration",
    ),
    "iconStyle": MessageLookupByLibrary.simpleMessage("Icon style"),
    "import": MessageLookupByLibrary.simpleMessage("Import"),
    "importFile": MessageLookupByLibrary.simpleMessage("Import from file"),
    "importFromURL": MessageLookupByLibrary.simpleMessage("Import from URL"),
    "importUrl": MessageLookupByLibrary.simpleMessage("Import from URL"),
    "infiniteTime": MessageLookupByLibrary.simpleMessage("Long term effective"),
    "init": MessageLookupByLibrary.simpleMessage("Init"),
    "inputCorrectHotkey": MessageLookupByLibrary.simpleMessage(
      "Please enter the correct hotkey",
    ),
    "intelligentSelected": MessageLookupByLibrary.simpleMessage(
      "Intelligent selection",
    ),
    "internet": MessageLookupByLibrary.simpleMessage("Internet"),
    "interval": MessageLookupByLibrary.simpleMessage("Interval"),
    "intranetIP": MessageLookupByLibrary.simpleMessage("Intranet IP"),
    "inviteFriends": MessageLookupByLibrary.simpleMessage("Invite friends"),
    "ipcidr": MessageLookupByLibrary.simpleMessage("Ipcidr"),
    "ipv6Desc": MessageLookupByLibrary.simpleMessage(
      "When turned on it will be able to receive IPv6 traffic",
    ),
    "ipv6InboundDesc": MessageLookupByLibrary.simpleMessage(
      "Allow IPv6 inbound",
    ),
    "ja": MessageLookupByLibrary.simpleMessage("Japanese"),
    "just": MessageLookupByLibrary.simpleMessage("Just"),
    "keepAliveIntervalDesc": MessageLookupByLibrary.simpleMessage(
      "Tcp keep alive interval",
    ),
    "key": MessageLookupByLibrary.simpleMessage("Key"),
    "langSystem": MessageLookupByLibrary.simpleMessage("System"),
    "language": MessageLookupByLibrary.simpleMessage("Language"),
    "launchAtStartup": MessageLookupByLibrary.simpleMessage(
      "Launch at startup",
    ),
    "layout": MessageLookupByLibrary.simpleMessage("Layout"),
    "light": MessageLookupByLibrary.simpleMessage("Light"),
    "linkTelegram": MessageLookupByLibrary.simpleMessage("Link Telegram"),
    "linkTelegramCode": m9,
    "list": MessageLookupByLibrary.simpleMessage("List"),
    "listen": MessageLookupByLibrary.simpleMessage("Listen"),
    "local": MessageLookupByLibrary.simpleMessage("Local"),
    "localBackupDesc": MessageLookupByLibrary.simpleMessage(
      "Backup local data to local",
    ),
    "localRecoveryDesc": MessageLookupByLibrary.simpleMessage(
      "Recovery data from file",
    ),
    "logLevel": MessageLookupByLibrary.simpleMessage("LogLevel"),
    "logcat": MessageLookupByLibrary.simpleMessage("Logcat"),
    "logcatDesc": MessageLookupByLibrary.simpleMessage(
      "Disabling will hide the log entry",
    ),
    "login": MessageLookupByLibrary.simpleMessage("Log in"),
    "logout": MessageLookupByLibrary.simpleMessage("Log out"),
    "logoutConfirm": MessageLookupByLibrary.simpleMessage(
      "Log out of your account? The subscription will be removed from this device.",
    ),
    "logs": MessageLookupByLibrary.simpleMessage("Logs"),
    "logsDesc": MessageLookupByLibrary.simpleMessage("Log capture records"),
    "logsTest": MessageLookupByLibrary.simpleMessage("Logs test"),
    "loopback": MessageLookupByLibrary.simpleMessage("Loopback unlock tool"),
    "loopbackDesc": MessageLookupByLibrary.simpleMessage(
      "Used for UWP loopback unlocking",
    ),
    "loose": MessageLookupByLibrary.simpleMessage("Loose"),
    "managedByProviderNetwork": MessageLookupByLibrary.simpleMessage(
      "These parameters are managed by your provider",
    ),
    "markAllRead": MessageLookupByLibrary.simpleMessage("Mark all read"),
    "memoryInfo": MessageLookupByLibrary.simpleMessage("Memory info"),
    "messageTest": MessageLookupByLibrary.simpleMessage("Message test"),
    "messageTestTip": MessageLookupByLibrary.simpleMessage(
      "This is a message.",
    ),
    "min": MessageLookupByLibrary.simpleMessage("Min"),
    "minimizeOnExit": MessageLookupByLibrary.simpleMessage("Minimize on exit"),
    "minimizeOnExitDesc": MessageLookupByLibrary.simpleMessage(
      "Modify the default system exit event",
    ),
    "minutes": MessageLookupByLibrary.simpleMessage("Minutes"),
    "mixedPort": MessageLookupByLibrary.simpleMessage("Mixed Port"),
    "mode": MessageLookupByLibrary.simpleMessage("Mode"),
    "monochromeScheme": MessageLookupByLibrary.simpleMessage("Monochrome"),
    "months": MessageLookupByLibrary.simpleMessage("Months"),
    "more": MessageLookupByLibrary.simpleMessage("More"),
    "name": MessageLookupByLibrary.simpleMessage("Name"),
    "nameSort": MessageLookupByLibrary.simpleMessage("Sort by name"),
    "nameserver": MessageLookupByLibrary.simpleMessage("Nameserver"),
    "nameserverDesc": MessageLookupByLibrary.simpleMessage(
      "For resolving domain",
    ),
    "nameserverPolicy": MessageLookupByLibrary.simpleMessage(
      "Nameserver policy",
    ),
    "nameserverPolicyDesc": MessageLookupByLibrary.simpleMessage(
      "Specify the corresponding nameserver policy",
    ),
    "navActivity": MessageLookupByLibrary.simpleMessage("Activity"),
    "navConnect": MessageLookupByLibrary.simpleMessage("Connect"),
    "navServers": MessageLookupByLibrary.simpleMessage("Servers"),
    "network": MessageLookupByLibrary.simpleMessage("Network"),
    "networkDesc": MessageLookupByLibrary.simpleMessage(
      "Modify network-related settings",
    ),
    "networkDetection": MessageLookupByLibrary.simpleMessage("Your IP Address"),
    "networkSpeed": MessageLookupByLibrary.simpleMessage("Network speed"),
    "neutralScheme": MessageLookupByLibrary.simpleMessage("Neutral"),
    "noAccountRegister": MessageLookupByLibrary.simpleMessage(
      "Don\'t have an account? Sign up",
    ),
    "noActiveSubscription": MessageLookupByLibrary.simpleMessage(
      "No active subscription",
    ),
    "noData": MessageLookupByLibrary.simpleMessage("No data"),
    "noHotKey": MessageLookupByLibrary.simpleMessage("No HotKey"),
    "noIcon": MessageLookupByLibrary.simpleMessage("None"),
    "noInfo": MessageLookupByLibrary.simpleMessage("No info"),
    "noMoreInfoDesc": MessageLookupByLibrary.simpleMessage("No more info"),
    "noNetwork": MessageLookupByLibrary.simpleMessage("No network"),
    "noNetworkApp": MessageLookupByLibrary.simpleMessage("No network APP"),
    "noProxy": MessageLookupByLibrary.simpleMessage("No proxy"),
    "noProxyDesc": MessageLookupByLibrary.simpleMessage(
      "Please create a profile or add a valid profile",
    ),
    "noResolve": MessageLookupByLibrary.simpleMessage("No resolve IP"),
    "noSubHint": MessageLookupByLibrary.simpleMessage(
      "Claim your free trial or choose a plan to get started.",
    ),
    "none": MessageLookupByLibrary.simpleMessage("none"),
    "notSelectedTip": MessageLookupByLibrary.simpleMessage(
      "The current proxy group cannot be selected.",
    ),
    "notSignedIn": MessageLookupByLibrary.simpleMessage("Not signed in"),
    "notifications": MessageLookupByLibrary.simpleMessage("Notifications"),
    "nullProfileDesc": MessageLookupByLibrary.simpleMessage(
      "No profile, Please add a profile",
    ),
    "nullScriptTip": MessageLookupByLibrary.simpleMessage("No scripts"),
    "nullTip": m10,
    "numberTip": m11,
    "oneColumn": MessageLookupByLibrary.simpleMessage("One column"),
    "oneline": MessageLookupByLibrary.simpleMessage("Oneline"),
    "onlyIcon": MessageLookupByLibrary.simpleMessage("Icon"),
    "onlyOtherApps": MessageLookupByLibrary.simpleMessage(
      "Only third-party apps",
    ),
    "onlyStatisticsProxy": MessageLookupByLibrary.simpleMessage(
      "Count only proxy traffic",
    ),
    "onlyStatisticsProxyDesc": MessageLookupByLibrary.simpleMessage(
      "When turned on, only proxy traffic will be counted in statistics",
    ),
    "openLogsFolder": MessageLookupByLibrary.simpleMessage("Open logs folder"),
    "options": MessageLookupByLibrary.simpleMessage("Options"),
    "originalRepository": MessageLookupByLibrary.simpleMessage(
      "Original Repository",
    ),
    "other": MessageLookupByLibrary.simpleMessage("Other"),
    "otherContributors": MessageLookupByLibrary.simpleMessage("Contributors"),
    "outboundMode": MessageLookupByLibrary.simpleMessage("Outbound mode"),
    "override": MessageLookupByLibrary.simpleMessage("Override"),
    "overrideDesc": MessageLookupByLibrary.simpleMessage(
      "Override Proxy related config",
    ),
    "overrideDns": MessageLookupByLibrary.simpleMessage("Override Dns"),
    "overrideDnsDesc": MessageLookupByLibrary.simpleMessage(
      "Turning it on will override the DNS options in the profile",
    ),
    "overrideInvalidTip": MessageLookupByLibrary.simpleMessage(
      "Does not take effect in script mode",
    ),
    "overrideOriginRules": MessageLookupByLibrary.simpleMessage(
      "Override the original rule",
    ),
    "overrideProviderSettings": MessageLookupByLibrary.simpleMessage(
      "Override",
    ),
    "overrideProviderSettingsDesc": MessageLookupByLibrary.simpleMessage(
      "Ignore provider settings and manage manually",
    ),
    "palette": MessageLookupByLibrary.simpleMessage("Palette"),
    "paste": MessageLookupByLibrary.simpleMessage("Paste"),
    "planBestValue": MessageLookupByLibrary.simpleMessage("Best value"),
    "planChoose": MessageLookupByLibrary.simpleMessage("Choose"),
    "planDaysAccess": m12,
    "planDevice": m13,
    "planDevices": m14,
    "planFree": MessageLookupByLibrary.simpleMessage("Free"),
    "planGeneric": MessageLookupByLibrary.simpleMessage("Subscription"),
    "planMonthly": MessageLookupByLibrary.simpleMessage("Monthly plan"),
    "planNamed": m15,
    "planOneTime": MessageLookupByLibrary.simpleMessage("One-time"),
    "planPerMonth": MessageLookupByLibrary.simpleMessage("/month"),
    "planPerYear": MessageLookupByLibrary.simpleMessage("/year"),
    "planTrafficAmount": m16,
    "planTrial": MessageLookupByLibrary.simpleMessage("Trial plan"),
    "planUnlimitedTraffic": MessageLookupByLibrary.simpleMessage(
      "Unlimited traffic",
    ),
    "planYearly": MessageLookupByLibrary.simpleMessage("Yearly plan"),
    "plansBillingNote": MessageLookupByLibrary.simpleMessage(
      "Prices shown for reference — billing is not yet active.",
    ),
    "plansLoadError": MessageLookupByLibrary.simpleMessage(
      "Could not load plans. Tap to retry.",
    ),
    "plansSubtitle": MessageLookupByLibrary.simpleMessage(
      "Protect your traffic. Cancel anytime.",
    ),
    "pleaseBindWebDAV": MessageLookupByLibrary.simpleMessage(
      "Please bind WebDAV",
    ),
    "pleaseEnterScriptName": MessageLookupByLibrary.simpleMessage(
      "Please enter a script name",
    ),
    "pleaseInputAdminPassword": MessageLookupByLibrary.simpleMessage(
      "Please enter the admin password",
    ),
    "pleaseUploadFile": MessageLookupByLibrary.simpleMessage(
      "Please upload file",
    ),
    "pleaseUploadValidQrcode": MessageLookupByLibrary.simpleMessage(
      "Please upload a valid QR code",
    ),
    "port": MessageLookupByLibrary.simpleMessage("Port"),
    "portConflictTip": MessageLookupByLibrary.simpleMessage(
      "Please enter a different port",
    ),
    "portTip": m17,
    "preferH3Desc": MessageLookupByLibrary.simpleMessage(
      "Prioritize the use of DOH\'s http/3",
    ),
    "pressKeyboard": MessageLookupByLibrary.simpleMessage(
      "Please press the keyboard.",
    ),
    "preview": MessageLookupByLibrary.simpleMessage("Preview"),
    "profile": MessageLookupByLibrary.simpleMessage("Profile"),
    "profileAutoUpdateIntervalInvalidValidationDesc":
        MessageLookupByLibrary.simpleMessage(
          "Please input a valid interval time format",
        ),
    "profileAutoUpdateIntervalNullValidationDesc":
        MessageLookupByLibrary.simpleMessage(
          "Please enter the auto update interval time",
        ),
    "profileHasUpdate": MessageLookupByLibrary.simpleMessage(
      "The profile has been modified. Do you want to disable auto update?",
    ),
    "profileNameNullValidationDesc": MessageLookupByLibrary.simpleMessage(
      "Please input the profile name",
    ),
    "profileParseErrorDesc": MessageLookupByLibrary.simpleMessage(
      "profile parse error",
    ),
    "profileUrlInvalidValidationDesc": MessageLookupByLibrary.simpleMessage(
      "Please input a valid profile URL",
    ),
    "profileUrlNullValidationDesc": MessageLookupByLibrary.simpleMessage(
      "Please input the profile URL",
    ),
    "profiles": MessageLookupByLibrary.simpleMessage("Profiles"),
    "profilesSort": MessageLookupByLibrary.simpleMessage("Profiles sort"),
    "project": MessageLookupByLibrary.simpleMessage("Project"),
    "promoApplied": MessageLookupByLibrary.simpleMessage("Promo code applied"),
    "promoApply": MessageLookupByLibrary.simpleMessage("Apply"),
    "promoCodeHint": MessageLookupByLibrary.simpleMessage("Enter promo code"),
    "promoDiscountBotOnly": MessageLookupByLibrary.simpleMessage(
      "This promo code works only in the Telegram bot",
    ),
    "promoInvalid": MessageLookupByLibrary.simpleMessage(
      "The code is invalid, expired, or already used",
    ),
    "providers": MessageLookupByLibrary.simpleMessage("Providers"),
    "proxies": MessageLookupByLibrary.simpleMessage("Proxies"),
    "proxiesSetting": MessageLookupByLibrary.simpleMessage("Proxies setting"),
    "proxyGroup": MessageLookupByLibrary.simpleMessage("Proxy group"),
    "proxyNameserver": MessageLookupByLibrary.simpleMessage("Proxy nameserver"),
    "proxyNameserverDesc": MessageLookupByLibrary.simpleMessage(
      "Domain for resolving proxy nodes",
    ),
    "proxyPort": MessageLookupByLibrary.simpleMessage("ProxyPort"),
    "proxyPortDesc": MessageLookupByLibrary.simpleMessage(
      "Set the Clash listening port",
    ),
    "proxyProviders": MessageLookupByLibrary.simpleMessage("Proxy providers"),
    "pureBlackMode": MessageLookupByLibrary.simpleMessage("Pure black mode"),
    "qrcode": MessageLookupByLibrary.simpleMessage("QR code"),
    "qrcodeDesc": MessageLookupByLibrary.simpleMessage(
      "Scan QR code to obtain profile",
    ),
    "rainbowScheme": MessageLookupByLibrary.simpleMessage("Rainbow"),
    "recovery": MessageLookupByLibrary.simpleMessage("Recovery"),
    "recoveryAll": MessageLookupByLibrary.simpleMessage("Recovery all data"),
    "recoveryProfiles": MessageLookupByLibrary.simpleMessage(
      "Only recovery profiles",
    ),
    "recoveryStrategy": MessageLookupByLibrary.simpleMessage(
      "Recovery strategy",
    ),
    "recoveryStrategy_compatible": MessageLookupByLibrary.simpleMessage(
      "Compatible",
    ),
    "recoveryStrategy_override": MessageLookupByLibrary.simpleMessage(
      "Override",
    ),
    "recoverySuccess": MessageLookupByLibrary.simpleMessage("Recovery success"),
    "redeemPromo": MessageLookupByLibrary.simpleMessage("Promo code"),
    "redirPort": MessageLookupByLibrary.simpleMessage("Redir Port"),
    "redo": MessageLookupByLibrary.simpleMessage("redo"),
    "referralApplied": MessageLookupByLibrary.simpleMessage("Referral applied"),
    "referralApply": MessageLookupByLibrary.simpleMessage("Apply"),
    "referralAttributed": m18,
    "referralCodeHint": MessageLookupByLibrary.simpleMessage(
      "Enter referral code",
    ),
    "referralCodeHintOptional": MessageLookupByLibrary.simpleMessage(
      "Referral code (optional)",
    ),
    "referralCommission": m19,
    "referralCopied": MessageLookupByLibrary.simpleMessage(
      "Copied to clipboard",
    ),
    "referralCopyLink": MessageLookupByLibrary.simpleMessage("Copy link"),
    "referralEarnedDays": m20,
    "referralEnterCode": MessageLookupByLibrary.simpleMessage(
      "Have a referral code?",
    ),
    "referralInvalid": MessageLookupByLibrary.simpleMessage(
      "The referral code is invalid or can\'t be used",
    ),
    "referralInvitedCount": m21,
    "referralShare": MessageLookupByLibrary.simpleMessage("Share"),
    "referralYourCode": MessageLookupByLibrary.simpleMessage("Your code"),
    "regExp": MessageLookupByLibrary.simpleMessage("RegExp"),
    "register": MessageLookupByLibrary.simpleMessage("Sign up"),
    "remaining": MessageLookupByLibrary.simpleMessage("Remaining"),
    "remainingPlural": MessageLookupByLibrary.simpleMessage("Remaining"),
    "remainingSingular": MessageLookupByLibrary.simpleMessage("Remaining"),
    "remote": MessageLookupByLibrary.simpleMessage("Remote"),
    "remoteBackupDesc": MessageLookupByLibrary.simpleMessage(
      "Backup local data to WebDAV",
    ),
    "remoteRecoveryDesc": MessageLookupByLibrary.simpleMessage(
      "Recovery data from WebDAV",
    ),
    "remove": MessageLookupByLibrary.simpleMessage("Remove"),
    "rename": MessageLookupByLibrary.simpleMessage("Rename"),
    "renew": MessageLookupByLibrary.simpleMessage("Renew"),
    "requests": MessageLookupByLibrary.simpleMessage("Requests"),
    "requestsDesc": MessageLookupByLibrary.simpleMessage(
      "View recently request records",
    ),
    "reset": MessageLookupByLibrary.simpleMessage("Reset"),
    "resetNetworkSettings": MessageLookupByLibrary.simpleMessage(
      "Reset network settings",
    ),
    "resetTip": MessageLookupByLibrary.simpleMessage("Make sure to reset"),
    "resources": MessageLookupByLibrary.simpleMessage("Resources"),
    "resourcesDesc": MessageLookupByLibrary.simpleMessage(
      "External resource related info",
    ),
    "respectRules": MessageLookupByLibrary.simpleMessage("Respect rules"),
    "respectRulesDesc": MessageLookupByLibrary.simpleMessage(
      "DNS connection following rules, need to configure proxy-server-nameserver",
    ),
    "restart": MessageLookupByLibrary.simpleMessage("Restart"),
    "retry": MessageLookupByLibrary.simpleMessage("Retry"),
    "routeAddress": MessageLookupByLibrary.simpleMessage("Route address"),
    "routeAddressDesc": MessageLookupByLibrary.simpleMessage(
      "Config listen route address",
    ),
    "routeMode": MessageLookupByLibrary.simpleMessage("Route mode"),
    "routeMode_bypassPrivate": MessageLookupByLibrary.simpleMessage(
      "Bypass private route address",
    ),
    "routeMode_config": MessageLookupByLibrary.simpleMessage("Use config"),
    "ru": MessageLookupByLibrary.simpleMessage("Russian"),
    "rule": MessageLookupByLibrary.simpleMessage("By rule"),
    "ruleName": MessageLookupByLibrary.simpleMessage("Rule name"),
    "ruleProviders": MessageLookupByLibrary.simpleMessage("Rule providers"),
    "ruleTarget": MessageLookupByLibrary.simpleMessage("Rule target"),
    "running": MessageLookupByLibrary.simpleMessage("Running"),
    "save": MessageLookupByLibrary.simpleMessage("Save"),
    "saveChanges": MessageLookupByLibrary.simpleMessage(
      "Do you want to save the changes?",
    ),
    "saveTip": MessageLookupByLibrary.simpleMessage(
      "Are you sure you want to save?",
    ),
    "script": MessageLookupByLibrary.simpleMessage("Script"),
    "search": MessageLookupByLibrary.simpleMessage("Search"),
    "searchServers": MessageLookupByLibrary.simpleMessage("Search servers"),
    "seconds": MessageLookupByLibrary.simpleMessage("Seconds"),
    "selectAll": MessageLookupByLibrary.simpleMessage("Select all"),
    "selected": MessageLookupByLibrary.simpleMessage("Selected"),
    "selectedCountTitle": m22,
    "serverTimeout": MessageLookupByLibrary.simpleMessage("timeout"),
    "serversEmptyHint": MessageLookupByLibrary.simpleMessage(
      "Claim a subscription to load your servers.",
    ),
    "serversEmptyTitle": MessageLookupByLibrary.simpleMessage("No servers yet"),
    "serversTest": MessageLookupByLibrary.simpleMessage("Test"),
    "serversTesting": MessageLookupByLibrary.simpleMessage("Testing…"),
    "settings": MessageLookupByLibrary.simpleMessage("Settings"),
    "settingsAdvanced": MessageLookupByLibrary.simpleMessage("Advanced"),
    "settingsApp": MessageLookupByLibrary.simpleMessage("App"),
    "settingsAppearance": MessageLookupByLibrary.simpleMessage("Appearance"),
    "settingsConnection": MessageLookupByLibrary.simpleMessage("Connection"),
    "show": MessageLookupByLibrary.simpleMessage("Show"),
    "shrink": MessageLookupByLibrary.simpleMessage("Shrink"),
    "signIn": MessageLookupByLibrary.simpleMessage("Sign in"),
    "signInToManage": MessageLookupByLibrary.simpleMessage(
      "Sign in to manage your subscription.",
    ),
    "silentLaunch": MessageLookupByLibrary.simpleMessage("SilentLaunch"),
    "silentLaunchDesc": MessageLookupByLibrary.simpleMessage(
      "Start in the background",
    ),
    "size": MessageLookupByLibrary.simpleMessage("Size"),
    "socksPort": MessageLookupByLibrary.simpleMessage("Socks Port"),
    "sort": MessageLookupByLibrary.simpleMessage("Sort"),
    "source": MessageLookupByLibrary.simpleMessage("Source"),
    "sourceIp": MessageLookupByLibrary.simpleMessage("Source IP"),
    "stackMode": MessageLookupByLibrary.simpleMessage("Stack mode"),
    "standard": MessageLookupByLibrary.simpleMessage("Standard"),
    "start": MessageLookupByLibrary.simpleMessage("Start"),
    "startFreeTrial": MessageLookupByLibrary.simpleMessage("Start free trial"),
    "startVpn": MessageLookupByLibrary.simpleMessage("Starting VPN..."),
    "status": MessageLookupByLibrary.simpleMessage("Status"),
    "statusActive": MessageLookupByLibrary.simpleMessage("Active"),
    "statusDesc": MessageLookupByLibrary.simpleMessage(
      "System DNS will be used when turned off",
    ),
    "statusFailed": MessageLookupByLibrary.simpleMessage("Failed"),
    "statusProvisioning": MessageLookupByLibrary.simpleMessage("Setting up"),
    "stop": MessageLookupByLibrary.simpleMessage("Stop"),
    "stopVpn": MessageLookupByLibrary.simpleMessage("Stopping VPN..."),
    "stopped": MessageLookupByLibrary.simpleMessage("Stopped"),
    "style": MessageLookupByLibrary.simpleMessage("Style"),
    "subRule": MessageLookupByLibrary.simpleMessage("Sub rule"),
    "submit": MessageLookupByLibrary.simpleMessage("Submit"),
    "subscription": MessageLookupByLibrary.simpleMessage("Subscription"),
    "subscriptionEternal": MessageLookupByLibrary.simpleMessage(
      "Lifetime Subscription",
    ),
    "subscriptionExpired": MessageLookupByLibrary.simpleMessage(
      "Your subscription has expired",
    ),
    "subscriptionExpiresInDays": m23,
    "subscriptionExpiresSoon": MessageLookupByLibrary.simpleMessage(
      "Subscription expires soon",
    ),
    "subscriptionExpiresToday": MessageLookupByLibrary.simpleMessage(
      "Your subscription expires today",
    ),
    "subscriptionHistory": MessageLookupByLibrary.simpleMessage(
      "Subscription history",
    ),
    "subscriptionPreparing": MessageLookupByLibrary.simpleMessage(
      "Your subscription is still being prepared. Please try again in a minute",
    ),
    "subscriptionUnlimited": MessageLookupByLibrary.simpleMessage(
      "Lifetime Subscription",
    ),
    "successTitle": MessageLookupByLibrary.simpleMessage("Success"),
    "support": MessageLookupByLibrary.simpleMessage("Support"),
    "sync": MessageLookupByLibrary.simpleMessage("Sync"),
    "system": MessageLookupByLibrary.simpleMessage("System"),
    "systemApp": MessageLookupByLibrary.simpleMessage("System APP"),
    "systemFont": MessageLookupByLibrary.simpleMessage("System font"),
    "systemProxy": MessageLookupByLibrary.simpleMessage("System proxy"),
    "systemProxyDesc": MessageLookupByLibrary.simpleMessage(
      "Attach HTTP proxy to VpnService",
    ),
    "tab": MessageLookupByLibrary.simpleMessage("Tab"),
    "tabAnimation": MessageLookupByLibrary.simpleMessage("Tab animation"),
    "tabAnimationDesc": MessageLookupByLibrary.simpleMessage(
      "Effective only in mobile view",
    ),
    "tcpConcurrent": MessageLookupByLibrary.simpleMessage("TCP concurrent"),
    "tcpConcurrentDesc": MessageLookupByLibrary.simpleMessage(
      "Enabling it will allow TCP concurrency",
    ),
    "telegramLinked": MessageLookupByLibrary.simpleMessage("Telegram linked"),
    "testUrl": MessageLookupByLibrary.simpleMessage("Test url"),
    "textScale": MessageLookupByLibrary.simpleMessage("Text Scaling"),
    "thanks": MessageLookupByLibrary.simpleMessage("Thanks for contribution"),
    "theme": MessageLookupByLibrary.simpleMessage("Theme"),
    "themeColor": MessageLookupByLibrary.simpleMessage("Theme color"),
    "themeDesc": MessageLookupByLibrary.simpleMessage(
      "Set dark mode,adjust the color",
    ),
    "themeMode": MessageLookupByLibrary.simpleMessage("Theme mode"),
    "threeColumns": MessageLookupByLibrary.simpleMessage("Three columns"),
    "tight": MessageLookupByLibrary.simpleMessage("Tight"),
    "time": MessageLookupByLibrary.simpleMessage("Time"),
    "tip": MessageLookupByLibrary.simpleMessage("tip"),
    "toggle": MessageLookupByLibrary.simpleMessage("Toggle"),
    "tonalSpotScheme": MessageLookupByLibrary.simpleMessage("TonalSpot"),
    "tooFrequentOperation": MessageLookupByLibrary.simpleMessage(
      "Please wait 15 seconds before refreshing again",
    ),
    "tools": MessageLookupByLibrary.simpleMessage("Settings"),
    "tproxyPort": MessageLookupByLibrary.simpleMessage("Tproxy Port"),
    "traffic": MessageLookupByLibrary.simpleMessage("Traffic"),
    "trafficUnlimited": MessageLookupByLibrary.simpleMessage(
      "Unlimited Traffic",
    ),
    "trafficUsage": MessageLookupByLibrary.simpleMessage("Traffic usage"),
    "tun": MessageLookupByLibrary.simpleMessage("TUN"),
    "tunDesc": MessageLookupByLibrary.simpleMessage(
      "only effective in administrator mode",
    ),
    "twoColumns": MessageLookupByLibrary.simpleMessage("Two columns"),
    "unableToUpdateCurrentProfileDesc": MessageLookupByLibrary.simpleMessage(
      "unable to update current profile",
    ),
    "undo": MessageLookupByLibrary.simpleMessage("undo"),
    "unifiedDelay": MessageLookupByLibrary.simpleMessage("Unified delay"),
    "unifiedDelayDesc": MessageLookupByLibrary.simpleMessage(
      "Remove extra delays such as handshaking",
    ),
    "unknown": MessageLookupByLibrary.simpleMessage("Unknown"),
    "unnamed": MessageLookupByLibrary.simpleMessage("Unnamed"),
    "update": MessageLookupByLibrary.simpleMessage("Update"),
    "updateAllGeoData": MessageLookupByLibrary.simpleMessage(
      "Update All Geo Files",
    ),
    "updated": MessageLookupByLibrary.simpleMessage("Updated"),
    "upgradePlan": MessageLookupByLibrary.simpleMessage("Upgrade plan"),
    "upload": MessageLookupByLibrary.simpleMessage("Upload"),
    "url": MessageLookupByLibrary.simpleMessage("URL"),
    "urlDesc": MessageLookupByLibrary.simpleMessage(
      "Obtain profile through URL",
    ),
    "urlTip": m24,
    "useHosts": MessageLookupByLibrary.simpleMessage("Use hosts"),
    "useSystemHosts": MessageLookupByLibrary.simpleMessage("Use system hosts"),
    "value": MessageLookupByLibrary.simpleMessage("Value"),
    "vibrantScheme": MessageLookupByLibrary.simpleMessage("Vibrant"),
    "view": MessageLookupByLibrary.simpleMessage("View"),
    "viewPlans": MessageLookupByLibrary.simpleMessage("View plans"),
    "vpnDesc": MessageLookupByLibrary.simpleMessage(
      "Modify VPN related settings",
    ),
    "vpnEnableDesc": MessageLookupByLibrary.simpleMessage(
      "Auto routes all system traffic through VpnService",
    ),
    "vpnSystemProxyDesc": MessageLookupByLibrary.simpleMessage(
      "Attach HTTP proxy to VpnService",
    ),
    "vpnTip": MessageLookupByLibrary.simpleMessage(
      "Changes take effect after restarting the VPN",
    ),
    "webDAVConfiguration": MessageLookupByLibrary.simpleMessage(
      "WebDAV configuration",
    ),
    "whitelistMode": MessageLookupByLibrary.simpleMessage("Whitelist mode"),
    "years": MessageLookupByLibrary.simpleMessage("Years"),
    "zh_CN": MessageLookupByLibrary.simpleMessage("Simplified Chinese"),
  };
}
