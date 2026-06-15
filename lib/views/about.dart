import 'package:flclashx/common/common.dart';
import 'package:flclashx/state.dart';
import 'package:flclashx/widgets/widgets.dart';
import 'package:flutter/material.dart';

class AboutView extends StatelessWidget {
  const AboutView({super.key});

  @override
  Widget build(BuildContext context) {
    final items = [
      ListTile(
        title: Wrap(
          spacing: 16,
          crossAxisAlignment: WrapCrossAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.all(12),
              child: Image.asset(
                'assets/images/icon.png',
                width: 64,
                height: 64,
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  appName,
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
                Text(
                  globalState.packageInfo.version,
                  style: Theme.of(context).textTheme.labelLarge,
                ),
                const SizedBox(height: 4),
                const _CoreVersionWidget(),
              ],
            )
          ],
        ),
      ),
    ];
    return Padding(
      padding: kMaterialListPadding.copyWith(
        top: 16,
        bottom: 16,
      ),
      child: generateListView(items),
    );
  }
}

class _CoreVersionWidget extends StatelessWidget {
  const _CoreVersionWidget();

  @override
  Widget build(BuildContext context) {
    final coreVersion = globalState.coreVersion;
    if (coreVersion == null || coreVersion.isEmpty) {
      return const SizedBox.shrink();
    }
    return Text(
      'Core: $coreVersion',
      style: Theme.of(context).textTheme.bodySmall?.copyWith(
            color: Theme.of(context).colorScheme.onSurfaceVariant,
          ),
    );
  }
}
