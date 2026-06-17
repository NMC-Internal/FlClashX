import 'package:flclashx/design/tokens.dart';
import 'package:flutter/material.dart';

/// Shared building blocks for the redesigned UI, all styled from [AppTokens].

/// A small uppercase section label (e.g. "APPEARANCE").
class RSectionLabel extends StatelessWidget {
  const RSectionLabel(this.text, {super.key});

  final String text;

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.only(left: 4, bottom: 10),
        child: Text(
          text.toUpperCase(),
          style: const TextStyle(
            color: AppTokens.muted,
            fontSize: 11,
            fontWeight: FontWeight.w500,
            letterSpacing: 0.6,
          ),
        ),
      );
}

/// An elevated surface card (radius 16, surface fill, hairline border).
class RCard extends StatelessWidget {
  const RCard({
    required this.child,
    this.padding = const EdgeInsets.all(18),
    this.onTap,
    super.key,
  });

  final Widget child;
  final EdgeInsetsGeometry padding;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final card = Container(
      decoration: BoxDecoration(
        color: AppTokens.surface,
        borderRadius: BorderRadius.circular(AppTokens.rCard),
        border: Border.all(color: AppTokens.border),
      ),
      padding: padding,
      child: child,
    );
    if (onTap == null) return card;
    return Material(
      color: Colors.transparent,
      borderRadius: BorderRadius.circular(AppTokens.rCard),
      child: InkWell(
        borderRadius: BorderRadius.circular(AppTokens.rCard),
        onTap: onTap,
        child: card,
      ),
    );
  }
}

/// Filled accent button (primary CTA).
class RPrimaryButton extends StatelessWidget {
  const RPrimaryButton({
    required this.label,
    required this.onPressed,
    this.icon,
    super.key,
  });

  final String label;
  final IconData? icon;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) => SizedBox(
        width: double.infinity,
        height: 52,
        child: FilledButton(
          onPressed: onPressed,
          style: FilledButton.styleFrom(
            backgroundColor: AppTokens.accent,
            foregroundColor: AppTokens.onAccent,
            disabledBackgroundColor: AppTokens.accent.withValues(alpha: 0.4),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(AppTokens.rButton),
            ),
            textStyle: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              if (icon != null) ...[Icon(icon, size: 18), const SizedBox(width: 8)],
              Text(label),
            ],
          ),
        ),
      );
}

/// Outlined (secondary) button. Set [destructive] for a red log-out/delete look.
class RSecondaryButton extends StatelessWidget {
  const RSecondaryButton({
    required this.label,
    required this.onPressed,
    this.destructive = false,
    super.key,
  });

  final String label;
  final VoidCallback? onPressed;
  final bool destructive;

  @override
  Widget build(BuildContext context) {
    final fg = destructive ? AppTokens.danger : AppTokens.text;
    final side = destructive
        ? AppTokens.danger.withValues(alpha: 0.5)
        : AppTokens.secondaryBorder;
    return SizedBox(
      width: double.infinity,
      height: 52,
      child: OutlinedButton(
        onPressed: onPressed,
        style: OutlinedButton.styleFrom(
          foregroundColor: fg,
          side: BorderSide(color: side, width: 1.5),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppTokens.rButton),
          ),
          textStyle: const TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
        ),
        child: Text(label),
      ),
    );
  }
}

/// A grouped settings card: a rounded surface holding a column of rows
/// ([RNavRow] / [RSwitchRow]) separated by [RGroupDivider].
class RGroup extends StatelessWidget {
  const RGroup({required this.children, super.key});

  final List<Widget> children;

  @override
  Widget build(BuildContext context) => Container(
        decoration: BoxDecoration(
          color: AppTokens.surface,
          borderRadius: BorderRadius.circular(AppTokens.rCard),
          border: Border.all(color: AppTokens.border),
        ),
        clipBehavior: Clip.antiAlias,
        child: Column(children: children),
      );
}

/// Hairline divider between rows inside an [RGroup].
class RGroupDivider extends StatelessWidget {
  const RGroupDivider({super.key});

  @override
  Widget build(BuildContext context) => const Divider(
        height: 1,
        thickness: 1,
        color: AppTokens.border,
        indent: 14,
        endIndent: 14,
      );
}

