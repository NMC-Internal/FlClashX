import 'dart:async';

import 'package:flclashx/common/app_localizations.dart';
import 'package:flclashx/design/tokens.dart';
import 'package:flclashx/models/models.dart';
import 'package:flclashx/pages/auth/auth_state.dart';
import 'package:flclashx/views/redesign/auth_sheet.dart';
import 'package:flclashx/views/redesign/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:forui/forui.dart';

/// The public plan catalog (`/v1/plans`). A pushed screen reached from the
/// Connect/Account CTAs. The trial card is gated on [Me.trialEligible]; paid
/// checkout is out of scope (ADR 0013 decision) — the cards inform, billing is
/// not active.
class RPlansView extends ConsumerWidget {
  const RPlansView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final plansAsync = ref.watch(plansProvider);
    final me = ref.watch(meProvider).valueOrNull;
    final trialEligible = me?.trialEligible ?? true;

    return Scaffold(
      backgroundColor: AppTokens.bg,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(8, 8, 20, 0),
              child: Row(
                children: [
                  IconButton(
                    onPressed: () => Navigator.of(context).maybePop(),
                    icon: const Icon(Icons.arrow_back, color: AppTokens.text),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 4, 20, 4),
              child: Text(appLocalizations.chooseAPlan,
                  style: const TextStyle(color: AppTokens.text, fontSize: 26, fontWeight: FontWeight.w700)),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 8),
              child: Text(appLocalizations.plansSubtitle,
                  style: const TextStyle(color: AppTokens.muted, fontSize: 14)),
            ),
            Expanded(
              child: plansAsync.when(
                loading: () => const Center(child: CircularProgressIndicator(color: AppTokens.accent)),
                error: (_, __) => Center(
                  child: TextButton(
                    onPressed: () => ref.invalidate(plansProvider),
                    child: Text(appLocalizations.plansLoadError,
                        style: const TextStyle(color: AppTokens.muted)),
                  ),
                ),
                data: (plans) {
                  final visible = plans.where((p) => !p.isTrial || trialEligible).toList();
                  return ListView(
                    padding: const EdgeInsets.fromLTRB(20, 12, 20, 28),
                    children: [
                      for (final p in visible) ...[
                        _PlanCard(plan: p),
                        const SizedBox(height: 16),
                      ],
                      Text(
                        appLocalizations.plansBillingNote,
                        textAlign: TextAlign.center,
                        style: const TextStyle(color: AppTokens.muted, fontSize: 12),
                      ),
                    ],
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _PlanCard extends ConsumerWidget {
  const _PlanCard({required this.plan});

  final Plan plan;

  String get _price {
    if (plan.priceCents == 0) return appLocalizations.planFree;
    final dollars = plan.priceCents / 100;
    final str = dollars == dollars.roundToDouble() ? dollars.toStringAsFixed(0) : dollars.toStringAsFixed(2);
    return '\$$str';
  }

  String get _period => switch (plan.durationDays) {
        7 => appLocalizations.planOneTime,
        30 => appLocalizations.planPerMonth,
        365 => appLocalizations.planPerYear,
        _ => '',
      };

  List<String> get _features => [
        appLocalizations.planDaysAccess(plan.durationDays),
        plan.isUnlimited
            ? appLocalizations.planUnlimitedTraffic
            : appLocalizations.planTrafficAmount(formatBytes(plan.trafficLimitBytes)),
        plan.deviceLimit == 1
            ? appLocalizations.planDevice(plan.deviceLimit)
            : appLocalizations.planDevices(plan.deviceLimit),
      ];

  Future<void> _onCta(BuildContext context, WidgetRef ref) async {
    if (plan.isTrial) {
      final ok = await showAuthSheet(context);
      if (ok && context.mounted) unawaited(Navigator.of(context).maybePop());
      return;
    }
    showFToast(context: context, title: Text(appLocalizations.billingNotActive));
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final highlighted = plan.isTrial;
    return Container(
      decoration: BoxDecoration(
        color: AppTokens.surface,
        borderRadius: BorderRadius.circular(AppTokens.rCard),
        border: Border.all(
          color: highlighted ? AppTokens.accent : AppTokens.border,
          width: highlighted ? 2 : 1,
        ),
      ),
      padding: const EdgeInsets.all(18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(plan.name,
                    style: const TextStyle(color: AppTokens.text, fontSize: 18, fontWeight: FontWeight.w700)),
              ),
              if (plan.isTrial) _Tag(appLocalizations.planOneTime),
              if (plan.durationDays == 365) _Tag(appLocalizations.planBestValue),
            ],
          ),
          const SizedBox(height: 14),
          for (final f in _features) ...[
            Row(
              children: [
                const Icon(Icons.check, size: 16, color: AppTokens.accent),
                const SizedBox(width: 8),
                Text(f, style: const TextStyle(color: AppTokens.text, fontSize: 14)),
              ],
            ),
            const SizedBox(height: 8),
          ],
          const SizedBox(height: 6),
          Row(
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            children: [
              Text(_price,
                  style: const TextStyle(color: AppTokens.text, fontSize: 26, fontWeight: FontWeight.w700)),
              const SizedBox(width: 4),
              Text(_period, style: const TextStyle(color: AppTokens.muted, fontSize: 14)),
            ],
          ),
          const SizedBox(height: 14),
          RPrimaryButton(
            label: plan.isTrial ? appLocalizations.startFreeTrial : appLocalizations.planChoose,
            onPressed: () => unawaited(_onCta(context, ref)),
          ),
        ],
      ),
    );
  }
}

class _Tag extends StatelessWidget {
  const _Tag(this.text);

  final String text;

  @override
  Widget build(BuildContext context) => Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
        decoration: BoxDecoration(
          color: AppTokens.accentTint,
          borderRadius: BorderRadius.circular(AppTokens.rPill),
        ),
        child: Text(text, style: const TextStyle(color: AppTokens.accent, fontSize: 12, fontWeight: FontWeight.w600)),
      );
}
