// DO NOT EDIT. This is code generated via package:intl/generate_localized.dart
// This is a library that provides messages for a ja locale. All the
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
  String get localeName => 'ja';

  static String m0(app) => "${app} について";

  static String m1(days, date) => "あと ${days} 日で期限切れ · ${date}";

  static String m2(limit) => "/ ${limit}";

  static String m3(used, total) => "${used} of ${total} used";

  static String m4(duration) => "接続済み · ${duration}";

  static String m5(label) => "選択された${label}を削除してもよろしいですか？";

  static String m6(label) => "現在の${label}を削除してもよろしいですか？";

  static String m7(label) => "${label}は空欄にできません";

  static String m8(label) => "現在の${label}は既に存在しています";

  static String m9(label) => "現在${label}はありません";

  static String m10(label) => "${label}は数字でなければなりません";

  static String m11(days) => "${days} 日間アクセス";

  static String m12(count) => "${count} 台のデバイス";

  static String m13(count) => "${count} 台のデバイス";

  static String m14(name) => "${name} プラン";

  static String m15(size) => "${size} トラフィック";

  static String m16(label) => "${label} は 1024 から 49151 の間でなければなりません";

  static String m17(count) => "${count} 項目が選択されています";

  static String m18(days) => "サブスクリプションは${days}日後に期限切れになります";

  static String m19(label) => "${label}はURLである必要があります";

  final messages = _notInlinedMessages(_notInlinedMessages);
  static Map<String, Function> _notInlinedMessages(_) => <String, Function>{
    "about": MessageLookupByLibrary.simpleMessage("について"),
    "aboutApp": m0,
    "accessControl": MessageLookupByLibrary.simpleMessage("アクセス制御"),
    "accessControlAllowDesc": MessageLookupByLibrary.simpleMessage(
      "選択したアプリのみVPNを許可",
    ),
    "accessControlDesc": MessageLookupByLibrary.simpleMessage(
      "アプリケーションのプロキシアクセスを設定",
    ),
    "accessControlNotAllowDesc": MessageLookupByLibrary.simpleMessage(
      "選択したアプリをVPNから除外",
    ),
    "account": MessageLookupByLibrary.simpleMessage("アカウント"),
    "accountEmailUnknown": MessageLookupByLibrary.simpleMessage(
      "Unknown email",
    ),
    "accountExpiresInDays": m1,
    "accountLoadError": MessageLookupByLibrary.simpleMessage(
      "アカウントを読み込めませんでした。",
    ),
    "accountNoSubscription": MessageLookupByLibrary.simpleMessage(
      "No active subscription yet",
    ),
    "accountOfLimit": m2,
    "accountSignedIn": MessageLookupByLibrary.simpleMessage("ログイン中"),
    "accountTrafficRemaining": m3,
    "action": MessageLookupByLibrary.simpleMessage("アクション"),
    "action_mode": MessageLookupByLibrary.simpleMessage("モード切替"),
    "action_proxy": MessageLookupByLibrary.simpleMessage("システムプロキシ"),
    "action_start": MessageLookupByLibrary.simpleMessage("開始/停止"),
    "action_tun": MessageLookupByLibrary.simpleMessage("TUN"),
    "action_view": MessageLookupByLibrary.simpleMessage("表示/非表示"),
    "activityDailyTraffic": MessageLookupByLibrary.simpleMessage("日次トラフィック"),
    "activityDemo": MessageLookupByLibrary.simpleMessage("デモ"),
    "activityDownloaded": MessageLookupByLibrary.simpleMessage("ダウンロード済み"),
    "activityDuration": MessageLookupByLibrary.simpleMessage("継続時間"),
    "activityLive": MessageLookupByLibrary.simpleMessage("ライブ"),
    "activityThroughput": MessageLookupByLibrary.simpleMessage("スループット"),
    "activityUploaded": MessageLookupByLibrary.simpleMessage("アップロード済み"),
    "activityUsageWeek": MessageLookupByLibrary.simpleMessage("使用量 · 過去 7 日間"),
    "add": MessageLookupByLibrary.simpleMessage("追加"),
    "addRule": MessageLookupByLibrary.simpleMessage("ルールを追加"),
    "addedOriginRules": MessageLookupByLibrary.simpleMessage("元のルールに追加"),
    "address": MessageLookupByLibrary.simpleMessage("アドレス"),
    "addressHelp": MessageLookupByLibrary.simpleMessage("WebDAVサーバーアドレス"),
    "addressTip": MessageLookupByLibrary.simpleMessage("有効なWebDAVアドレスを入力"),
    "adminAutoLaunch": MessageLookupByLibrary.simpleMessage("管理者自動起動"),
    "adminAutoLaunchDesc": MessageLookupByLibrary.simpleMessage("管理者モードで起動"),
    "ago": MessageLookupByLibrary.simpleMessage("前"),
    "agree": MessageLookupByLibrary.simpleMessage("同意"),
    "allApps": MessageLookupByLibrary.simpleMessage("全アプリ"),
    "allowBypass": MessageLookupByLibrary.simpleMessage("アプリがVPNをバイパスすることを許可"),
    "allowBypassDesc": MessageLookupByLibrary.simpleMessage(
      "有効化すると一部アプリがVPNをバイパス",
    ),
    "allowLan": MessageLookupByLibrary.simpleMessage("LANを許可"),
    "allowLanDesc": MessageLookupByLibrary.simpleMessage("LAN経由でのプロキシアクセスを許可"),
    "announcement": MessageLookupByLibrary.simpleMessage("お知らせ"),
    "app": MessageLookupByLibrary.simpleMessage("アプリ"),
    "appAccessControl": MessageLookupByLibrary.simpleMessage("アプリアクセス制御"),
    "appDesc": MessageLookupByLibrary.simpleMessage("アプリ関連設定の処理"),
    "application": MessageLookupByLibrary.simpleMessage("アプリケーション設定"),
    "applicationDesc": MessageLookupByLibrary.simpleMessage("標準アプリ設定"),
    "authCreateSubtitle": MessageLookupByLibrary.simpleMessage(
      "ログインして無料トライアルを取得。",
    ),
    "authCreateTitle": MessageLookupByLibrary.simpleMessage("アカウントを作成"),
    "authEmailInvalid": MessageLookupByLibrary.simpleMessage(
      "Please enter a valid email",
    ),
    "authEmailRequired": MessageLookupByLibrary.simpleMessage(
      "Please enter your email",
    ),
    "authErrorEmailTaken": MessageLookupByLibrary.simpleMessage(
      "This email is already registered",
    ),
    "authErrorInvalidCredentials": MessageLookupByLibrary.simpleMessage(
      "Invalid email or password",
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
    "authLegal": MessageLookupByLibrary.simpleMessage(
      "続行すると、利用規約とプライバシーポリシーに同意したものとみなされます。",
    ),
    "authPasswordRequired": MessageLookupByLibrary.simpleMessage(
      "Please enter your password",
    ),
    "authPasswordTooShort": MessageLookupByLibrary.simpleMessage(
      "Password must be at least 8 characters",
    ),
    "authWelcomeTitle": MessageLookupByLibrary.simpleMessage("おかえりなさい"),
    "auto": MessageLookupByLibrary.simpleMessage("自動"),
    "autoCheckUpdate": MessageLookupByLibrary.simpleMessage("自動更新チェック"),
    "autoCheckUpdateDesc": MessageLookupByLibrary.simpleMessage(
      "起動時に更新を自動チェック",
    ),
    "autoCloseConnections": MessageLookupByLibrary.simpleMessage("接続を自動閉じる"),
    "autoCloseConnectionsDesc": MessageLookupByLibrary.simpleMessage(
      "ノード変更後に接続を自動閉じる",
    ),
    "autoLaunch": MessageLookupByLibrary.simpleMessage("自動起動"),
    "autoLaunchDesc": MessageLookupByLibrary.simpleMessage("システムの自動起動に従う"),
    "autoRun": MessageLookupByLibrary.simpleMessage("自動実行"),
    "autoRunDesc": MessageLookupByLibrary.simpleMessage("アプリ起動時に自動実行"),
    "autoSetSystemDns": MessageLookupByLibrary.simpleMessage("オートセットシステムDNS"),
    "autoUpdate": MessageLookupByLibrary.simpleMessage("自動更新"),
    "autoUpdateInterval": MessageLookupByLibrary.simpleMessage("自動更新間隔（分）"),
    "backup": MessageLookupByLibrary.simpleMessage("バックアップ"),
    "backupAndRecovery": MessageLookupByLibrary.simpleMessage("バックアップと復元"),
    "backupAndRecoveryDesc": MessageLookupByLibrary.simpleMessage(
      "WebDAVまたはファイルでデータを同期",
    ),
    "backupSuccess": MessageLookupByLibrary.simpleMessage("バックアップ成功"),
    "basicConfig": MessageLookupByLibrary.simpleMessage("基本設定"),
    "basicConfigDesc": MessageLookupByLibrary.simpleMessage("基本設定をグローバルに変更"),
    "billingNotActive": MessageLookupByLibrary.simpleMessage("課金はまだ有効ではありません"),
    "bind": MessageLookupByLibrary.simpleMessage("バインド"),
    "blacklistMode": MessageLookupByLibrary.simpleMessage("ブラックリストモード"),
    "bypassDomain": MessageLookupByLibrary.simpleMessage("バイパスドメイン"),
    "bypassDomainDesc": MessageLookupByLibrary.simpleMessage("システムプロキシ有効時のみ適用"),
    "cacheCorrupt": MessageLookupByLibrary.simpleMessage(
      "キャッシュが破損しています。クリアしますか？",
    ),
    "cancel": MessageLookupByLibrary.simpleMessage("キャンセル"),
    "cancelFilterSystemApp": MessageLookupByLibrary.simpleMessage(
      "システムアプリの除外を解除",
    ),
    "cancelSelectAll": MessageLookupByLibrary.simpleMessage("全選択解除"),
    "changeServer": MessageLookupByLibrary.simpleMessage("サーバーを変更"),
    "checkError": MessageLookupByLibrary.simpleMessage("確認エラー"),
    "checkUpdate": MessageLookupByLibrary.simpleMessage("更新を確認"),
    "checkUpdateError": MessageLookupByLibrary.simpleMessage("アプリは最新版です"),
    "checking": MessageLookupByLibrary.simpleMessage("確認中..."),
    "chooseAPlan": MessageLookupByLibrary.simpleMessage("プランを選択"),
    "choosePlan": MessageLookupByLibrary.simpleMessage("プランを選択"),
    "chooseServer": MessageLookupByLibrary.simpleMessage("サーバーを選択"),
    "clearData": MessageLookupByLibrary.simpleMessage("データを消去"),
    "clearDataTip": MessageLookupByLibrary.simpleMessage(
      "これによりすべてのアプリデータが削除され、アプリケーションが再起動されます。よろしいですか？",
    ),
    "clipboardExport": MessageLookupByLibrary.simpleMessage("クリップボードにエクスポート"),
    "clipboardImport": MessageLookupByLibrary.simpleMessage("クリップボードからインポート"),
    "color": MessageLookupByLibrary.simpleMessage("カラー"),
    "colorSchemes": MessageLookupByLibrary.simpleMessage("カラースキーム"),
    "columns": MessageLookupByLibrary.simpleMessage("列"),
    "compatible": MessageLookupByLibrary.simpleMessage("互換モード"),
    "compatibleDesc": MessageLookupByLibrary.simpleMessage(
      "有効化すると一部機能を失いますが、Clashの完全サポートを獲得",
    ),
    "confirm": MessageLookupByLibrary.simpleMessage("確認"),
    "connectConnected": MessageLookupByLibrary.simpleMessage("接続済み"),
    "connectConnectedFor": m4,
    "connectExpiredHint": MessageLookupByLibrary.simpleMessage(
      "更新してトラフィックを保護し続けましょう",
    ),
    "connectExpiredTitle": MessageLookupByLibrary.simpleMessage(
      "サブスクリプションの有効期限切れ",
    ),
    "connectExpiresLabel": MessageLookupByLibrary.simpleMessage("有効期限"),
    "connectFailedHint": MessageLookupByLibrary.simpleMessage(
      "問題が発生しました。もう一度お試しください。",
    ),
    "connectFailedTitle": MessageLookupByLibrary.simpleMessage(
      "プロビジョニングに失敗しました",
    ),
    "connectGetPlanHint": MessageLookupByLibrary.simpleMessage(
      "プランを取得してトラフィックの保護を始めましょう",
    ),
    "connectNotProtected": MessageLookupByLibrary.simpleMessage("保護されていません"),
    "connectProtected": MessageLookupByLibrary.simpleMessage("保護中"),
    "connectProvisioning": MessageLookupByLibrary.simpleMessage(
      "サブスクリプションを設定中…",
    ),
    "connectProvisioningHint": MessageLookupByLibrary.simpleMessage(
      "通常は数秒で完了します",
    ),
    "connectTapToConnect": MessageLookupByLibrary.simpleMessage("タップして接続"),
    "connectionSettings": MessageLookupByLibrary.simpleMessage("接続設定"),
    "connectionSettingsSub": MessageLookupByLibrary.simpleMessage(
      "一般 · ネットワーク · DNS",
    ),
    "connections": MessageLookupByLibrary.simpleMessage("接続"),
    "connectionsDesc": MessageLookupByLibrary.simpleMessage("現在の接続データを表示"),
    "connectivity": MessageLookupByLibrary.simpleMessage("接続性："),
    "contactMe": MessageLookupByLibrary.simpleMessage("連絡する"),
    "content": MessageLookupByLibrary.simpleMessage("内容"),
    "contentScheme": MessageLookupByLibrary.simpleMessage("コンテンツテーマ"),
    "copy": MessageLookupByLibrary.simpleMessage("コピー"),
    "copyEnvVar": MessageLookupByLibrary.simpleMessage("環境変数をコピー"),
    "copyLink": MessageLookupByLibrary.simpleMessage("リンクをコピー"),
    "copySuccess": MessageLookupByLibrary.simpleMessage("コピー成功"),
    "core": MessageLookupByLibrary.simpleMessage("コア"),
    "coreInfo": MessageLookupByLibrary.simpleMessage("コア情報"),
    "country": MessageLookupByLibrary.simpleMessage("国"),
    "crashTest": MessageLookupByLibrary.simpleMessage("クラッシュテスト"),
    "create": MessageLookupByLibrary.simpleMessage("作成"),
    "createAccount": MessageLookupByLibrary.simpleMessage("アカウント作成"),
    "cut": MessageLookupByLibrary.simpleMessage("切り取り"),
    "dark": MessageLookupByLibrary.simpleMessage("ダーク"),
    "dashboard": MessageLookupByLibrary.simpleMessage("ダッシュボード"),
    "day": MessageLookupByLibrary.simpleMessage("日"),
    "days": MessageLookupByLibrary.simpleMessage("日"),
    "daysGenitive": MessageLookupByLibrary.simpleMessage("日"),
    "defaultNameserver": MessageLookupByLibrary.simpleMessage("デフォルトネームサーバー"),
    "defaultNameserverDesc": MessageLookupByLibrary.simpleMessage(
      "DNSサーバーの解決用",
    ),
    "defaultSort": MessageLookupByLibrary.simpleMessage("デフォルト順"),
    "defaultText": MessageLookupByLibrary.simpleMessage("デフォルト"),
    "delay": MessageLookupByLibrary.simpleMessage("遅延"),
    "delaySort": MessageLookupByLibrary.simpleMessage("遅延順"),
    "delete": MessageLookupByLibrary.simpleMessage("削除"),
    "deleteMultipTip": m5,
    "deleteTip": m6,
    "desc": MessageLookupByLibrary.simpleMessage(
      "ClashMetaベースのマルチプラットフォームプロキシクライアント。シンプルで使いやすく、オープンソースで広告なし。",
    ),
    "detectionTip": MessageLookupByLibrary.simpleMessage("サードパーティAPIに依存（参考値）"),
    "developerMode": MessageLookupByLibrary.simpleMessage("デベロッパーモード"),
    "developerModeEnableTip": MessageLookupByLibrary.simpleMessage(
      "デベロッパーモードが有効になりました。",
    ),
    "direct": MessageLookupByLibrary.simpleMessage("ダイレクト"),
    "discoverNewVersion": MessageLookupByLibrary.simpleMessage("新バージョンを発見"),
    "discovery": MessageLookupByLibrary.simpleMessage("新しいバージョンを発見"),
    "dnsDesc": MessageLookupByLibrary.simpleMessage("DNS関連設定の更新"),
    "dnsMode": MessageLookupByLibrary.simpleMessage("DNSモード"),
    "doYouWantToPass": MessageLookupByLibrary.simpleMessage("プロファイルを追加中"),
    "domain": MessageLookupByLibrary.simpleMessage("ドメイン"),
    "download": MessageLookupByLibrary.simpleMessage("ダウンロード"),
    "edit": MessageLookupByLibrary.simpleMessage("編集"),
    "email": MessageLookupByLibrary.simpleMessage("Email"),
    "emptyTip": m7,
    "en": MessageLookupByLibrary.simpleMessage("英語"),
    "enableLogs": MessageLookupByLibrary.simpleMessage("ログを有効にする"),
    "enableOverride": MessageLookupByLibrary.simpleMessage("上書きを有効化"),
    "entries": MessageLookupByLibrary.simpleMessage(" エントリ"),
    "errorTitle": MessageLookupByLibrary.simpleMessage("エラー"),
    "exclude": MessageLookupByLibrary.simpleMessage("最近のタスクから非表示"),
    "excludeDesc": MessageLookupByLibrary.simpleMessage(
      "アプリがバックグラウンド時に最近のタスクから非表示",
    ),
    "existsTip": m8,
    "exit": MessageLookupByLibrary.simpleMessage("終了"),
    "expand": MessageLookupByLibrary.simpleMessage("標準"),
    "expirationTime": MessageLookupByLibrary.simpleMessage("有効期限"),
    "expiresOn": MessageLookupByLibrary.simpleMessage("有効期限"),
    "exportFile": MessageLookupByLibrary.simpleMessage("ファイルをエクスポート"),
    "exportLogs": MessageLookupByLibrary.simpleMessage("ログをエクスポート"),
    "exportSuccess": MessageLookupByLibrary.simpleMessage("エクスポート成功"),
    "expressiveScheme": MessageLookupByLibrary.simpleMessage("エクスプレッシブ"),
    "externalController": MessageLookupByLibrary.simpleMessage("外部コントローラー"),
    "externalControllerDesc": MessageLookupByLibrary.simpleMessage(
      "有効化するとClashコアをポート9090で制御可能",
    ),
    "externalLink": MessageLookupByLibrary.simpleMessage("外部リンク"),
    "externalResources": MessageLookupByLibrary.simpleMessage("外部リソース"),
    "fakeipFilter": MessageLookupByLibrary.simpleMessage("Fakeipフィルター"),
    "fakeipRange": MessageLookupByLibrary.simpleMessage("Fakeip範囲"),
    "fallback": MessageLookupByLibrary.simpleMessage("フォールバック"),
    "fallbackDesc": MessageLookupByLibrary.simpleMessage("通常はオフショアDNSを使用"),
    "fallbackFilter": MessageLookupByLibrary.simpleMessage("フォールバックフィルター"),
    "fidelityScheme": MessageLookupByLibrary.simpleMessage("ハイファイデリティー"),
    "file": MessageLookupByLibrary.simpleMessage("ファイル"),
    "fileDesc": MessageLookupByLibrary.simpleMessage("プロファイルを直接アップロード"),
    "fileIsUpdate": MessageLookupByLibrary.simpleMessage(
      "ファイルが変更されました。保存しますか？",
    ),
    "filterSystemApp": MessageLookupByLibrary.simpleMessage("システムアプリを除外"),
    "findProcessMode": MessageLookupByLibrary.simpleMessage("プロセス検出"),
    "findProcessModeDesc": MessageLookupByLibrary.simpleMessage(
      "有効化するとパフォーマンスが若干低下します",
    ),
    "fontFamily": MessageLookupByLibrary.simpleMessage("フォントファミリー"),
    "fourColumns": MessageLookupByLibrary.simpleMessage("4列"),
    "fruitSaladScheme": MessageLookupByLibrary.simpleMessage("フルーツサラダ"),
    "general": MessageLookupByLibrary.simpleMessage("一般"),
    "generalDesc": MessageLookupByLibrary.simpleMessage("一般設定を変更"),
    "geoData": MessageLookupByLibrary.simpleMessage("地域データ"),
    "geodataLoader": MessageLookupByLibrary.simpleMessage("Geo低メモリモード"),
    "geodataLoaderDesc": MessageLookupByLibrary.simpleMessage(
      "有効化するとGeo低メモリローダーを使用",
    ),
    "geoipCode": MessageLookupByLibrary.simpleMessage("GeoIPコード"),
    "getOriginRules": MessageLookupByLibrary.simpleMessage("元のルールを取得"),
    "global": MessageLookupByLibrary.simpleMessage("グローバル"),
    "go": MessageLookupByLibrary.simpleMessage("移動"),
    "goDownload": MessageLookupByLibrary.simpleMessage("ダウンロードへ"),
    "gratitude": MessageLookupByLibrary.simpleMessage("感謝"),
    "hasCacheChange": MessageLookupByLibrary.simpleMessage("変更をキャッシュしますか？"),
    "haveAccountLogin": MessageLookupByLibrary.simpleMessage(
      "Already have an account? Log in",
    ),
    "hostsDesc": MessageLookupByLibrary.simpleMessage("ホストを追加"),
    "hotkeyConflict": MessageLookupByLibrary.simpleMessage("ホットキー競合"),
    "hotkeyManagement": MessageLookupByLibrary.simpleMessage("ホットキー管理"),
    "hotkeyManagementDesc": MessageLookupByLibrary.simpleMessage(
      "キーボードでアプリを制御",
    ),
    "hour": MessageLookupByLibrary.simpleMessage("時間"),
    "hours": MessageLookupByLibrary.simpleMessage("時間"),
    "hoursGenitive": MessageLookupByLibrary.simpleMessage("時間"),
    "hoursPlural": MessageLookupByLibrary.simpleMessage("時間"),
    "icon": MessageLookupByLibrary.simpleMessage("アイコン"),
    "iconConfiguration": MessageLookupByLibrary.simpleMessage("アイコン設定"),
    "iconStyle": MessageLookupByLibrary.simpleMessage("アイコンスタイル"),
    "import": MessageLookupByLibrary.simpleMessage("インポート"),
    "importFile": MessageLookupByLibrary.simpleMessage("ファイルからインポート"),
    "importFromURL": MessageLookupByLibrary.simpleMessage("URLからインポート"),
    "importUrl": MessageLookupByLibrary.simpleMessage("URLからインポート"),
    "infiniteTime": MessageLookupByLibrary.simpleMessage("長期有効"),
    "init": MessageLookupByLibrary.simpleMessage("初期化"),
    "inputCorrectHotkey": MessageLookupByLibrary.simpleMessage("正しいホットキーを入力"),
    "intelligentSelected": MessageLookupByLibrary.simpleMessage("インテリジェント選択"),
    "internet": MessageLookupByLibrary.simpleMessage("インターネット"),
    "interval": MessageLookupByLibrary.simpleMessage("インターバル"),
    "intranetIP": MessageLookupByLibrary.simpleMessage("イントラネットIP"),
    "ipcidr": MessageLookupByLibrary.simpleMessage("IPCIDR"),
    "ipv6Desc": MessageLookupByLibrary.simpleMessage("有効化するとIPv6トラフィックを受信可能"),
    "ipv6InboundDesc": MessageLookupByLibrary.simpleMessage("IPv6インバウンドを許可"),
    "ja": MessageLookupByLibrary.simpleMessage("日本語"),
    "just": MessageLookupByLibrary.simpleMessage("たった今"),
    "keepAliveIntervalDesc": MessageLookupByLibrary.simpleMessage(
      "TCPキープアライブ間隔",
    ),
    "key": MessageLookupByLibrary.simpleMessage("キー"),
    "langSystem": MessageLookupByLibrary.simpleMessage("システム"),
    "language": MessageLookupByLibrary.simpleMessage("言語"),
    "launchAtStartup": MessageLookupByLibrary.simpleMessage("起動時に開く"),
    "layout": MessageLookupByLibrary.simpleMessage("レイアウト"),
    "light": MessageLookupByLibrary.simpleMessage("ライト"),
    "list": MessageLookupByLibrary.simpleMessage("リスト"),
    "listen": MessageLookupByLibrary.simpleMessage("リスン"),
    "local": MessageLookupByLibrary.simpleMessage("ローカル"),
    "localBackupDesc": MessageLookupByLibrary.simpleMessage("ローカルにデータをバックアップ"),
    "localRecoveryDesc": MessageLookupByLibrary.simpleMessage("ファイルからデータを復元"),
    "logLevel": MessageLookupByLibrary.simpleMessage("ログレベル"),
    "logcat": MessageLookupByLibrary.simpleMessage("ログキャット"),
    "logcatDesc": MessageLookupByLibrary.simpleMessage("無効化するとログエントリを非表示"),
    "login": MessageLookupByLibrary.simpleMessage("Log in"),
    "logout": MessageLookupByLibrary.simpleMessage("Log out"),
    "logoutConfirm": MessageLookupByLibrary.simpleMessage(
      "Log out of your account? The subscription will be removed from this device.",
    ),
    "logs": MessageLookupByLibrary.simpleMessage("ログ"),
    "logsDesc": MessageLookupByLibrary.simpleMessage("ログキャプチャ記録"),
    "logsTest": MessageLookupByLibrary.simpleMessage("ログテスト"),
    "loopback": MessageLookupByLibrary.simpleMessage("ループバック解除ツール"),
    "loopbackDesc": MessageLookupByLibrary.simpleMessage("UWPループバック解除用"),
    "loose": MessageLookupByLibrary.simpleMessage("疎"),
    "managedByProvider": MessageLookupByLibrary.simpleMessage(
      "これらの設定はプロバイダーによって管理されています",
    ),
    "managedByProviderHint": MessageLookupByLibrary.simpleMessage(
      "これらの設定はプロバイダーによって管理されます。",
    ),
    "managedByProviderNetwork": MessageLookupByLibrary.simpleMessage(
      "これらのパラメータはプロバイダーによって管理されています",
    ),
    "markAllRead": MessageLookupByLibrary.simpleMessage("すべて既読にする"),
    "memoryInfo": MessageLookupByLibrary.simpleMessage("メモリ情報"),
    "messageTest": MessageLookupByLibrary.simpleMessage("メッセージテスト"),
    "messageTestTip": MessageLookupByLibrary.simpleMessage("これはメッセージです。"),
    "min": MessageLookupByLibrary.simpleMessage("最小化"),
    "minimizeOnExit": MessageLookupByLibrary.simpleMessage("終了時に最小化"),
    "minimizeOnExitDesc": MessageLookupByLibrary.simpleMessage(
      "システムの終了イベントを変更",
    ),
    "minutes": MessageLookupByLibrary.simpleMessage("分"),
    "mixedPort": MessageLookupByLibrary.simpleMessage("混合ポート"),
    "mode": MessageLookupByLibrary.simpleMessage("モード"),
    "monochromeScheme": MessageLookupByLibrary.simpleMessage("モノクローム"),
    "months": MessageLookupByLibrary.simpleMessage("月"),
    "more": MessageLookupByLibrary.simpleMessage("詳細"),
    "name": MessageLookupByLibrary.simpleMessage("名前"),
    "nameSort": MessageLookupByLibrary.simpleMessage("名前順"),
    "nameserver": MessageLookupByLibrary.simpleMessage("ネームサーバー"),
    "nameserverDesc": MessageLookupByLibrary.simpleMessage("ドメイン解決用"),
    "nameserverPolicy": MessageLookupByLibrary.simpleMessage("ネームサーバーポリシー"),
    "nameserverPolicyDesc": MessageLookupByLibrary.simpleMessage(
      "対応するネームサーバーポリシーを指定",
    ),
    "navActivity": MessageLookupByLibrary.simpleMessage("アクティビティ"),
    "navConnect": MessageLookupByLibrary.simpleMessage("接続"),
    "navServers": MessageLookupByLibrary.simpleMessage("サーバー"),
    "network": MessageLookupByLibrary.simpleMessage("ネットワーク"),
    "networkDesc": MessageLookupByLibrary.simpleMessage("ネットワーク関連設定の変更"),
    "networkDetection": MessageLookupByLibrary.simpleMessage("あなたのIPアドレス"),
    "networkSpeed": MessageLookupByLibrary.simpleMessage("ネットワーク速度"),
    "neutralScheme": MessageLookupByLibrary.simpleMessage("ニュートラル"),
    "noAccountRegister": MessageLookupByLibrary.simpleMessage(
      "Don\'t have an account? Sign up",
    ),
    "noActiveSubscription": MessageLookupByLibrary.simpleMessage(
      "有効なサブスクリプションがありません",
    ),
    "noData": MessageLookupByLibrary.simpleMessage("データなし"),
    "noHotKey": MessageLookupByLibrary.simpleMessage("ホットキーなし"),
    "noIcon": MessageLookupByLibrary.simpleMessage("なし"),
    "noInfo": MessageLookupByLibrary.simpleMessage("情報なし"),
    "noMoreInfoDesc": MessageLookupByLibrary.simpleMessage("追加情報なし"),
    "noNetwork": MessageLookupByLibrary.simpleMessage("ネットワークなし"),
    "noNetworkApp": MessageLookupByLibrary.simpleMessage("ネットワークなしアプリ"),
    "noProxy": MessageLookupByLibrary.simpleMessage("プロキシなし"),
    "noProxyDesc": MessageLookupByLibrary.simpleMessage(
      "プロファイルを作成するか、有効なプロファイルを追加してください",
    ),
    "noResolve": MessageLookupByLibrary.simpleMessage("IPを解決しない"),
    "noSubHint": MessageLookupByLibrary.simpleMessage(
      "無料トライアルを取得するか、プランを選んで始めましょう。",
    ),
    "none": MessageLookupByLibrary.simpleMessage("なし"),
    "notSelectedTip": MessageLookupByLibrary.simpleMessage(
      "現在のプロキシグループは選択できません",
    ),
    "notSignedIn": MessageLookupByLibrary.simpleMessage("ログインしていません"),
    "notifications": MessageLookupByLibrary.simpleMessage("通知"),
    "nullProfileDesc": MessageLookupByLibrary.simpleMessage(
      "プロファイルがありません。追加してください",
    ),
    "nullScriptTip": MessageLookupByLibrary.simpleMessage("スクリプトはありません"),
    "nullTip": m9,
    "numberTip": m10,
    "oneColumn": MessageLookupByLibrary.simpleMessage("1列"),
    "oneline": MessageLookupByLibrary.simpleMessage("オンライン"),
    "onlyIcon": MessageLookupByLibrary.simpleMessage("アイコンのみ"),
    "onlyOtherApps": MessageLookupByLibrary.simpleMessage("サードパーティアプリのみ"),
    "onlyStatisticsProxy": MessageLookupByLibrary.simpleMessage("プロキシのみ統計"),
    "onlyStatisticsProxyDesc": MessageLookupByLibrary.simpleMessage(
      "有効化するとプロキシトラフィックのみ統計",
    ),
    "openLogsFolder": MessageLookupByLibrary.simpleMessage("ログフォルダを開く"),
    "options": MessageLookupByLibrary.simpleMessage("オプション"),
    "originalRepository": MessageLookupByLibrary.simpleMessage("オリジナルリポジトリ"),
    "other": MessageLookupByLibrary.simpleMessage("その他"),
    "otherContributors": MessageLookupByLibrary.simpleMessage("貢献者"),
    "outboundMode": MessageLookupByLibrary.simpleMessage("アウトバウンドモード"),
    "override": MessageLookupByLibrary.simpleMessage("上書き"),
    "overrideDesc": MessageLookupByLibrary.simpleMessage("プロキシ関連設定を上書き"),
    "overrideDns": MessageLookupByLibrary.simpleMessage("DNS上書き"),
    "overrideDnsDesc": MessageLookupByLibrary.simpleMessage(
      "有効化するとプロファイルのDNS設定を上書き",
    ),
    "overrideInvalidTip": MessageLookupByLibrary.simpleMessage(
      "スクリプトモードでは有効になりません",
    ),
    "overrideNetworkSettings": MessageLookupByLibrary.simpleMessage(
      "ネットワーク設定を上書き",
    ),
    "overrideNetworkSettingsDesc": MessageLookupByLibrary.simpleMessage(
      "プロバイダー設定のネットワーク設定を無視",
    ),
    "overrideOriginRules": MessageLookupByLibrary.simpleMessage("元のルールを上書き"),
    "overrideProviderSettings": MessageLookupByLibrary.simpleMessage("上書き"),
    "overrideProviderSettingsDesc": MessageLookupByLibrary.simpleMessage(
      "プロバイダーの設定を無視して手動で管理",
    ),
    "overrideProviderSettingsFull": MessageLookupByLibrary.simpleMessage(
      "プロバイダー設定を上書き",
    ),
    "palette": MessageLookupByLibrary.simpleMessage("パレット"),
    "password": MessageLookupByLibrary.simpleMessage("パスワード"),
    "paste": MessageLookupByLibrary.simpleMessage("貼り付け"),
    "planBestValue": MessageLookupByLibrary.simpleMessage("お得"),
    "planChoose": MessageLookupByLibrary.simpleMessage("選択"),
    "planDaysAccess": m11,
    "planDevice": m12,
    "planDevices": m13,
    "planFree": MessageLookupByLibrary.simpleMessage("無料"),
    "planGeneric": MessageLookupByLibrary.simpleMessage("サブスクリプション"),
    "planMonthly": MessageLookupByLibrary.simpleMessage("月額プラン"),
    "planNamed": m14,
    "planOneTime": MessageLookupByLibrary.simpleMessage("一回限り"),
    "planPerMonth": MessageLookupByLibrary.simpleMessage("/月"),
    "planPerYear": MessageLookupByLibrary.simpleMessage("/年"),
    "planTrafficAmount": m15,
    "planTrial": MessageLookupByLibrary.simpleMessage("トライアルプラン"),
    "planUnlimitedTraffic": MessageLookupByLibrary.simpleMessage("無制限トラフィック"),
    "planYearly": MessageLookupByLibrary.simpleMessage("年額プラン"),
    "plansBillingNote": MessageLookupByLibrary.simpleMessage(
      "価格は参考用です — 課金はまだ有効ではありません。",
    ),
    "plansLoadError": MessageLookupByLibrary.simpleMessage(
      "プランを読み込めませんでした。タップで再試行。",
    ),
    "plansSubtitle": MessageLookupByLibrary.simpleMessage(
      "トラフィックを保護。いつでも解約可能。",
    ),
    "pleaseBindWebDAV": MessageLookupByLibrary.simpleMessage(
      "WebDAVをバインドしてください",
    ),
    "pleaseEnterScriptName": MessageLookupByLibrary.simpleMessage(
      "スクリプト名を入力してください",
    ),
    "pleaseInputAdminPassword": MessageLookupByLibrary.simpleMessage(
      "管理者パスワードを入力",
    ),
    "pleaseUploadFile": MessageLookupByLibrary.simpleMessage(
      "ファイルをアップロードしてください",
    ),
    "pleaseUploadValidQrcode": MessageLookupByLibrary.simpleMessage(
      "有効なQRコードをアップロードしてください",
    ),
    "port": MessageLookupByLibrary.simpleMessage("ポート"),
    "portConflictTip": MessageLookupByLibrary.simpleMessage("別のポートを入力してください"),
    "portTip": m16,
    "preferH3Desc": MessageLookupByLibrary.simpleMessage("DOHのHTTP/3を優先使用"),
    "pressKeyboard": MessageLookupByLibrary.simpleMessage("キーボードを押してください"),
    "preview": MessageLookupByLibrary.simpleMessage("プレビュー"),
    "profile": MessageLookupByLibrary.simpleMessage("プロファイル"),
    "profileAutoUpdateIntervalInvalidValidationDesc":
        MessageLookupByLibrary.simpleMessage("有効な間隔形式を入力してください"),
    "profileAutoUpdateIntervalNullValidationDesc":
        MessageLookupByLibrary.simpleMessage("自動更新間隔を入力してください"),
    "profileHasUpdate": MessageLookupByLibrary.simpleMessage(
      "プロファイルが変更されました。自動更新を無効化しますか？",
    ),
    "profileNameNullValidationDesc": MessageLookupByLibrary.simpleMessage(
      "プロファイル名を入力してください",
    ),
    "profileParseErrorDesc": MessageLookupByLibrary.simpleMessage(
      "プロファイル解析エラー",
    ),
    "profileUrlInvalidValidationDesc": MessageLookupByLibrary.simpleMessage(
      "有効なプロファイルURLを入力してください",
    ),
    "profileUrlNullValidationDesc": MessageLookupByLibrary.simpleMessage(
      "プロファイルURLを入力してください",
    ),
    "profiles": MessageLookupByLibrary.simpleMessage("プロファイル一覧"),
    "profilesSort": MessageLookupByLibrary.simpleMessage("プロファイルの並び替え"),
    "project": MessageLookupByLibrary.simpleMessage("プロジェクト"),
    "providers": MessageLookupByLibrary.simpleMessage("プロバイダー"),
    "proxies": MessageLookupByLibrary.simpleMessage("プロキシ"),
    "proxiesSetting": MessageLookupByLibrary.simpleMessage("プロキシ設定"),
    "proxyGroup": MessageLookupByLibrary.simpleMessage("プロキシグループ"),
    "proxyNameserver": MessageLookupByLibrary.simpleMessage("プロキシネームサーバー"),
    "proxyNameserverDesc": MessageLookupByLibrary.simpleMessage(
      "プロキシノード解決用ドメイン",
    ),
    "proxyPort": MessageLookupByLibrary.simpleMessage("プロキシポート"),
    "proxyPortDesc": MessageLookupByLibrary.simpleMessage("Clashのリスニングポートを設定"),
    "proxyProviders": MessageLookupByLibrary.simpleMessage("プロキシプロバイダー"),
    "pureBlackMode": MessageLookupByLibrary.simpleMessage("純黒モード"),
    "qrcode": MessageLookupByLibrary.simpleMessage("QRコード"),
    "qrcodeDesc": MessageLookupByLibrary.simpleMessage("QRコードをスキャンしてプロファイルを取得"),
    "rainbowScheme": MessageLookupByLibrary.simpleMessage("レインボー"),
    "recovery": MessageLookupByLibrary.simpleMessage("復元"),
    "recoveryAll": MessageLookupByLibrary.simpleMessage("全データ復元"),
    "recoveryProfiles": MessageLookupByLibrary.simpleMessage("プロファイルのみ復元"),
    "recoveryStrategy": MessageLookupByLibrary.simpleMessage("リカバリー戦略"),
    "recoveryStrategy_compatible": MessageLookupByLibrary.simpleMessage("互換性"),
    "recoveryStrategy_override": MessageLookupByLibrary.simpleMessage(
      "オーバーライド",
    ),
    "recoverySuccess": MessageLookupByLibrary.simpleMessage("復元成功"),
    "redirPort": MessageLookupByLibrary.simpleMessage("Redirポート"),
    "redo": MessageLookupByLibrary.simpleMessage("やり直す"),
    "regExp": MessageLookupByLibrary.simpleMessage("正規表現"),
    "register": MessageLookupByLibrary.simpleMessage("Sign up"),
    "remaining": MessageLookupByLibrary.simpleMessage("残り"),
    "remainingPlural": MessageLookupByLibrary.simpleMessage("残り"),
    "remainingSingular": MessageLookupByLibrary.simpleMessage("残り"),
    "remote": MessageLookupByLibrary.simpleMessage("リモート"),
    "remoteBackupDesc": MessageLookupByLibrary.simpleMessage(
      "WebDAVにデータをバックアップ",
    ),
    "remoteRecoveryDesc": MessageLookupByLibrary.simpleMessage(
      "WebDAVからデータを復元",
    ),
    "remove": MessageLookupByLibrary.simpleMessage("削除"),
    "rename": MessageLookupByLibrary.simpleMessage("リネーム"),
    "renew": MessageLookupByLibrary.simpleMessage("更新"),
    "requests": MessageLookupByLibrary.simpleMessage("リクエスト"),
    "requestsDesc": MessageLookupByLibrary.simpleMessage("最近のリクエスト記録を表示"),
    "reset": MessageLookupByLibrary.simpleMessage("リセット"),
    "resetNetworkSettings": MessageLookupByLibrary.simpleMessage(
      "ネットワーク設定をリセット",
    ),
    "resetTip": MessageLookupByLibrary.simpleMessage("リセットを確定"),
    "resources": MessageLookupByLibrary.simpleMessage("リソース"),
    "resourcesDesc": MessageLookupByLibrary.simpleMessage("外部リソース関連情報"),
    "respectRules": MessageLookupByLibrary.simpleMessage("ルール尊重"),
    "respectRulesDesc": MessageLookupByLibrary.simpleMessage(
      "DNS接続がルールに従う（proxy-server-nameserverの設定が必要）",
    ),
    "restart": MessageLookupByLibrary.simpleMessage("再起動"),
    "retry": MessageLookupByLibrary.simpleMessage("再試行"),
    "routeAddress": MessageLookupByLibrary.simpleMessage("ルートアドレス"),
    "routeAddressDesc": MessageLookupByLibrary.simpleMessage("ルートアドレスを設定"),
    "routeMode": MessageLookupByLibrary.simpleMessage("ルートモード"),
    "routeMode_bypassPrivate": MessageLookupByLibrary.simpleMessage(
      "プライベートルートをバイパス",
    ),
    "routeMode_config": MessageLookupByLibrary.simpleMessage("設定を使用"),
    "ru": MessageLookupByLibrary.simpleMessage("ロシア語"),
    "rule": MessageLookupByLibrary.simpleMessage("ルールに従って"),
    "ruleName": MessageLookupByLibrary.simpleMessage("ルール名"),
    "ruleProviders": MessageLookupByLibrary.simpleMessage("ルールプロバイダー"),
    "ruleTarget": MessageLookupByLibrary.simpleMessage("ルール対象"),
    "running": MessageLookupByLibrary.simpleMessage("実行中"),
    "save": MessageLookupByLibrary.simpleMessage("保存"),
    "saveChanges": MessageLookupByLibrary.simpleMessage("変更を保存しますか？"),
    "saveTip": MessageLookupByLibrary.simpleMessage("保存してもよろしいですか？"),
    "script": MessageLookupByLibrary.simpleMessage("スクリプト"),
    "search": MessageLookupByLibrary.simpleMessage("検索"),
    "searchServers": MessageLookupByLibrary.simpleMessage("サーバーを検索"),
    "seconds": MessageLookupByLibrary.simpleMessage("秒"),
    "selectAll": MessageLookupByLibrary.simpleMessage("すべて選択"),
    "selected": MessageLookupByLibrary.simpleMessage("選択済み"),
    "selectedCountTitle": m17,
    "serverTimeout": MessageLookupByLibrary.simpleMessage("タイムアウト"),
    "serversEmptyHint": MessageLookupByLibrary.simpleMessage(
      "サブスクリプションを取得してサーバーを読み込みます。",
    ),
    "serversEmptyTitle": MessageLookupByLibrary.simpleMessage("サーバーがありません"),
    "serversTest": MessageLookupByLibrary.simpleMessage("テスト"),
    "serversTesting": MessageLookupByLibrary.simpleMessage("テスト中…"),
    "settings": MessageLookupByLibrary.simpleMessage("設定"),
    "settingsAdvanced": MessageLookupByLibrary.simpleMessage("詳細設定"),
    "settingsApp": MessageLookupByLibrary.simpleMessage("アプリ"),
    "settingsAppearance": MessageLookupByLibrary.simpleMessage("外観"),
    "settingsConnection": MessageLookupByLibrary.simpleMessage("接続"),
    "settingsPrivacy": MessageLookupByLibrary.simpleMessage("プライバシー"),
    "settingsSendDeviceDataSubtitle": MessageLookupByLibrary.simpleMessage(
      "デバイス識別子、アプリのバージョン、デバイス名をプロキシ提供元サーバーに送信します",
    ),
    "settingsSendDeviceDataTitle": MessageLookupByLibrary.simpleMessage(
      "HWID を送信",
    ),
    "show": MessageLookupByLibrary.simpleMessage("表示"),
    "shrink": MessageLookupByLibrary.simpleMessage("縮小"),
    "signIn": MessageLookupByLibrary.simpleMessage("ログイン"),
    "signInToManage": MessageLookupByLibrary.simpleMessage(
      "ログインしてサブスクリプションを管理します。",
    ),
    "silentLaunch": MessageLookupByLibrary.simpleMessage("バックグラウンド起動"),
    "silentLaunchDesc": MessageLookupByLibrary.simpleMessage("バックグラウンドで起動"),
    "size": MessageLookupByLibrary.simpleMessage("サイズ"),
    "socksPort": MessageLookupByLibrary.simpleMessage("Socksポート"),
    "sort": MessageLookupByLibrary.simpleMessage("並び替え"),
    "source": MessageLookupByLibrary.simpleMessage("ソース"),
    "sourceIp": MessageLookupByLibrary.simpleMessage("送信元IP"),
    "stackMode": MessageLookupByLibrary.simpleMessage("スタックモード"),
    "standard": MessageLookupByLibrary.simpleMessage("標準"),
    "start": MessageLookupByLibrary.simpleMessage("開始"),
    "startFreeTrial": MessageLookupByLibrary.simpleMessage("無料トライアルを開始"),
    "startVpn": MessageLookupByLibrary.simpleMessage("VPNを開始中..."),
    "status": MessageLookupByLibrary.simpleMessage("ステータス"),
    "statusActive": MessageLookupByLibrary.simpleMessage("有効"),
    "statusDesc": MessageLookupByLibrary.simpleMessage("無効時はシステムDNSを使用"),
    "statusFailed": MessageLookupByLibrary.simpleMessage("失敗"),
    "statusProvisioning": MessageLookupByLibrary.simpleMessage("設定中"),
    "stop": MessageLookupByLibrary.simpleMessage("停止"),
    "stopVpn": MessageLookupByLibrary.simpleMessage("VPNを停止中..."),
    "stopped": MessageLookupByLibrary.simpleMessage("停止中"),
    "style": MessageLookupByLibrary.simpleMessage("スタイル"),
    "subRule": MessageLookupByLibrary.simpleMessage("サブルール"),
    "submit": MessageLookupByLibrary.simpleMessage("送信"),
    "subscription": MessageLookupByLibrary.simpleMessage("Subscription"),
    "subscriptionEternal": MessageLookupByLibrary.simpleMessage("永久サブスクリプション"),
    "subscriptionExpired": MessageLookupByLibrary.simpleMessage(
      "サブスクリプションが期限切れになりました",
    ),
    "subscriptionExpiresInDays": m18,
    "subscriptionExpiresSoon": MessageLookupByLibrary.simpleMessage(
      "サブスクリプションがまもなく期限切れ",
    ),
    "subscriptionExpiresToday": MessageLookupByLibrary.simpleMessage(
      "サブスクリプションは本日期限切れになります",
    ),
    "subscriptionHistory": MessageLookupByLibrary.simpleMessage("サブスクリプション履歴"),
    "subscriptionPreparing": MessageLookupByLibrary.simpleMessage(
      "Your subscription is still being prepared. Please try again in a minute",
    ),
    "subscriptionUnlimited": MessageLookupByLibrary.simpleMessage(
      "永久サブスクリプション",
    ),
    "successTitle": MessageLookupByLibrary.simpleMessage("成功"),
    "support": MessageLookupByLibrary.simpleMessage("サポート"),
    "sync": MessageLookupByLibrary.simpleMessage("同期"),
    "system": MessageLookupByLibrary.simpleMessage("システム"),
    "systemApp": MessageLookupByLibrary.simpleMessage("システムアプリ"),
    "systemFont": MessageLookupByLibrary.simpleMessage("システムフォント"),
    "systemProxy": MessageLookupByLibrary.simpleMessage("システムプロキシ"),
    "systemProxyDesc": MessageLookupByLibrary.simpleMessage(
      "HTTPプロキシをVpnServiceに接続",
    ),
    "tab": MessageLookupByLibrary.simpleMessage("タブ"),
    "tabAnimation": MessageLookupByLibrary.simpleMessage("タブアニメーション"),
    "tabAnimationDesc": MessageLookupByLibrary.simpleMessage("モバイル表示でのみ有効"),
    "tcpConcurrent": MessageLookupByLibrary.simpleMessage("TCP並列処理"),
    "tcpConcurrentDesc": MessageLookupByLibrary.simpleMessage("TCP並列処理を許可"),
    "testUrl": MessageLookupByLibrary.simpleMessage("URLテスト"),
    "textScale": MessageLookupByLibrary.simpleMessage("テキストスケーリング"),
    "thanks": MessageLookupByLibrary.simpleMessage("貢献に感謝"),
    "theme": MessageLookupByLibrary.simpleMessage("テーマ"),
    "themeColor": MessageLookupByLibrary.simpleMessage("テーマカラー"),
    "themeDesc": MessageLookupByLibrary.simpleMessage("ダークモードの設定、色の調整"),
    "themeMode": MessageLookupByLibrary.simpleMessage("テーマモード"),
    "threeColumns": MessageLookupByLibrary.simpleMessage("3列"),
    "tight": MessageLookupByLibrary.simpleMessage("密"),
    "time": MessageLookupByLibrary.simpleMessage("時間"),
    "tip": MessageLookupByLibrary.simpleMessage("ヒント"),
    "toggle": MessageLookupByLibrary.simpleMessage("トグル"),
    "tonalSpotScheme": MessageLookupByLibrary.simpleMessage("トーンスポット"),
    "tooFrequentOperation": MessageLookupByLibrary.simpleMessage(
      "再度更新する前に15秒お待ちください",
    ),
    "tools": MessageLookupByLibrary.simpleMessage("設定"),
    "tproxyPort": MessageLookupByLibrary.simpleMessage("Tproxyポート"),
    "traffic": MessageLookupByLibrary.simpleMessage("トラフィック"),
    "trafficUnlimited": MessageLookupByLibrary.simpleMessage("無制限トラフィック"),
    "trafficUsage": MessageLookupByLibrary.simpleMessage("トラフィック使用量"),
    "tun": MessageLookupByLibrary.simpleMessage("TUN"),
    "tunDesc": MessageLookupByLibrary.simpleMessage("管理者モードでのみ有効"),
    "twoColumns": MessageLookupByLibrary.simpleMessage("2列"),
    "unableToUpdateCurrentProfileDesc": MessageLookupByLibrary.simpleMessage(
      "現在のプロファイルを更新できません",
    ),
    "undo": MessageLookupByLibrary.simpleMessage("元に戻す"),
    "unifiedDelay": MessageLookupByLibrary.simpleMessage("統一遅延"),
    "unifiedDelayDesc": MessageLookupByLibrary.simpleMessage(
      "ハンドシェイクなどの余分な遅延を削除",
    ),
    "unknown": MessageLookupByLibrary.simpleMessage("不明"),
    "unnamed": MessageLookupByLibrary.simpleMessage("無題"),
    "update": MessageLookupByLibrary.simpleMessage("更新"),
    "updateAllGeoData": MessageLookupByLibrary.simpleMessage("すべての地理データを更新"),
    "updated": MessageLookupByLibrary.simpleMessage("更新済み"),
    "upgradePlan": MessageLookupByLibrary.simpleMessage("プランをアップグレード"),
    "upload": MessageLookupByLibrary.simpleMessage("アップロード"),
    "url": MessageLookupByLibrary.simpleMessage("URL"),
    "urlDesc": MessageLookupByLibrary.simpleMessage("URL経由でプロファイルを取得"),
    "urlTip": m19,
    "useHosts": MessageLookupByLibrary.simpleMessage("ホストを使用"),
    "useSystemHosts": MessageLookupByLibrary.simpleMessage("システムホストを使用"),
    "value": MessageLookupByLibrary.simpleMessage("値"),
    "vibrantScheme": MessageLookupByLibrary.simpleMessage("ビブラント"),
    "view": MessageLookupByLibrary.simpleMessage("表示"),
    "viewPlans": MessageLookupByLibrary.simpleMessage("プランを見る"),
    "vpnDesc": MessageLookupByLibrary.simpleMessage("VPN関連設定の変更"),
    "vpnEnableDesc": MessageLookupByLibrary.simpleMessage(
      "VpnService経由で全システムトラフィックをルーティング",
    ),
    "vpnSystemProxyDesc": MessageLookupByLibrary.simpleMessage(
      "HTTPプロキシをVpnServiceに接続",
    ),
    "vpnTip": MessageLookupByLibrary.simpleMessage("変更はVPN再起動後に有効"),
    "webDAVConfiguration": MessageLookupByLibrary.simpleMessage("WebDAV設定"),
    "whitelistMode": MessageLookupByLibrary.simpleMessage("ホワイトリストモード"),
    "years": MessageLookupByLibrary.simpleMessage("年"),
    "zh_CN": MessageLookupByLibrary.simpleMessage("簡体字中国語"),
  };
}
