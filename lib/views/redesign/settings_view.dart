import 'package:flclashx/common/app_localizations.dart';
import 'package:flclashx/common/constant.dart';
import 'package:flclashx/core_version.dart';
import 'package:flclashx/design/tokens.dart';
import 'package:flclashx/providers/providers.dart';
import 'package:flclashx/state.dart';
import 'package:flclashx/views/about.dart';
import 'package:flclashx/views/config/config.dart';
import 'package:flclashx/views/redesign/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Settings: a flat list of sections. The App toggles are wired to
/// [appSettingProvider]; Connection and About push the existing (functional)
/// config/about views inside a themed wrapper. Restyling those sub-views and
/// honoring per-row flclashx-settings locks is a later polish step.
class RSettingsView extends ConsumerWidget {
  const RSettingsView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final autoLaunch = ref.watch(appSettingProvider.select((s) => s.autoLaunch));
    final minimizeOnExit = ref.watch(appSettingProvider.select((s) => s.minimizeOnExit));
    final openLogs = ref.watch(appSettingProvider.select((s) => s.openLogs));
    final override = ref.watch(appSettingProvider.select((s) => s.overrideProviderSettings));
    final locale = ref.watch(appSettingProvider.select((s) => s.locale));
    final notifier = ref.read(appSettingProvider.notifier);

    return Column(
      children: [
        RAppBar(appLocalizations.settings),
        Expanded(
          child: ListView(
            padding: const EdgeInsets.fromLTRB(20, 4, 20, 24),
            children: [
              RSectionLabel(appLocalizations.settingsAppearance),
              _Group(children: [
                _NavRow(
                  icon: Icons.language,
                  title: appLocalizations.language,
                  subtitle: _localeLabel(locale),
                  onTap: () => _showSheet(context, const _LanguageSheet()),
                ),
              ]),
              const SizedBox(height: 22),
              RSectionLabel(appLocalizations.settingsConnection),
              _Group(children: [
                _NavRow(
                  icon: Icons.tune,
                  title: appLocalizations.connectionSettings,
                  subtitle: appLocalizations.connectionSettingsSub,
                  onTap: () => _push(context, 'Connection', const ConfigView()),
                ),
              ]),
              const SizedBox(height: 22),
              RSectionLabel(appLocalizations.settingsApp),
              _Group(children: [
                _SwitchRow(
                  icon: Icons.rocket_launch_outlined,
                  title: appLocalizations.launchAtStartup,
                  value: autoLaunch,
                  onChanged: (v) => notifier.updateState((s) => s.copyWith(autoLaunch: v)),
                ),
                const _Divider(),
                _SwitchRow(
                  icon: Icons.minimize,
                  title: appLocalizations.minimizeOnExit,
                  value: minimizeOnExit,
                  onChanged: (v) => notifier.updateState((s) => s.copyWith(minimizeOnExit: v)),
                ),
                const _Divider(),
                _SwitchRow(
                  icon: Icons.article_outlined,
                  title: appLocalizations.enableLogs,
                  value: openLogs,
                  onChanged: (v) => notifier.updateState((s) => s.copyWith(openLogs: v)),
                ),
                const _Divider(),
                _SwitchRow(
                  icon: Icons.edit_outlined,
                  title: appLocalizations.overrideProviderSettingsFull,
                  value: override,
                  onChanged: (v) => notifier.updateState((s) => s.copyWith(overrideProviderSettings: v)),
                ),
              ]),
              const SizedBox(height: 22),
              RSectionLabel(appLocalizations.about),
              _Group(children: [
                _NavRow(
                  icon: Icons.shield_outlined,
                  title: appLocalizations.aboutApp(appName),
                  subtitle: 'v${globalState.packageInfo.version} · core $kCoreVersionFromSource',
                  onTap: () => _push(context, 'About', const AboutView()),
                ),
              ]),
            ],
          ),
        ),
      ],
    );
  }

  String _localeLabel(String? code) => switch (code) {
        null || '' => appLocalizations.langSystem,
        'en' => 'English',
        'ru' => 'Русский',
        'zh_CN' || 'zh' => '简体中文',
        'ja' => '日本語',
        _ => code,
      };

  void _showSheet(BuildContext context, Widget sheet) {
    showModalBottomSheet<void>(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (_) => sheet,
    );
  }

  void _push(BuildContext context, String title, Widget child) {
    Navigator.of(context).push(
      MaterialPageRoute<void>(builder: (_) => _SubScreen(title: title, child: child)),
    );
  }
}

