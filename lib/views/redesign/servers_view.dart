import 'package:flclashx/clash/clash.dart';
import 'package:flclashx/design/tokens.dart';
import 'package:flclashx/models/models.dart';
import 'package:flclashx/providers/providers.dart';
import 'package:flclashx/state.dart';
import 'package:flclashx/views/redesign/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Servers: the outbound-mode segment (Rule/Global/Direct) plus the real proxy
/// groups with per-proxy latency and selection. Reuses the engine providers
/// ([groupsProvider], [getDelayProvider]) and `AppController.changeProxyDebounce`
/// — no new core logic.
class RServersView extends ConsumerStatefulWidget {
  const RServersView({super.key});

  @override
  ConsumerState<RServersView> createState() => _RServersViewState();
}

class _RServersViewState extends ConsumerState<RServersView> {
  String _query = '';

  @override
  Widget build(BuildContext context) {
    // Hide mihomo's built-in GLOBAL selector (DIRECT/REJECT/sub-groups) — this
    // screen is for picking a location, not routing internals. The outbound-mode
    // switch (Rule/Global/Direct) is intentionally not surfaced here either.
    final groups = ref
        .watch(groupsProvider)
        .where((g) => g.hidden != true && g.name != 'GLOBAL')
        .toList();

    return Column(
      children: [
        const RAppBar('Servers'),
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 8, 20, 8),
          child: _SearchField(onChanged: (v) => setState(() => _query = v.trim().toLowerCase())),
        ),
        Expanded(
          child: groups.isEmpty
              ? const _Empty()
              : ListView(
                  padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
                  children: [
                    for (final g in groups) ..._groupSection(g),
                  ],
                ),
        ),
      ],
    );
  }

  List<Widget> _groupSection(Group group) {
    final proxies = _query.isEmpty
        ? group.all
        : group.all.where((p) => p.name.toLowerCase().contains(_query)).toList();
    if (proxies.isEmpty) return const [];
    return [
      Row(
        children: [
          Expanded(child: RSectionLabel('${group.name} · ${proxies.length}')),
          _GroupTestButton(group: group),
        ],
      ),
      Container(
        decoration: BoxDecoration(
          color: AppTokens.surface,
          borderRadius: BorderRadius.circular(AppTokens.rCard),
          border: Border.all(color: AppTokens.border),
        ),
        clipBehavior: Clip.antiAlias,
        child: Column(
          children: [
            for (var i = 0; i < proxies.length; i++) ...[
              if (i > 0) const Divider(height: 1, thickness: 1, color: AppTokens.border, indent: 12, endIndent: 12),
              _ServerRow(
                groupName: group.name,
                proxyName: proxies[i].name,
                selected: group.now == proxies[i].name,
              ),
            ],
          ],
        ),
      ),
      const SizedBox(height: 16),
    ];
  }
}

class _ServerRow extends ConsumerWidget {
  const _ServerRow({required this.groupName, required this.proxyName, required this.selected});

  final String groupName;
  final String proxyName;
  final bool selected;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final delay = ref.watch(getDelayProvider(proxyName: proxyName));
    final (delayText, delayColor) = switch (delay) {
      null => ('—', AppTokens.muted),
      <= 0 => ('timeout', AppTokens.muted),
      < 80 => ('$delay ms', AppTokens.accent),
      < 150 => ('$delay ms', AppTokens.amber),
      _ => ('$delay ms', AppTokens.muted),
    };
    return InkWell(
      onTap: () => globalState.appController.changeProxyDebounce(groupName, proxyName),
      child: Container(
        color: selected ? AppTokens.accentTint : null,
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 11),
        child: Row(
          children: [
            _CountryBadge(name: proxyName),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                stripFlag(proxyName),
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  color: AppTokens.text,
                  fontSize: 15,
                  fontWeight: selected ? FontWeight.w600 : FontWeight.w400,
                ),
              ),
            ),
            Text(delayText, style: TextStyle(color: delayColor, fontSize: 13)),
            if (selected) ...[
              const SizedBox(width: 10),
              const Icon(Icons.check, color: AppTokens.accent, size: 18),
            ],
          ],
        ),
      ),
    );
  }
}

