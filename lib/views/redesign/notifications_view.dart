import 'package:flclashx/common/app_localizations.dart';
import 'package:flclashx/design/tokens.dart';
import 'package:flutter/material.dart';

/// In-app notifications inbox (ADR 0013 / roadmap §7). Lifecycle messages —
/// subscription ending, trial reminder, feedback offer. The delivery backend
/// (scheduler/triggers/channel) is NOT built yet, so this renders mock content;
/// reached from the Connect bell.
class RNotificationsView extends StatelessWidget {
  const RNotificationsView({super.key});

  // Mock content — localized once wired to the notifications backend.
  static const _items = <_Notif>[
    _Notif(
      icon: Icons.access_time,
      color: AppTokens.amber,
      title: 'Plan ends in 3 days',
      body: 'Renew now to keep your traffic protected. Expires Jun 22.',
      time: '2h',
      cta: 'Renew',
      unread: true,
    ),
    _Notif(
      icon: Icons.play_circle_outline,
      color: AppTokens.accent,
      title: 'Your trial is waiting',
      body: "You've got 7 days of free VPN — tap Connect to start protecting your traffic.",
      time: '1d',
      cta: 'How it works',
      unread: true,
    ),
    _Notif(
      icon: Icons.card_giftcard,
      color: AppTokens.accent,
      title: 'Get 7 days free',
      body: 'Share quick feedback about Fantomask and we’ll add a week to your plan.',
      time: '3d',
      cta: 'Give feedback',
      unread: true,
    ),
    _Notif(
      icon: Icons.verified_user_outlined,
      color: AppTokens.muted,
      title: 'Welcome to Fantomask VPN',
      body: 'Your account is ready. Choose a plan to get started.',
      time: '5d',
    ),
  ];

  @override
  Widget build(BuildContext context) => Scaffold(
        backgroundColor: AppTokens.bg,
        body: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(8, 8, 20, 4),
                child: Row(
                  children: [
                    IconButton(
                      onPressed: () => Navigator.of(context).maybePop(),
                      icon: const Icon(Icons.arrow_back, color: AppTokens.text),
                    ),
                    Text(appLocalizations.notifications,
                        style: const TextStyle(color: AppTokens.text, fontSize: 20, fontWeight: FontWeight.w600)),
                    const Spacer(),
                    TextButton(
                      onPressed: () {},
                      child: Text(appLocalizations.markAllRead,
                          style: const TextStyle(color: AppTokens.accent, fontSize: 13, fontWeight: FontWeight.w500)),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: ListView(
                  padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
                  children: [
                    for (final n in _items) ...[
                      _NotifCard(notif: n),
                      const SizedBox(height: 12),
                    ],
                  ],
                ),
              ),
            ],
          ),
        ),
      );
}

class _Notif {
  const _Notif({
    required this.icon,
    required this.color,
    required this.title,
    required this.body,
    required this.time,
    this.cta,
    this.unread = false,
  });

  final IconData icon;
  final Color color;
  final String title;
  final String body;
  final String time;
  final String? cta;
  final bool unread;
}

class _NotifCard extends StatelessWidget {
  const _NotifCard({required this.notif});

  final _Notif notif;

  @override
  Widget build(BuildContext context) => Container(
        decoration: BoxDecoration(
          color: AppTokens.surface,
          borderRadius: BorderRadius.circular(AppTokens.rCard),
          border: Border.all(color: AppTokens.border),
        ),
        padding: const EdgeInsets.all(16),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: notif.color.withValues(alpha: 0.16),
                shape: BoxShape.circle,
              ),
              alignment: Alignment.center,
              child: Icon(notif.icon, color: notif.color, size: 20),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          notif.title,
                          style: TextStyle(
                            color: notif.unread ? AppTokens.text : AppTokens.muted,
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      Text(notif.time, style: const TextStyle(color: AppTokens.muted, fontSize: 12)),
                    ],
                  ),
                  const SizedBox(height: 5),
                  Text(notif.body,
                      style: const TextStyle(color: AppTokens.muted, fontSize: 13, height: 1.35)),
                  if (notif.cta != null) ...[
                    const SizedBox(height: 12),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                      decoration: BoxDecoration(
                        color: notif.color.withValues(alpha: 0.16),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Text(notif.cta!,
                          style: TextStyle(color: notif.color, fontSize: 13, fontWeight: FontWeight.w600)),
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      );
}