/// Themed wrapper hosting an existing (Material) settings sub-view as a route.
class _SubScreen extends StatelessWidget {
  const _SubScreen({required this.title, required this.child});

  final String title;
  final Widget child;

  @override
  Widget build(BuildContext context) => Scaffold(
        backgroundColor: AppTokens.bg,
        appBar: AppBar(
          backgroundColor: AppTokens.bg,
          foregroundColor: AppTokens.text,
          elevation: 0,
          title: Text(title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
        ),
        body: SafeArea(child: child),
      );
}

class _Group extends StatelessWidget {
  const _Group({required this.children});

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

class _Divider extends StatelessWidget {
  const _Divider();

  @override
  Widget build(BuildContext context) =>
      const Divider(height: 1, thickness: 1, color: AppTokens.border, indent: 14, endIndent: 14);
}

class _NavRow extends StatelessWidget {
  const _NavRow({required this.icon, required this.title, required this.subtitle, required this.onTap});

  final IconData icon;
  final String title;
  final String subtitle;
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
                    const SizedBox(height: 2),
                    Text(subtitle, style: const TextStyle(color: AppTokens.muted, fontSize: 13)),
                  ],
                ),
              ),
              const Icon(Icons.chevron_right, color: AppTokens.muted, size: 18),
            ],
          ),
        ),
      );
}

/// A bottom-sheet shell matching the auth sheet (dark, rounded top, drag handle).
class _SheetShell extends StatelessWidget {
  const _SheetShell({required this.title, required this.children});

  final String title;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) => Container(
        decoration: const BoxDecoration(
          color: AppTokens.bg,
          border: Border(top: BorderSide(color: AppTokens.border)),
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        padding: const EdgeInsets.fromLTRB(20, 12, 20, 12),
        child: SafeArea(
          top: false,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: AppTokens.secondaryBorder,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Text(title, style: const TextStyle(color: AppTokens.text, fontSize: 18, fontWeight: FontWeight.w700)),
              const SizedBox(height: 8),
              ...children,
              const SizedBox(height: 12),
            ],
          ),
        ),
      );
}

/// A selectable option row inside a picker sheet.
class _OptionRow extends StatelessWidget {
  const _OptionRow({required this.label, required this.selected, required this.onTap});

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) => InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppTokens.rField),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 14),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  label,
                  style: TextStyle(
                    color: selected ? AppTokens.accent : AppTokens.text,
                    fontSize: 15,
                    fontWeight: selected ? FontWeight.w600 : FontWeight.w400,
                  ),
                ),
              ),
              if (selected) const Icon(Icons.check, color: AppTokens.accent, size: 18),
            ],
          ),
        ),
      );
}

/// Language picker. "System" follows the OS locale (clears the override).
class _LanguageSheet extends ConsumerWidget {
  const _LanguageSheet();

  static const _langs = <(String?, String)>[
    (null, 'System'),
    ('en', 'English'),
    ('ru', 'Русский'),
    ('zh_CN', '简体中文'),
    ('ja', '日本語'),
  ];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final current = ref.watch(appSettingProvider.select((s) => s.locale));
    final notifier = ref.read(appSettingProvider.notifier);
    return _SheetShell(
      title: appLocalizations.language,
      children: [
        for (final (code, label) in _langs)
          _OptionRow(
            label: label,
            selected: (current ?? '') == (code ?? ''),
            onTap: () {
              notifier.updateState((s) => s.copyWith(locale: code));
              Navigator.of(context).maybePop();
            },
          ),
      ],
    );
  }
}

class _SwitchRow extends StatelessWidget {
  const _SwitchRow({required this.icon, required this.title, required this.value, required this.onChanged});

  final IconData icon;
  final String title;
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
              child: Text(title, style: const TextStyle(color: AppTokens.text, fontSize: 15)),
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