/// A leading flag/region chip for a proxy row. Shows the proxy name's leading
/// flag emoji (common in subscription names, e.g. "🇱🇹 Lithuania") when present,
/// otherwise a neutral globe — we never fabricate a country we can't read.
class _CountryBadge extends StatelessWidget {
  const _CountryBadge({required this.name});

  final String name;

  @override
  Widget build(BuildContext context) {
    final flag = leadingFlag(name);
    return Container(
      width: 34,
      height: 26,
      decoration: BoxDecoration(
        color: AppTokens.accentTint,
        borderRadius: BorderRadius.circular(7),
      ),
      alignment: Alignment.center,
      child: flag != null
          ? Text(flag, style: const TextStyle(fontSize: 15))
          : const Icon(Icons.public, size: 15, color: AppTokens.accent),
    );
  }
}

/// Per-group "Test" action: pings every proxy in the group with the configured
/// test URL and feeds the results back through `AppController.setDelay` so the
/// rows' latency badges populate. Manages its own in-flight state.
class _GroupTestButton extends ConsumerStatefulWidget {
  const _GroupTestButton({required this.group});

  final Group group;

  @override
  ConsumerState<_GroupTestButton> createState() => _GroupTestButtonState();
}

class _GroupTestButtonState extends ConsumerState<_GroupTestButton> {
  bool _testing = false;

  Future<void> _run() async {
    if (_testing) return;
    setState(() => _testing = true);
    final url = ref.read(appSettingProvider).testUrl;
    await Future.wait(widget.group.all.map((p) async {
      try {
        final delay = await clashCore.getDelay(url, p.name);
        globalState.appController.setDelay(delay);
      } catch (_) {
        // a single unreachable proxy must not abort the whole sweep
      }
    }));
    if (mounted) setState(() => _testing = false);
  }

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.only(bottom: 10),
        child: InkWell(
          borderRadius: BorderRadius.circular(AppTokens.rPill),
          onTap: _testing ? null : _run,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (_testing)
                  const SizedBox(
                    width: 12,
                    height: 12,
                    child: CircularProgressIndicator(strokeWidth: 2, color: AppTokens.accent),
                  )
                else
                  const Icon(Icons.bolt, size: 15, color: AppTokens.accent),
                const SizedBox(width: 4),
                Text(
                  _testing ? 'Testing…' : 'Test',
                  style: const TextStyle(color: AppTokens.accent, fontSize: 13, fontWeight: FontWeight.w600),
                ),
              ],
            ),
          ),
        ),
      );
}

class _SearchField extends StatelessWidget {
  const _SearchField({required this.onChanged});

  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) => SizedBox(
        height: 42,
        child: TextField(
          onChanged: onChanged,
          style: const TextStyle(color: AppTokens.text, fontSize: 15),
          cursorColor: AppTokens.accent,
          decoration: InputDecoration(
            hintText: 'Search servers',
            hintStyle: const TextStyle(color: AppTokens.muted, fontSize: 15),
            prefixIcon: const Icon(Icons.search, color: AppTokens.muted, size: 18),
            filled: true,
            fillColor: AppTokens.surface,
            isDense: true,
            contentPadding: const EdgeInsets.symmetric(vertical: 10),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppTokens.rField),
              borderSide: const BorderSide(color: AppTokens.surface),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppTokens.rField),
              borderSide: const BorderSide(color: AppTokens.accent, width: 1.5),
            ),
          ),
        ),
      );
}

class _Empty extends StatelessWidget {
  const _Empty();

  @override
  Widget build(BuildContext context) => const Center(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 40),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.public_off, color: AppTokens.muted, size: 48),
              SizedBox(height: 14),
              Text('No servers yet',
                  style: TextStyle(color: AppTokens.text, fontSize: 16, fontWeight: FontWeight.w600)),
              SizedBox(height: 6),
              Text('Claim a subscription to load your servers.',
                  textAlign: TextAlign.center, style: TextStyle(color: AppTokens.muted, fontSize: 14)),
            ],
          ),
        ),
      );
}
