import 'package:flclashx/common/common.dart';
import 'package:flclashx/design/tokens.dart';
import 'package:flclashx/models/models.dart';
import 'package:flclashx/providers/providers.dart';
import 'package:flclashx/views/redesign/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Activity: live throughput and the current session from the engine providers
/// ([trafficsProvider], [totalTrafficProvider], [runTimeProvider]). Per ADR 0013
/// there is intentionally NO per-connection list (privacy). The weekly usage
/// chart is aggregate sample data — there is no per-day history source yet.
class RActivityView extends ConsumerWidget {
  const RActivityView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) => Column(
        children: [
          RAppBar(appLocalizations.navActivity),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.fromLTRB(20, 4, 20, 24),
              children: [
                const _ThroughputCard(),
                const SizedBox(height: 16),
                const _SessionCard(),
                const SizedBox(height: 20),
                RSectionLabel(appLocalizations.activityUsageWeek),
                const _UsageCard(),
              ],
            ),
          ),
        ],
      );
}

class _ThroughputCard extends ConsumerWidget {
  const _ThroughputCard();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final traffics = ref.watch(trafficsProvider).list;
    final last = traffics.isEmpty ? null : traffics.last;
    final connected = ref.watch(runTimeProvider.select((s) => s != null));
    return RCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              RSectionLabel(appLocalizations.activityThroughput),
              const Spacer(),
              if (connected) const _LiveDot(),
            ],
          ),
          Row(
            children: [
              Expanded(child: _Speed(icon: Icons.south, value: last?.down.show ?? '0 B', accent: true)),
              Expanded(child: _Speed(icon: Icons.north, value: last?.up.show ?? '0 B', accent: false)),
            ],
          ),
          const SizedBox(height: 12),
          SizedBox(
            height: 36,
            child: CustomPaint(
              painter: _SparkPainter(traffics),
              size: const Size(double.infinity, 36),
            ),
          ),
        ],
      ),
    );
  }
}

class _LiveDot extends StatelessWidget {
  const _LiveDot();

  @override
  Widget build(BuildContext context) => Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const _Dot(color: AppTokens.accent, size: 7),
          const SizedBox(width: 6),
          Text(appLocalizations.activityLive,
              style: const TextStyle(color: AppTokens.muted, fontSize: 11, fontWeight: FontWeight.w500)),
        ],
      );
}

class _Speed extends StatelessWidget {
  const _Speed({required this.icon, required this.value, required this.accent});

  final IconData icon;
  final String value;
  final bool accent;

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.only(top: 4),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Icon(icon, size: 20, color: accent ? AppTokens.accent : AppTokens.muted),
            const SizedBox(width: 4),
            Flexible(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('$value/s',
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(color: AppTokens.text, fontSize: 20, fontWeight: FontWeight.w600)),
                  Text(accent ? appLocalizations.download : appLocalizations.upload,
                      style: const TextStyle(color: AppTokens.muted, fontSize: 11)),
                ],
              ),
            ),
          ],
        ),
      );
}

class _SparkPainter extends CustomPainter {
  _SparkPainter(this.traffics);

  final List<Traffic> traffics;

  @override
  void paint(Canvas canvas, Size size) {
    final pts = traffics.length < 2
        ? const <double>[0, 0]
        : traffics.map((t) => t.speed.toDouble()).toList();
    final maxV = pts.fold<double>(1, (m, v) => v > m ? v : m);
    final path = Path();
    final dx = size.width / (pts.length - 1);
    for (var i = 0; i < pts.length; i++) {
      final x = dx * i;
      final y = size.height - (pts[i] / maxV) * (size.height - 2) - 1;
      if (i == 0) {
        path.moveTo(x, y);
      } else {
        path.lineTo(x, y);
      }
    }
    final stroke = Paint()
      ..color = AppTokens.accent
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke
      ..strokeJoin = StrokeJoin.round
      ..strokeCap = StrokeCap.round;
    canvas.drawPath(path, stroke);
  }

  @override
  bool shouldRepaint(covariant _SparkPainter oldDelegate) =>
      oldDelegate.traffics != traffics;
}

class _SessionCard extends ConsumerWidget {
  const _SessionCard();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final runTime = ref.watch(runTimeProvider);
    final total = ref.watch(totalTrafficProvider);
    final duration = runTime != null ? utils.getTimeText(runTime) : '—';
    return RCard(
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 18),
      child: Row(
        children: [
          Expanded(child: _Stat(value: duration, label: appLocalizations.activityDuration)),
          const _VDiv(),
          Expanded(child: _Stat(value: total.down.show, label: appLocalizations.activityDownloaded)),
          const _VDiv(),
          Expanded(child: _Stat(value: total.up.show, label: appLocalizations.activityUploaded)),
        ],
      ),
    );
  }
}

class _Stat extends StatelessWidget {
  const _Stat({required this.value, required this.label});

  final String value;
  final String label;

  @override
  Widget build(BuildContext context) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(value,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(color: AppTokens.text, fontSize: 18, fontWeight: FontWeight.w600)),
          const SizedBox(height: 2),
          Text(label, style: const TextStyle(color: AppTokens.muted, fontSize: 11)),
        ],
      );
}

class _VDiv extends StatelessWidget {
  const _VDiv();

  @override
  Widget build(BuildContext context) =>
      Container(width: 1, height: 42, color: AppTokens.border, margin: const EdgeInsets.symmetric(horizontal: 12));
}

class _UsageCard extends StatelessWidget {
  const _UsageCard();

  static const _data = [1.2, 2.1, 0.8, 3.4, 2.6, 1.1, 1.2];
  static const _days = ['M', 'T', 'W', 'T', 'F', 'S', 'S'];

  @override
  Widget build(BuildContext context) {
    final maxV = _data.reduce((a, b) => a > b ? a : b);
    final peak = _data.indexOf(maxV);
    return RCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(appLocalizations.activityDailyTraffic,
                  style: const TextStyle(color: AppTokens.text, fontSize: 14, fontWeight: FontWeight.w600)),
              const Spacer(),
              Text(appLocalizations.activityDemo, style: const TextStyle(color: AppTokens.muted, fontSize: 12)),
            ],
          ),
          const SizedBox(height: 18),
          SizedBox(
            height: 130,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                for (var i = 0; i < _data.length; i++)
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Container(
                          height: 14 + (_data[i] / maxV) * 86,
                          margin: const EdgeInsets.symmetric(horizontal: 6),
                          decoration: BoxDecoration(
                            color: i == peak ? AppTokens.accent : AppTokens.accent.withValues(alpha: 0.5),
                            borderRadius: BorderRadius.circular(6),
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(_days[i], style: const TextStyle(color: AppTokens.muted, fontSize: 11)),
                      ],
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _Dot extends StatelessWidget {
  const _Dot({required this.color, required this.size});

  final Color color;
  final double size;

  @override
  Widget build(BuildContext context) =>
      Container(width: size, height: size, decoration: BoxDecoration(color: color, shape: BoxShape.circle));
}
