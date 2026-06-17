import 'dart:convert';

import 'package:flclashx/common/common.dart';
import 'package:flclashx/design/tokens.dart';
import 'package:flclashx/enum/enum.dart';
import 'package:flclashx/models/models.dart';
import 'package:flclashx/pages/auth/auth_state.dart';
import 'package:flclashx/providers/providers.dart';
import 'package:flclashx/state.dart';
import 'package:flclashx/views/redesign/auth_sheet.dart';
import 'package:flclashx/views/redesign/notifications_view.dart';
import 'package:flclashx/views/redesign/plans_view.dart';
import 'package:flclashx/views/redesign/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// The hero-home of the redesigned UI: a connect/disconnect orb plus the
/// account-derived state (guest, no-subscription, provisioning, expired, failed,
/// active-disconnected, connected). Reuses the existing engine providers
/// ([runTimeProvider], [startButtonSelectorStateProvider]) — no new core calls.
class RConnectView extends ConsumerWidget {
  const RConnectView({super.key});

  void _toggle(bool next) {
    debouncer.call(
      FunctionTag.updateStatus,
      () => globalState.appController.updateStatus(next),
      duration: commonDuration,
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final running = ref.watch(runTimeProvider.select((s) => s != null));
    final runTime = ref.watch(runTimeProvider);
    final meAsync = ref.watch(meProvider);
    final me = meAsync.valueOrNull;
    final token = ref.watch(authTokenProvider);

    final sub = me?.activeSubscription;

    final phase = _resolve(
      token: token,
      me: me,
      sub: sub,
      running: running,
    );

    return Container(
      color: AppTokens.bg,
      child: Column(
        children: [
          const _Header(),
          Expanded(
            child: Center(
              child: SingleChildScrollView(
                child: _Body(
                  phase: phase,
                  runTime: runTime,
                  sub: sub,
                  trialEligible: me?.trialEligible ?? true,
                  onToggle: () => _toggle(!running),
                  onClaimTrial: () => showAuthSheet(context),
                  onSignIn: () => showAuthSheet(context),
                  onViewPlans: () => Navigator.of(context).push(
                    MaterialPageRoute<void>(builder: (_) => const RPlansView()),
                  ),
                  onRetry: () => ref.invalidate(meProvider),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  _Phase _resolve({
    required String? token,
    required Me? me,
    required Subscription? sub,
    required bool running,
  }) {
    if (running) return _Phase.connected;
    if (token == null || token.isEmpty) return _Phase.guest;
    if (sub == null) return _Phase.noSubscription;
    if (sub.isFailed) return _Phase.failed;
    if (sub.isProvisioning) return _Phase.provisioning; // only the real status
    if (sub.isExpired) return _Phase.expired;
    // Active subscription — ready to connect (don't gate on profile/groups
    // being staged; the engine handles readiness on tap).
    return _Phase.disconnected;
  }
}

enum _Phase { guest, noSubscription, provisioning, expired, failed, disconnected, connected }

class _Header extends StatelessWidget {
  const _Header();

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
        child: Row(
          children: [
            const Spacer(),
            const Text(
              'Fantomask VPN',
              style: TextStyle(
                color: AppTokens.text,
                fontSize: 20,
                fontWeight: FontWeight.w700,
                letterSpacing: 0.2,
              ),
            ),
            Expanded(
              child: Align(
                alignment: Alignment.centerRight,
                child: IconButton(
                  onPressed: () => Navigator.of(context).push(
                    MaterialPageRoute<void>(builder: (_) => const RNotificationsView()),
                  ),
                  icon: const Icon(Icons.notifications_none,
                      color: AppTokens.muted, size: 24),
                ),
              ),
            ),
          ],
        ),
      );
}

class _Body extends StatelessWidget {
  const _Body({
    required this.phase,
    required this.runTime,
    required this.sub,
    required this.trialEligible,
    required this.onToggle,
    required this.onClaimTrial,
    required this.onSignIn,
    required this.onViewPlans,
    required this.onRetry,
  });

  final _Phase phase;
  final int? runTime;
  final Subscription? sub;
  final bool trialEligible;
  final VoidCallback onToggle;
  final VoidCallback onClaimTrial;
  final VoidCallback onSignIn;
  final VoidCallback onViewPlans;
  final VoidCallback onRetry;

  bool get _connected => phase == _Phase.connected;
  bool get _canTap => phase == _Phase.disconnected || phase == _Phase.connected;

  ({String title, String subtitle}) get _labels => switch (phase) {
        _Phase.connected => (
            title: appLocalizations.connectProtected,
            subtitle: runTime != null
                ? appLocalizations.connectConnectedFor(utils.getTimeText(runTime))
                : appLocalizations.connectConnected,
          ),
        _Phase.disconnected => (
            title: appLocalizations.connectTapToConnect,
            subtitle: appLocalizations.connectNotProtected,
          ),
        _Phase.provisioning => (
            title: appLocalizations.connectProvisioning,
            subtitle: appLocalizations.connectProvisioningHint,
          ),
        _Phase.expired => (
            title: appLocalizations.connectExpiredTitle,
            subtitle: appLocalizations.connectExpiredHint,
          ),
        _Phase.failed => (
            title: appLocalizations.connectFailedTitle,
            subtitle: appLocalizations.connectFailedHint,
          ),
        _Phase.noSubscription => (
            title: appLocalizations.connectNotProtected,
            subtitle: appLocalizations.connectGetPlanHint,
          ),
        _Phase.guest => (
            title: appLocalizations.connectNotProtected,
            subtitle: appLocalizations.connectGetPlanHint,
          ),
      };

  @override
  Widget build(BuildContext context) {
    final labels = _labels;
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const SizedBox(height: 16),
        _Orb(
          connected: _connected,
          busy: phase == _Phase.provisioning,
          onTap: _canTap ? onToggle : null,
        ),
        const SizedBox(height: 44),
        Text(
          labels.title,
          textAlign: TextAlign.center,
          style: const TextStyle(color: AppTokens.text, fontSize: 22, fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 6),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32),
          child: Text(
            labels.subtitle,
            textAlign: TextAlign.center,
            style: const TextStyle(color: AppTokens.muted, fontSize: 14),
          ),
        ),
        const SizedBox(height: 28),
        ..._ctas(context),
        const SizedBox(height: 32),
      ],
    );
  }

  List<Widget> _ctas(BuildContext context) {
    Widget pad(List<Widget> kids) => Padding(
          padding: const EdgeInsets.symmetric(horizontal: 35),
          child: Column(children: kids),
        );

    switch (phase) {
      case _Phase.guest:
      case _Phase.noSubscription:
        return [
          pad([
            if (trialEligible) ...[
              RPrimaryButton(label: appLocalizations.startFreeTrial, onPressed: onClaimTrial),
              const SizedBox(height: 12),
            ],
            RSecondaryButton(label: appLocalizations.viewPlans, onPressed: onViewPlans),
          ]),
        ];
      case _Phase.expired:
        return [
          pad([
            RPrimaryButton(label: appLocalizations.renew, onPressed: onViewPlans),
            const SizedBox(height: 12),
            RSecondaryButton(label: appLocalizations.choosePlan, onPressed: onViewPlans),
          ]),
        ];
      case _Phase.failed:
        return [
          pad([
            RPrimaryButton(label: appLocalizations.retry, onPressed: onRetry),
          ]),
        ];
      case _Phase.disconnected:
      case _Phase.connected:
        return [
          const _ServerChip(),
          if (sub != null) ...[const SizedBox(height: 18), _Glance(sub: sub!)],
        ];
      case _Phase.provisioning:
        return const [];
    }
  }
}

class _Orb extends StatelessWidget {
  const _Orb({required this.connected, required this.busy, this.onTap});

  final bool connected;
  final bool busy;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final ring = connected ? AppTokens.accent : AppTokens.border;
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        width: 224,
        height: 224,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: connected ? AppTokens.accentTint : AppTokens.surface,
          border: Border.all(color: ring, width: 2),
          boxShadow: connected
              ? [BoxShadow(color: AppTokens.accent.withValues(alpha: 0.25), blurRadius: 40, spreadRadius: 4)]
              : null,
        ),
        child: Icon(
          Icons.shield,
          size: 88,
          color: connected ? AppTokens.accent : AppTokens.muted,
        ),
      ),
    );
  }
}

/// The current-server selector on the Connect screen (design parity): shows the
/// active group's selected node + its latency, and taps through to the Servers
/// tab. Mirrors the legacy `ChangeServerButton`: it prefers the group named by
/// the subscription's `flclashx-serverinfo` header, then the first user
/// Selector, then any group. Falls back to a generic "Choose server" entry when
/// no node is selected yet.
class _ServerChip extends ConsumerWidget {
  const _ServerChip();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Same filter as the Servers list: ignore mihomo's built-in GLOBAL selector
    // (its `now` is DIRECT/REJECT) so the chip reflects the real location group.
    final groups = ref
        .watch(groupsProvider)
        .where((g) => g.hidden != true && g.name != 'GLOBAL')
        .toList();
    if (groups.isEmpty) return const SizedBox.shrink();

