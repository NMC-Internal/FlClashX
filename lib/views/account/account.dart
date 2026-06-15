import 'package:flclashx/common/common.dart';
import 'package:flclashx/enum/enum.dart';
import 'package:flclashx/models/models.dart';
import 'package:flclashx/pages/auth/auth_state.dart';
import 'package:flclashx/providers/providers.dart';
import 'package:flclashx/state.dart';
import 'package:flclashx/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

/// Account tab. Replaces the old multi-profile manager: shows the signed-in
/// user's email plus the traffic/expiry of the single provisioned subscription
/// (parsed from the `subscription-userinfo` header into [Profile.subscriptionInfo]),
/// and lets the user log out.
class AccountView extends ConsumerStatefulWidget {
  const AccountView({super.key});

  @override
  ConsumerState<AccountView> createState() => _AccountViewState();
}

class _AccountViewState extends ConsumerState<AccountView> with PageMixin {
  String? _email;

  @override
  void initState() {
    super.initState();
    _loadEmail();
  }

  Future<void> _loadEmail() async {
    final email = await preferences.getUserEmail();
    if (!mounted) return;
    setState(() {
      _email = email;
    });
  }

  Future<void> _handleLogout() async {
    final res = await globalState.showMessage(
      title: appLocalizations.logout,
      message: TextSpan(text: appLocalizations.logoutConfirm),
    );
    if (res != true) return;

    // Drop the local subscription and credentials, then flip the auth gate back
    // to the login flow by clearing the token provider.
    await globalState.appController.clearProfiles();
    await preferences.clearAuthToken();
    await preferences.clearUserEmail();
    ref.read(pendingSubscriptionUrlProvider.notifier).state = null;
    ref.read(authTokenProvider.notifier).state = null;
  }

  @override
  Widget build(BuildContext context) {
    final currentProfile = ref.watch(currentProfileProvider);
    return ListView(
      padding: const EdgeInsets.only(bottom: 20),
      children: [
        _AccountHeader(email: _email),
        _SubscriptionCard(profile: currentProfile),
        const SizedBox(height: 12),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: FilledButton.tonalIcon(
            onPressed: _handleLogout,
            style: FilledButton.styleFrom(
              minimumSize: const Size.fromHeight(48),
              backgroundColor: context.colorScheme.errorContainer,
              foregroundColor: context.colorScheme.onErrorContainer,
            ),
            icon: const Icon(Icons.logout),
            label: Text(appLocalizations.logout),
          ),
        ),
      ],
    );
  }
}

class _AccountHeader extends StatelessWidget {
  const _AccountHeader({required this.email});

  final String? email;

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        child: Row(
          children: [
            CircleAvatar(
              radius: 28,
              backgroundColor: context.colorScheme.primaryContainer,
              child: Icon(
                Icons.person,
                size: 32,
                color: context.colorScheme.onPrimaryContainer,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    appLocalizations.account,
                    style: context.textTheme.labelMedium?.copyWith(
                      color: context.colorScheme.onSurfaceVariant,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    email?.isNotEmpty == true
                        ? email!
                        : appLocalizations.accountEmailUnknown,
                    style: context.textTheme.titleMedium,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ],
        ),
      );
}

class _SubscriptionCard extends StatelessWidget {
  const _SubscriptionCard({required this.profile});

  final Profile? profile;

  @override
  Widget build(BuildContext context) {
    final subscriptionInfo = profile?.subscriptionInfo;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: CommonCard(
        type: CommonCardType.filled,
        radius: 18,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: subscriptionInfo == null
              ? _buildEmpty(context)
              : _buildInfo(context, subscriptionInfo),
        ),
      ),
    );
  }

  Widget _buildEmpty(BuildContext context) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            appLocalizations.subscription,
            style: context.textTheme.titleMedium,
          ),
          const SizedBox(height: 8),
          Text(
            appLocalizations.accountNoSubscription,
            style: context.textTheme.bodyMedium?.copyWith(
              color: context.colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      );

  Widget _buildInfo(BuildContext context, SubscriptionInfo info) {
    final isUnlimited = info.total == 0;
    final usedValue = info.upload + info.download;
    final usedTraffic = TrafficValue(value: usedValue);
    final totalTraffic = TrafficValue(value: info.total);

    var progress = 0.0;
    if (info.total > 0) {
      progress = (usedValue / info.total).clamp(0.0, 1.0);
    }
    var progressColor = Colors.green;
    if (progress > 0.9) {
      progressColor = Colors.red;
    } else if (progress > 0.7) {
      progressColor = Colors.orange;
    }

    final expireText = info.expire > 0
        ? '${appLocalizations.expiresOn} '
            '${DateFormat('dd.MM.yyyy').format(DateTime.fromMillisecondsSinceEpoch(info.expire * 1000))}'
        : appLocalizations.subscriptionEternal;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          appLocalizations.subscription,
          style: context.textTheme.titleMedium,
        ),
        const SizedBox(height: 16),
        if (isUnlimited)
          Text(
            appLocalizations.trafficUnlimited,
            style: context.textTheme.bodyLarge,
          )
        else ...[
          Text(
            appLocalizations.accountTrafficRemaining(
              '${usedTraffic.showValue} ${usedTraffic.showUnit}',
              '${totalTraffic.showValue} ${totalTraffic.showUnit}',
            ),
            style: context.textTheme.bodyLarge,
          ),
          const SizedBox(height: 8),
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: LinearProgressIndicator(
              value: progress,
              minHeight: 8,
              backgroundColor: context.colorScheme.surfaceContainerHighest,
              valueColor: AlwaysStoppedAnimation<Color>(progressColor),
            ),
          ),
        ],
        const SizedBox(height: 16),
        Row(
          children: [
            Icon(
              Icons.event_outlined,
              size: 18,
              color: context.colorScheme.onSurfaceVariant,
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                expireText,
                style: context.textTheme.bodyMedium,
              ),
            ),
          ],
        ),
        if (profile?.lastUpdateDate != null) ...[
          const SizedBox(height: 8),
          Text(
            '${appLocalizations.updated} '
            '${profile!.lastUpdateDate!.lastUpdateTimeDesc}',
            style: context.textTheme.labelMedium?.copyWith(
              color: context.colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      ],
    );
  }
}
