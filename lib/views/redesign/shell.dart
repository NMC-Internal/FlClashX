import 'dart:async';

import 'package:flclashx/common/common.dart';
import 'package:flclashx/design/tokens.dart';
import 'package:flclashx/models/models.dart';
import 'package:flclashx/pages/auth/auth_state.dart';
import 'package:flclashx/providers/providers.dart';
import 'package:flclashx/state.dart';
import 'package:flclashx/views/redesign/account_view.dart';
import 'package:flclashx/views/redesign/activity_view.dart';
import 'package:flclashx/views/redesign/connect_view.dart';
import 'package:flclashx/views/redesign/servers_view.dart';
import 'package:flclashx/views/redesign/settings_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:forui/forui.dart';

/// Breakpoint between the mobile bottom-bar layout and the desktop rail layout.
const double _kRailBreakpoint = 600;

class _Dest {
  const _Dest(this.label, this.icon, this.activeIcon, this.view);
  final String label;
  final IconData icon;
  final IconData activeIcon;
  final Widget view;
}

/// Root of the redesigned UI (ADR 0013): a 5-section app-shell with a mobile
/// bottom bar (<600px) or a desktop side rail (≥600px). Activity is a
/// first-class section. The five views are kept alive via an [IndexedStack].
class RedesignShell extends ConsumerStatefulWidget {
  const RedesignShell({super.key});

  @override
  ConsumerState<RedesignShell> createState() => _RedesignShellState();
}

class _RedesignShellState extends ConsumerState<RedesignShell> {
  bool _provisioning = false;

  static const _dests = <_Dest>[
    _Dest('Connect', Icons.shield_outlined, Icons.shield, RConnectView()),
    _Dest('Servers', Icons.public_outlined, Icons.public, RServersView()),
    _Dest('Activity', Icons.show_chart, Icons.show_chart, RActivityView()),
    _Dest('Account', Icons.person_outline, Icons.person, RAccountView()),
    _Dest('Settings', Icons.tune_outlined, Icons.tune, RSettingsView()),
  ];

  // ignore: use_setters_to_change_properties — passed as an onSelect callback.
  void _select(int i) => ref.read(shellTabProvider.notifier).state = i;

  /// 401-probe (ADR 0013): a 401 on `/v1/me` means the session expired — drop to
  /// guest and toast. Network/5xx errors surface as other [AuthErrorKind]s and
  /// must NOT log the user out.
  Future<void> _handleSessionExpired() async {
    if (ref.read(authTokenProvider) == null) return; // already guest
    await globalState.appController.clearProfiles();
    await preferences.clearAuthToken();
    await preferences.clearUserEmail();
    ref.read(pendingSubscriptionUrlProvider.notifier).state = null;
    ref.read(authTokenProvider.notifier).state = null;
    if (!mounted) return;
    showFToast(
      context: context,
      title: Text(appLocalizations.authErrorSessionExpired),
    );
  }

  /// Self-heal (ADR 0013): if the account has an active subscription but no
  /// profile is staged, provision it reactively. Boot-time provisioning
  /// (`Application` / `showAuthSheet`) runs only once and can miss — the `/me`
  /// fetch failed, or the subscription was still `provisioning` (ADR 0009).
  /// Without this, Servers/Connect stay stuck at "No servers yet" until an app
  /// restart. Guarded so it runs at most once at a time and only when needed.
  Future<void> _ensureProvisioned(Me? me) async {
    if (me == null || _provisioning) return;
    if (ref.read(currentProfileIdProvider) != null) return;
    final url = me.subscriptionUrl;
    commonPrint.log(
      'Shell self-heal: no current profile; '
      'subscriptionUrl=${url.isEmpty ? "<empty>" : "present"}',
    );
    if (url.isEmpty) return;
    _provisioning = true;
    try {
      await globalState.appController.provisionSubscription(url);
    } catch (e) {
      commonPrint.log('Shell reactive provisioning failed: $e');
    } finally {
      _provisioning = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    ref.listen<AsyncValue<Me?>>(meProvider, (prev, next) {
      next.whenOrNull(
        data: (me) => unawaited(_ensureProvisioned(me)),
        error: (e, _) {
          if (e is AuthException && e.kind == AuthErrorKind.sessionExpired) {
            unawaited(_handleSessionExpired());
          }
        },
      );
    });

    final index = ref.watch(shellTabProvider);
    final body = IndexedStack(
      index: index,
      children: [for (final d in _dests) d.view],
    );

    return Scaffold(
      backgroundColor: AppTokens.bg,
      body: LayoutBuilder(
        builder: (context, constraints) {
          if (constraints.maxWidth >= _kRailBreakpoint) {
            return Row(
              children: [
                _Rail(index: index, onSelect: _select),
                const VerticalDivider(width: 1, thickness: 1, color: AppTokens.border),
                Expanded(child: SafeArea(left: false, child: body)),
              ],
            );
          }
          return Column(
            children: [
              Expanded(child: SafeArea(bottom: false, child: body)),
              _BottomBar(index: index, onSelect: _select),
            ],
          );
        },
      ),
    );
  }
}

class _BottomBar extends StatelessWidget {
  const _BottomBar({required this.index, required this.onSelect});

