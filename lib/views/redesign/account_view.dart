import 'package:flclashx/common/common.dart';
import 'package:flclashx/design/tokens.dart';
import 'package:flclashx/models/models.dart';
import 'package:flclashx/pages/auth/auth_state.dart';
import 'package:flclashx/state.dart';
import 'package:flclashx/views/redesign/auth_sheet.dart';
import 'package:flclashx/views/redesign/plans_view.dart';
import 'package:flclashx/views/redesign/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:url_launcher/url_launcher.dart';

/// Account: identity, the active subscription (traffic donut + expiry),
/// subscription history, link Telegram, and logout. Backed by [meProvider]
/// (`/v1/me` v2).
class RAccountView extends ConsumerWidget {
  const RAccountView({super.key});

  /// Starts Telegram linking (ADR 0018): asks the backend for a one-time code +
  /// deep link, then opens the bot so the user attaches Telegram. After linking,
  /// what they buy via the bot shows up here (adopt-on-/me, on the next refresh).
  Future<void> _linkTelegram(WidgetRef ref) async {
    final token = ref.read(authTokenProvider);
    if (token == null || token.isEmpty) return;
    try {
      final init = await authApi.linkInitTelegram(token);
      if (init.deepLink.isNotEmpty) {
        await launchUrl(Uri.parse(init.deepLink), mode: LaunchMode.externalApplication);
        return;
      }
      if (init.code.isNotEmpty) {
        await globalState.showMessage(
          title: appLocalizations.linkTelegram,
          message: TextSpan(text: appLocalizations.linkTelegramCode(init.code)),
        );
      }
    } on AuthException catch (e) {
      await globalState.showMessage(
        title: appLocalizations.linkTelegram,
        message: TextSpan(text: e.message),
      );
    }
  }

  Future<void> _logout(WidgetRef ref) async {
    final res = await globalState.showMessage(
      title: appLocalizations.logout,
      message: TextSpan(text: appLocalizations.logoutConfirm),
    );
    if (res != true) return;
    await globalState.appController.clearProfiles();
    await preferences.clearAuthToken();
    await preferences.clearUserEmail();
    ref.read(pendingSubscriptionUrlProvider.notifier).state = null;
    ref.read(authTokenProvider.notifier).state = null;
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final token = ref.watch(authTokenProvider);
    final meAsync = ref.watch(meProvider);

    Widget content;
    if (token == null || token.isEmpty) {
      content = const _GuestAccount();
    } else {
      content = meAsync.when(
        loading: () => const Center(child: CircularProgressIndicator(color: AppTokens.accent)),
        error: (_, __) => const _AccountError(),
        data: (me) => _AccountBody(
          me: me ?? const Me(),
          onLinkTelegram: () => _linkTelegram(ref),
          onLogout: () => _logout(ref),
        ),
      );
    }

    return Column(
      children: [
        RAppBar(appLocalizations.account),
        Expanded(child: content),
      ],
    );
  }
}

class _AccountBody extends StatelessWidget {
  const _AccountBody({required this.me, required this.onLinkTelegram, required this.onLogout});

  final Me me;
  final VoidCallback onLinkTelegram;
  final VoidCallback onLogout;

  @override
  Widget build(BuildContext context) {
    final sub = me.activeSubscription;
    final history = me.subscriptions.where((s) => !s.active).toList();
    return ListView(
      padding: const EdgeInsets.fromLTRB(20, 4, 20, 24),
      children: [
        _Identity(email: me.email),
        const SizedBox(height: 16),
        if (sub != null) _SubCard(sub: sub) else const _NoSubCard(),
        if (history.isNotEmpty) ...[
          const SizedBox(height: 20),
          RSectionLabel(appLocalizations.subscriptionHistory),
          for (final s in history) _HistoryRow(sub: s),
        ],
        const SizedBox(height: 20),
        RSecondaryButton(label: appLocalizations.linkTelegram, onPressed: onLinkTelegram),
        const SizedBox(height: 12),
        RSecondaryButton(label: appLocalizations.logout, onPressed: onLogout, destructive: true),
      ],
    );
  }
}

class _Identity extends StatelessWidget {
  const _Identity({required this.email});

  final String email;

  @override
  Widget build(BuildContext context) {
    final initials = email.isNotEmpty ? email.substring(0, email.length >= 2 ? 2 : 1).toUpperCase() : '?';
    return Row(
      children: [
        Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            color: AppTokens.surface,
            shape: BoxShape.circle,
            border: Border.all(color: AppTokens.border),
          ),
          alignment: Alignment.center,
          child: Text(initials, style: const TextStyle(color: AppTokens.accent, fontWeight: FontWeight.w600)),
        ),
        const SizedBox(width: 14),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(email, style: const TextStyle(color: AppTokens.text, fontSize: 15), overflow: TextOverflow.ellipsis),
              const SizedBox(height: 2),
              Text(appLocalizations.accountSignedIn, style: const TextStyle(color: AppTokens.muted, fontSize: 13)),
            ],
          ),
        ),
      ],
    );
  }
}

class _SubCard extends StatelessWidget {
  const _SubCard({required this.sub});

  final Subscription sub;

