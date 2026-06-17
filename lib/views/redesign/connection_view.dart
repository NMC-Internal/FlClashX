import 'dart:io';

import 'package:flclashx/common/common.dart';
import 'package:flclashx/models/models.dart';
import 'package:flclashx/providers/providers.dart';
import 'package:flclashx/state.dart';
import 'package:flclashx/views/redesign/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Redesigned "Connection" settings — replaces the legacy `ConfigView`.
///
/// Curated for a consumer VPN: the subscription (Remnawave) owns the network and
/// DNS config, so the clash power-user controls (DNS editors, ports, UA, stack
/// mode, log level, …) are intentionally not surfaced. What remains:
///   • Connection — the tunnel/routing mode (desktop: TUN + system proxy;
///     Android: VPN).
///   • Advanced — Android split-tunnel and reset.
/// The override-network / override-provider gates and the send-HWID toggle were
/// removed: network config is always from the subscription, app-launch settings
/// are always manual, and device headers are always sent (pinned in
/// `AppController.init`). Removed UI keeps the underlying engine providers.
class RConnectionView extends ConsumerWidget {
  const RConnectionView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) => ListView(
        padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
        children: [
          RSectionLabel(appLocalizations.settingsConnection),
          RGroup(children: _connectionRows(ref)),
          const SizedBox(height: 22),
          RSectionLabel(appLocalizations.settingsAdvanced),
          RGroup(children: _advancedRows(ref)),
        ],
      );

  List<Widget> _connectionRows(WidgetRef ref) => [
        if (system.isDesktop) ...[
          RSwitchRow(
            icon: Icons.vpn_lock_outlined,
            title: appLocalizations.tun,
            subtitle: appLocalizations.tunDesc,
            value: ref.watch(patchClashConfigProvider.select((s) => s.tun.enable)),
            onChanged: (v) => ref
                .read(patchClashConfigProvider.notifier)
                .updateState((s) => s.copyWith.tun(enable: v)),
          ),
          const RGroupDivider(),
          RSwitchRow(
            icon: Icons.lan_outlined,
            title: appLocalizations.systemProxy,
            subtitle: appLocalizations.systemProxyDesc,
            value: ref.watch(networkSettingProvider.select((s) => s.systemProxy)),
            onChanged: (v) => ref
                .read(networkSettingProvider.notifier)
                .updateState((s) => s.copyWith(systemProxy: v)),
          ),
        ],
        if (Platform.isAndroid)
          RSwitchRow(
            icon: Icons.vpn_lock_outlined,
            title: 'VPN',
            subtitle: appLocalizations.vpnEnableDesc,
            value: ref.watch(vpnSettingProvider.select((s) => s.enable)),
            onChanged: (v) => ref
                .read(vpnSettingProvider.notifier)
                .updateState((s) => s.copyWith(enable: v)),
          ),
      ];

  List<Widget> _advancedRows(WidgetRef ref) => [
        if (Platform.isAndroid) ...[
          RSwitchRow(
            icon: Icons.alt_route_outlined,
            title: appLocalizations.allowBypass,
            subtitle: appLocalizations.allowBypassDesc,
            value: ref.watch(vpnSettingProvider.select((s) => s.allowBypass)),
            onChanged: (v) => ref
                .read(vpnSettingProvider.notifier)
                .updateState((s) => s.copyWith(allowBypass: v)),
          ),
          const RGroupDivider(),
        ],
        RNavRow(
          icon: Icons.replay,
          title: appLocalizations.resetNetworkSettings,
          trailing: const SizedBox.shrink(),
          onTap: () => _resetNetwork(ref),
        ),
      ];

  Future<void> _resetNetwork(WidgetRef ref) async {
    final ok = await globalState.showMessage(
      title: appLocalizations.reset,
      message: TextSpan(text: appLocalizations.resetTip),
    );
    if (ok != true) return;
    ref.read(vpnSettingProvider.notifier).updateState(
          (s) => defaultVpnProps.copyWith(accessControl: s.accessControl),
        );
    ref.read(patchClashConfigProvider.notifier).updateState(
          (s) => s.copyWith(tun: defaultTun),
        );
  }
}