  final int index;
  final ValueChanged<int> onSelect;

  @override
  Widget build(BuildContext context) => Container(
        decoration: const BoxDecoration(
          color: AppTokens.surface,
          border: Border(top: BorderSide(color: AppTokens.border)),
        ),
        child: SafeArea(
          top: false,
          child: SizedBox(
            height: 62,
            child: Row(
              children: [
                for (var i = 0; i < _RedesignShellState._dests.length; i++)
                  Expanded(
                    child: _BarItem(
                      dest: _RedesignShellState._dests[i],
                      selected: i == index,
                      onTap: () => onSelect(i),
                    ),
                  ),
              ],
            ),
          ),
        ),
      );
}

class _BarItem extends StatelessWidget {
  const _BarItem({required this.dest, required this.selected, required this.onTap});

  final _Dest dest;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final color = selected ? AppTokens.accent : AppTokens.muted;
    return InkWell(
      onTap: onTap,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(selected ? dest.activeIcon : dest.icon, size: 24, color: color),
          const SizedBox(height: 4),
          Text(
            dest.label,
            style: TextStyle(
              color: color,
              fontSize: 10,
              fontWeight: selected ? FontWeight.w500 : FontWeight.w400,
            ),
          ),
        ],
      ),
    );
  }
}

class _Rail extends StatelessWidget {
  const _Rail({required this.index, required this.onSelect});

  final int index;
  final ValueChanged<int> onSelect;

  @override
  Widget build(BuildContext context) => Container(
        width: 232,
        color: AppTokens.surface,
        child: SafeArea(
          right: false,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Padding(
                padding: EdgeInsets.fromLTRB(20, 24, 20, 24),
                child: Row(
                  children: [
                    Icon(Icons.shield, color: AppTokens.accent, size: 24),
                    SizedBox(width: 10),
                    Text(
                      'Fantomask VPN',
                      style: TextStyle(
                        color: AppTokens.text,
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 0.2,
                      ),
                    ),
                  ],
                ),
              ),
              for (var i = 0; i < _RedesignShellState._dests.length; i++)
                _RailItem(
                  dest: _RedesignShellState._dests[i],
                  selected: i == index,
                  onTap: () => onSelect(i),
                ),
            ],
          ),
        ),
      );
}

class _RailItem extends StatelessWidget {
  const _RailItem({required this.dest, required this.selected, required this.onTap});

  final _Dest dest;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final color = selected ? AppTokens.accent : AppTokens.muted;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 2),
      child: Material(
        color: selected ? AppTokens.accentTint : Colors.transparent,
        borderRadius: BorderRadius.circular(AppTokens.rField),
        child: InkWell(
          borderRadius: BorderRadius.circular(AppTokens.rField),
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 11),
            child: Row(
              children: [
                Icon(selected ? dest.activeIcon : dest.icon, size: 20, color: color),
                const SizedBox(width: 12),
                Text(
                  dest.label,
                  style: TextStyle(
                    color: color,
                    fontSize: 15,
                    fontWeight: selected ? FontWeight.w600 : FontWeight.w400,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
