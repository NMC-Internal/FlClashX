import 'dart:async';

import 'package:app_links/app_links.dart';

import 'print.dart';

/// Listens to inbound app links.
///
/// In this single-subscription product the old `install-config?url=` deep link
/// (which imported an arbitrary subscription URL) is intentionally removed: the
/// subscription is provisioned programmatically after login. The listener is
/// kept so the platform link stream is consumed and a place exists to handle
/// future, trusted deep links.
class LinkManager {

  factory LinkManager() {
    _instance ??= LinkManager._internal();
    return _instance!;
  }

  LinkManager._internal() {
    _appLinks = AppLinks();
  }
  static LinkManager? _instance;
  late AppLinks _appLinks;
  StreamSubscription? subscription;

  Future<void> initAppLinksListen() async {
    commonPrint.log("initAppLinksListen");
    destroy();
    subscription = _appLinks.uriLinkStream.listen(
      (uri) {
        commonPrint.log('onAppLink: $uri');
        // No deep-link actions are handled in this build.
      },
    );
  }

  void destroy() {
    if (subscription != null) {
      subscription?.cancel();
      subscription = null;
    }
  }
}

final linkManager = LinkManager();
