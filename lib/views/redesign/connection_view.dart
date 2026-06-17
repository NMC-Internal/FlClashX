import 'dart:io';

import 'package:flclashx/common/common.dart';
import 'package:flclashx/design/tokens.dart';
import 'package:flclashx/models/models.dart';
import 'package:flclashx/providers/providers.dart';
import 'package:flclashx/state.dart';
import 'package:flclashx/views/redesign/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Redesigned "Connection" settings — replaces the legacy `ConfigView`.
///
/// Curated for a consumer VPN: the subscription (Remnawave) owns the network and
/// DNS config, so the clash power-user controls (DNS editors, ports, UA, stack
/// mode, log level, …) are intentionally not surfaced. What remains:
///   • Connection — the tunnel/routing mode (desktop: TUN + system proxy;
///     Android: VPN).
///   • Privacy — send device data (HWID).
///   • Advanced — the override-network gate, Android split-tunnel, and reset.
/// Removed settings keep their engine providers (they fall back to defaults /
/// the subscription's values).
class RConnectionView extends ConsumerWidget {
  const RConnectionView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) => ListView(
        padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
        children: [
          RSectionLabel(appLocalizations.settingsConnection),
          RGroup(children: _connectionRows(ref)),
          const SizedBox(height: 22),
          RSectionLabel(appLocalizations.settingsPrivacy),
          const RGroup(children: [_SendHwidRow()]),
          const SizedBox(height: 22),
          RSectionLabel(appLocalizations.settingsAdvanced),
          RGroup(children: _advancedRows(context, ref)),
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

  List<Widget> _advancedRows(BuildContext context, WidgetRef ref) {
    final override = ref.watch(appSettingProvider.select((s) => s.overrideNetworkSettings));
    return [
      RSwitchRow(
        icon: Icons.edit_outlined,
        title: appLocalizations.overrideNetworkSettings,
        subtitle: appLocalizations.overrideNetworkSettingsDesc,
        value: override,
        onChanged: (v) => ref
            .read(appSettingProvider.notifier)
            .updateState((s) => s.copyWith(overrideNetworkSettings: v)),
      ),
      if (!override) const _ProviderHint(),
      if (Platform.isAndroid) ...[
        const RGroupDivider(),
        RSwitchRow(
          icon: Icons.alt_route_outlined,
          title: appLocalizations.allowBypass,
          subtitle: appLocalizations.allowBypassDesc,
          value: ref.watch(vpnSettingProvider.select((s) => s.allowBypass)),
          onChanged: (v) => ref
              .read(vpnSettingProvider.notifier)
              .updateState((s) => s.copyWith(allowBypass: v)),
        ),
      ],
      const RGroupDivider(),
      RNavRow(
        icon: Icons.replay,
        title: appLocalizations.resetNetworkSettings,
        trailing: const SizedBox.shrink(),
        onTap: () => _resetNetwork(ref),
      ),
    ];
  }

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

/// The "managed by your provider" note shown when override-network is off.
class _ProviderHint extends StatelessWidget {
  const _ProviderHint();

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.fromLTRB(14, 0, 14, 10),
        child: Row(
          children: [
            const Icon(Icons.info_outline, size: 15, color: AppTokens.accent),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                appLocalizations.managedByProviderHint,
                style: const TextStyle(color: AppTokens.muted, fontSize: 12),
              ),
            ),
          ],
        ),
      );
}

/// "Send device data" (HWID) — a raw SharedPreferences flag (`sendDeviceHeaders`,
/// default on), not a Riverpod provider, so it manages its own state.
class _SendHwidRow extends StatefulWidget {
  const _SendHwidRow();

  @override
  State<_SendHwidRow> createState() => _SendHwidRowState();
}

class _SendHwidRowState extends State<_SendHwidRow> {
  static const _key = 'sendDeviceHeaders';
  bool _value = true;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final prefs = await SharedPreferences.getInstance();
    if (mounted) setState(() => _value = prefs.getBool(_key) ?? true);
  }

  Future<void> _set(bool v) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_key, v);
    if (mounted) setState(() => _value = v);
  }

  @override
  Widget build(BuildContext context) => RSwitchRow(
        icon: Icons.perm_device_information_outlined,
        title: appLocalizations.settingsSendDeviceDataTitle,
        subtitle: appLocalizations.settingsSendDeviceDataSubtitle,
        value: _value,
        onChanged: _set,
      );
}