    final profile = ref.watch(currentProfileProvider);
    final group = _pickGroup(groups, profile);
    final current = group?.now ?? '';

    void open() => ref.read(shellTabProvider.notifier).state = 1;

    if (group == null || current.isEmpty) {
      return _Pill(
        onTap: open,
        leading: const Icon(Icons.public, size: 15, color: AppTokens.accent),
        label: appLocalizations.chooseServer,
      );
    }

    final delay = ref.watch(getDelayProvider(proxyName: current));
    final flag = leadingFlag(current);
    final (delayText, delayColor) = switch (delay) {
      null => (null, AppTokens.muted),
      <= 0 => ('timeout', AppTokens.muted),
      < 80 => ('$delay ms', AppTokens.accent),
      < 150 => ('$delay ms', AppTokens.amber),
      _ => ('$delay ms', AppTokens.muted),
    };

    return _Pill(
      onTap: open,
      leading: flag != null
          ? Text(flag, style: const TextStyle(fontSize: 15))
          : const Icon(Icons.public, size: 15, color: AppTokens.accent),
      label: stripFlag(current),
      trailing: delayText == null
          ? null
          : Text('· $delayText', style: TextStyle(color: delayColor, fontSize: 13)),
    );
  }

  Group? _pickGroup(List<Group> groups, Profile? profile) {
    final wanted = _decodeBase64IfNeeded(profile?.providerHeaders['flclashx-serverinfo']);
    if (wanted != null && wanted.isNotEmpty) {
      final g = groups.getGroup(wanted);
      if (g != null) return g;
    }
    for (final g in groups) {
      if (g.type == GroupType.Selector) return g;
    }
    return groups.isNotEmpty ? groups.first : null;
  }

