import 'dart:io';
import 'package:flutter/services.dart';

class StatusBarManager {
  static const MethodChannel _channel = MethodChannel('status_bar_icon');

  static Future<void> updateIcon({required bool isConnected}) async {
    if (!Platform.isMacOS) return;

    try {
      await _channel.invokeMethod('updateIcon', {
        'isConnected': isConnected,
      });
    } catch (e) {
      // silent
    }
  }

  /// Registers [onShown], called whenever the macOS status-bar popover is shown
  /// (native `NSPopover` → `popoverDidShow`). This is the reliable "app became
  /// visible" signal on macOS, where the popover does not emit a dependable
  /// AppLifecycleState.resumed. No-op off macOS. Pass null to clear the handler.
  static void setPopoverShownHandler(Future<void> Function()? onShown) {
    if (!Platform.isMacOS) return;

    if (onShown == null) {
      _channel.setMethodCallHandler(null);
      return;
    }

    _channel.setMethodCallHandler((call) async {
      if (call.method == 'popoverDidShow') {
        await onShown();
      }
      return null;
    });
  }
}
