import 'dart:async';

import 'package:flclashx/common/common.dart';
import 'package:flclashx/enum/enum.dart';
import 'package:flclashx/pages/auth/auth_state.dart';
import 'package:flclashx/plugins/tile.dart';
import 'package:flclashx/providers/providers.dart';
import 'package:flclashx/state.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AppStateManager extends ConsumerStatefulWidget {

  const AppStateManager({
    super.key,
    required this.child,
  });
  final Widget child;

  @override
  ConsumerState<AppStateManager> createState() => _AppStateManagerState();
}

class _AppStateManagerState extends ConsumerState<AppStateManager>
    with WidgetsBindingObserver {
  // Last lifecycle state seen, used to detect background→foreground transitions
  // (macOS popover reopen never emits `resumed`; see didChangeAppLifecycleState).
  AppLifecycleState? _lastLifecycleState;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    ref.listenManual(layoutChangeProvider, (prev, next) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (prev != next) {
          globalState.cacheHeightMap = {};
        }
      });
    });
    ref.listenManual(
      checkIpProvider,
      (prev, next) {
        if (prev != next && next.b) {
          detectionState.startCheck();
        }
      },
      fireImmediately: true,
    );
    ref.listenManual(configStateProvider, (prev, next) {
      if (prev != next) {
        globalState.appController.savePreferencesDebounce();
      }
    });
    ref.listenManual(
      autoSetSystemDnsStateProvider,
      (prev, next) async {
        if (prev == next) {
          return;
        }
        if (next.a == true && next.b == true) {
          system.setMacOSDns(false);
        } else {
          system.setMacOSDns(true);
        }
      },
    );
    ref.listenManual(
      patchClashConfigProvider.select((state) => state.mode),
      (prev, next) {
        if (prev != next) {
          tile?.updateMode(next.name);
        }
      },
      fireImmediately: true,
    );
    ref.listenManual(
      globalModeEnabledProvider,
      (prev, next) {
        if (prev != next) {
          tile?.updateGlobalModeEnabled(next);
        }
      },
      fireImmediately: true,
    );
    ref.listenManual(
      globalModeEnabledProvider,
      (prev, next) {
        if (next) {
          return;
        }
        final currentMode = ref.read(
          patchClashConfigProvider.select((state) => state.mode),
        );
        if (currentMode != Mode.global) {
          return;
        }
        WidgetsBinding.instance.addPostFrameCallback((_) {
          globalState.appController.changeMode(Mode.rule);
        });
      },
      fireImmediately: true,
    );
  }

  @override
  void reassemble() {
    super.reassemble();
  }

  @override
  void dispose() async {
    await system.setMacOSDns(true);
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  Future<void> didChangeAppLifecycleState(AppLifecycleState state) async {
    commonPrint.log("$state");
    final previous = _lastLifecycleState;
    _lastLifecycleState = state;

    if (state == AppLifecycleState.paused ||
        state == AppLifecycleState.inactive) {
      globalState.appController.savePreferences();
    } else {
      render?.resume();
    }

    // Refetch /v1/me whenever the app returns to the foreground so subscriptions
    // bought via the bot (adopted on the backend) and a freshly linked Telegram show
    // up without a manual refresh (ADR 0018). Works on every platform (alt-tab /
    // app-switch return included), but is required on macOS: there the app is a
    // status-bar popover — windowManager is disabled, so onWindowFocus never fires,
    // and reopening the popover does NOT emit `resumed`. The popover rests at `hidden`
    // when closed and flips to `inactive` when shown, so we refetch on any
    // background→foreground edge rather than on `resumed` alone. The closing churn
    // (hidden→inactive→hidden) can fire one extra benign GET; meProvider is autoDispose
    // and the request is a cheap idempotent read, so that's acceptable.
    final cameToForeground =
        previous != null && !_isForeground(previous) && _isForeground(state);
    if (cameToForeground && mounted) {
      ref.invalidate(meProvider);
    }
  }

  /// The app is "in the foreground" (visible to the user) when [state] is
  /// `resumed` or `inactive`. A shown macOS popover is typically `inactive` (it
  /// rarely reaches `resumed`), so both count as foreground; `hidden`/`paused`/
  /// `detached` mean the popover is closed / the app is backgrounded. Note a
  /// `paused`→`resumed`/`inactive` transition (mobile/desktop) still counts.
  static bool _isForeground(AppLifecycleState state) =>
      state == AppLifecycleState.resumed || state == AppLifecycleState.inactive;

  @override
  void didChangePlatformBrightness() {
    globalState.appController.updateBrightness(
      WidgetsBinding.instance.platformDispatcher.platformBrightness,
    );
  }

  @override
  Widget build(BuildContext context) => Listener(
      onPointerHover: (_) {
        render?.resume();
      },
      child: widget.child,
    );
}

class AppEnvManager extends StatelessWidget {

  const AppEnvManager({
    super.key,
    required this.child,
  });
  final Widget child;

  @override
  Widget build(BuildContext context) {
    if (kDebugMode) {
      if (globalState.isPre) {
        return Banner(
          message: 'DEBUG',
          location: BannerLocation.topEnd,
          child: child,
        );
      }
    }
    if (globalState.isPre) {
      return Banner(
        message: 'PRE',
        location: BannerLocation.topEnd,
        child: child,
      );
    }
    return child;
  }
}