  String? _decodeBase64IfNeeded(String? value) {
    if (value == null || value.isEmpty) return value;
    try {
      return utf8.decode(base64.decode(value));
    } catch (_) {
      return value;
    }
  }
}

/// The rounded pill used by [_ServerChip].
class _Pill extends StatelessWidget {
  const _Pill({required this.onTap, required this.leading, required this.label, this.trailing});

  final VoidCallback onTap;
  final Widget leading;
  final String label;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) => Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(AppTokens.rPill),
          onTap: onTap,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 9),
            decoration: BoxDecoration(
              color: AppTokens.surface,
              borderRadius: BorderRadius.circular(AppTokens.rPill),
              border: Border.all(color: AppTokens.border),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                leading,
                const SizedBox(width: 8),
                Flexible(
                  child: Text(
                    label,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(color: AppTokens.text, fontSize: 14, fontWeight: FontWeight.w600),
                  ),
                ),
                if (trailing != null) ...[const SizedBox(width: 8), trailing!],
                const SizedBox(width: 6),
                const Icon(Icons.unfold_more, size: 16, color: AppTokens.muted),
              ],
            ),
          ),
        ),
      );
}

class _Glance extends StatelessWidget {
  const _Glance({required this.sub});

  final Subscription sub;

  @override
  Widget build(BuildContext context) {
    final used = formatBytes(sub.usedTrafficBytes);
    final limit = sub.isUnlimited ? '∞' : formatBytes(sub.trafficLimitBytes);
    final expires = sub.expiresAt;
    final daysLeft = expires == null ? '—' : '${expires.difference(DateTime.now()).inDays}d';
    return Padding(
      padding: const EdgeInsets.only(top: 8),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _stat('$used / $limit', appLocalizations.traffic),
          const SizedBox(width: 40),
          _stat(daysLeft, appLocalizations.connectExpiresLabel),
        ],
      ),
    );
  }

  Widget _stat(String value, String label) => Column(
        children: [
          Text(value, style: const TextStyle(color: AppTokens.text, fontSize: 16, fontWeight: FontWeight.w600)),
          const SizedBox(height: 2),
          Text(label, style: const TextStyle(color: AppTokens.muted, fontSize: 11)),
        ],
      );
}