/// A settings row that navigates or runs an action: leading icon, title, optional
/// subtitle, and a trailing widget (defaults to a chevron).
class RNavRow extends StatelessWidget {
  const RNavRow({
    required this.icon,
    required this.title,
    required this.onTap,
    this.subtitle,
    this.trailing,
    super.key,
  });

  final IconData icon;
  final String title;
  final String? subtitle;
  final Widget? trailing;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) => InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
          child: Row(
            children: [
              Icon(icon, color: AppTokens.muted, size: 20),
              const SizedBox(width: 13),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title, style: const TextStyle(color: AppTokens.text, fontSize: 15)),
                    if (subtitle != null) ...[
                      const SizedBox(height: 2),
                      Text(subtitle!, style: const TextStyle(color: AppTokens.muted, fontSize: 13)),
                    ],
                  ],
                ),
              ),
              trailing ?? const Icon(Icons.chevron_right, color: AppTokens.muted, size: 18),
            ],
          ),
        ),
      );
}

/// A settings toggle row: leading icon, title, optional subtitle, trailing switch.
class RSwitchRow extends StatelessWidget {
  const RSwitchRow({
    required this.icon,
    required this.title,
    required this.value,
    required this.onChanged,
    this.subtitle,
    super.key,
  });

  final IconData icon;
  final String title;
  final String? subtitle;
  final bool value;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
        child: Row(
          children: [
            Icon(icon, color: AppTokens.muted, size: 20),
            const SizedBox(width: 13),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: const TextStyle(color: AppTokens.text, fontSize: 15)),
                  if (subtitle != null) ...[
                    const SizedBox(height: 2),
                    Text(subtitle!, style: const TextStyle(color: AppTokens.muted, fontSize: 13)),
                  ],
                ],
              ),
            ),
            Switch(
              value: value,
              onChanged: onChanged,
              activeTrackColor: AppTokens.accent,
              activeThumbColor: AppTokens.onAccent,
            ),
          ],
        ),
      );
}

/// A plain screen app-bar title row (left-aligned, 22 semibold) with optional
/// trailing widget. The shell already insets for device/window chrome
/// (SafeArea on mobile, the header band on Win/Linux, a popover on macOS), so
/// this only adds a small in-content top margin.
class RAppBar extends StatelessWidget {
  const RAppBar(this.title, {this.trailing, super.key});

  final String title;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.fromLTRB(20, 16, 20, 8),
        child: Row(
          children: [
            Expanded(
              child: Text(
                title,
                style: const TextStyle(
                  color: AppTokens.text,
                  fontSize: 22,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            if (trailing != null) trailing!,
          ],
        ),
      );
}

/// Returns the leading flag emoji (two regional-indicator code points) of [name],
/// or null when the name doesn't start with one. Subscription proxy names often
/// carry one, e.g. "🇱🇹 Lithuania".
String? leadingFlag(String name) {
  final r = name.runes.toList();
  if (r.length >= 2 &&
      r[0] >= 0x1F1E6 &&
      r[0] <= 0x1F1FF &&
      r[1] >= 0x1F1E6 &&
      r[1] <= 0x1F1FF) {
    return String.fromCharCodes([r[0], r[1]]);
  }
  return null;
}

/// [name] with any leading flag emoji removed (for a cleaner label).
String stripFlag(String name) {
  final flag = leadingFlag(name);
  return flag == null ? name : name.substring(flag.length).trim();
}

/// Formats a date as a compact "MMM d" (e.g. "Jun 22").
String formatShortDate(DateTime d) {
  const months = [
    'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
    'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec',
  ];
  return '${months[d.month - 1]} ${d.day}';
}

/// Formats a byte count as a compact human string (e.g. "4.2 GB").
String formatBytes(int bytes) {
  if (bytes <= 0) return '0 B';
  const units = ['B', 'KB', 'MB', 'GB', 'TB'];
  var size = bytes.toDouble();
  var unit = 0;
  while (size >= 1024 && unit < units.length - 1) {
    size /= 1024;
    unit++;
  }
  final str = size >= 100 || unit == 0 ? size.toStringAsFixed(0) : size.toStringAsFixed(1);
  return '$str ${units[unit]}';
}