  @override
  Widget build(BuildContext context) {
    final limit = sub.trafficLimitBytes;
    final ratio = (limit > 0) ? (sub.usedTrafficBytes / limit).clamp(0.0, 1.0) : 0.0;
    final used = formatBytes(sub.usedTrafficBytes);
    final limitStr = sub.isUnlimited ? '∞' : formatBytes(limit);
    final expires = sub.expiresAt;
    final expiresStr = expires == null
        ? '—'
        : appLocalizations.accountExpiresInDays(
            expires.difference(DateTime.now()).inDays, formatShortDate(expires));
    return RCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  _planTitle(sub.plan),
                  style: const TextStyle(color: AppTokens.text, fontSize: 16, fontWeight: FontWeight.w600),
                ),
              ),
              _StatusBadge(status: sub.status),
            ],
          ),
          const SizedBox(height: 20),
          Center(
            child: SizedBox(
              width: 140,
              height: 140,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  SizedBox(
                    width: 140,
                    height: 140,
                    child: CircularProgressIndicator(
                      value: sub.isUnlimited ? 1 : ratio,
                      strokeWidth: 10,
                      backgroundColor: AppTokens.border,
                      valueColor: AlwaysStoppedAnimation(
                        sub.isUnlimited ? AppTokens.accent : AppTokens.amber,
                      ),
                    ),
                  ),
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(used, style: const TextStyle(color: AppTokens.text, fontSize: 22, fontWeight: FontWeight.w600)),
                      Text(appLocalizations.accountOfLimit(limitStr), style: const TextStyle(color: AppTokens.muted, fontSize: 12)),
                    ],
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 18),
          Text(expiresStr, style: const TextStyle(color: AppTokens.muted, fontSize: 13)),
          const SizedBox(height: 16),
          RPrimaryButton(
            label: appLocalizations.upgradePlan,
            onPressed: () => Navigator.of(context).push(
              MaterialPageRoute<void>(builder: (_) => const RPlansView()),
            ),
          ),
        ],
      ),
    );
  }

  String _planTitle(String code) => switch (code) {
        'trial' => appLocalizations.planTrial,
        'monthly' => appLocalizations.planMonthly,
        'yearly' => appLocalizations.planYearly,
        _ => code.isEmpty
            ? appLocalizations.planGeneric
            : appLocalizations.planNamed('${code[0].toUpperCase()}${code.substring(1)}'),
      };
}

class _StatusBadge extends StatelessWidget {
  const _StatusBadge({required this.status});

  final String status;

  @override
  Widget build(BuildContext context) {
    final (label, color) = switch (status) {
      'active' => (appLocalizations.statusActive, AppTokens.accent),
      'provisioning' => (appLocalizations.statusProvisioning, AppTokens.amber),
      'failed' => (appLocalizations.statusFailed, AppTokens.amber),
      _ => (status, AppTokens.muted),
    };
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.16),
        borderRadius: BorderRadius.circular(AppTokens.rPill),
      ),
      child: Text(label, style: TextStyle(color: color, fontSize: 12, fontWeight: FontWeight.w600)),
    );
  }
}

class _HistoryRow extends StatelessWidget {
  const _HistoryRow({required this.sub});

  final Subscription sub;

  @override
  Widget build(BuildContext context) {
    final created = sub.createdAt.isEmpty ? null : DateTime.tryParse(sub.createdAt);
    final ended = sub.expiresAt;
    final range = (created != null && ended != null)
        ? '${formatShortDate(created)} – ${formatShortDate(ended)}'
        : created != null
            ? 'Since ${formatShortDate(created)}'
            : '';
    final status = sub.status.isEmpty
        ? ''
        : '${sub.status[0].toUpperCase()}${sub.status.substring(1)}';
    return Padding(
      padding: const EdgeInsets.only(top: 8),
      child: RCard(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    sub.plan.isEmpty ? appLocalizations.planGeneric : sub.plan,
                    style: const TextStyle(color: AppTokens.text, fontSize: 14),
                  ),
                  if (range.isNotEmpty) ...[
                    const SizedBox(height: 2),
                    Text(range, style: const TextStyle(color: AppTokens.muted, fontSize: 12)),
                  ],
                ],
              ),
            ),
            Text(status, style: const TextStyle(color: AppTokens.muted, fontSize: 13)),
          ],
        ),
      ),
    );
  }
}

class _NoSubCard extends StatelessWidget {
  const _NoSubCard();

  @override
  Widget build(BuildContext context) => RCard(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(appLocalizations.noActiveSubscription,
                style: const TextStyle(color: AppTokens.text, fontSize: 16, fontWeight: FontWeight.w600)),
            const SizedBox(height: 6),
            Text(appLocalizations.noSubHint,
                style: const TextStyle(color: AppTokens.muted, fontSize: 13)),
          ],
        ),
      );
}

class _GuestAccount extends StatelessWidget {
  const _GuestAccount();

  @override
  Widget build(BuildContext context) => Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 35),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.person_outline, color: AppTokens.muted, size: 56),
              const SizedBox(height: 16),
              Text(appLocalizations.notSignedIn,
                  style: const TextStyle(color: AppTokens.text, fontSize: 18, fontWeight: FontWeight.w600)),
              const SizedBox(height: 6),
              Text(appLocalizations.signInToManage,
                  textAlign: TextAlign.center, style: const TextStyle(color: AppTokens.muted, fontSize: 14)),
              const SizedBox(height: 24),
              RPrimaryButton(
                label: appLocalizations.signIn,
                onPressed: () => showAuthSheet(context),
              ),
            ],
          ),
        ),
      );
}

class _AccountError extends StatelessWidget {
  const _AccountError();

  @override
  Widget build(BuildContext context) => Center(
        child: Text(appLocalizations.accountLoadError, style: const TextStyle(color: AppTokens.muted)),
      );
}
