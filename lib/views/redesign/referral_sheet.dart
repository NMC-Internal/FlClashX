import 'package:flclashx/common/common.dart';
import 'package:flclashx/design/tokens.dart';
import 'package:flclashx/pages/auth/auth_state.dart';
import 'package:flclashx/state.dart';
import 'package:flclashx/views/redesign/auth_sheet.dart';
import 'package:flclashx/views/redesign/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:forui/forui.dart';
import 'package:url_launcher/url_launcher.dart';

/// Opens the "Invite friends" sheet (ADR 0020) from the Account screen. A guest
/// signs in first; then the sheet shows the account's own referral code/link + stats
/// (`GET /v1/referral/info`) and offers a "have a code?" action. Mirrors the promo
/// redeem flow.
Future<void> referralInviteFlow(BuildContext context, WidgetRef ref) async {
  var token = ref.read(authTokenProvider);
  if (token == null || token.isEmpty) {
    final ok = await showAuthSheet(context);
    if (!ok) return; // user dismissed sign-in
    token = ref.read(authTokenProvider);
    if (token == null || token.isEmpty) return;
  }

  if (!context.mounted) return;
  await showFSheet<void>(
    context: context,
    side: FLayout.btt,
    mainAxisMaxRatio: null,
    builder: (context) => const _ReferralSheet(),
  );
}

/// The referral sheet: an invite view (own code/link + share/copy + stats) with a
/// switch to an enter-code view (attribute a friend's code in place). The backend is
/// the source of truth; this is a thin reader/trigger.
class _ReferralSheet extends ConsumerStatefulWidget {
  const _ReferralSheet();

  @override
  ConsumerState<_ReferralSheet> createState() => _ReferralSheetState();
}

class _ReferralSheetState extends ConsumerState<_ReferralSheet> {
  bool _enteringCode = false;
  bool _loading = false;
  String? _error;
  ReferralResult? _success;
  final _codeController = TextEditingController();

  @override
  void dispose() {
    _codeController.dispose();
    super.dispose();
  }

  Future<void> _apply() async {
    final code = _codeController.text.trim().toUpperCase();
    if (code.isEmpty) return;
    setState(() {
      _loading = true;
      _error = null;
      _success = null;
    });

    final token = ref.read(authTokenProvider);
    if (token == null || token.isEmpty) {
      setState(() {
        _loading = false;
        _error = appLocalizations.authErrorSessionExpired;
      });
      return;
    }

    try {
      final result = await authApi.applyReferral(token, code);
      ref
        ..invalidate(meProvider) // surface the welcome bonus
        ..invalidate(referralInfoProvider); // refresh own stats
      if (mounted) {
        setState(() {
          _loading = false;
          _success = result;
        });
      }
    } on AuthException catch (e) {
      if (mounted) {
        setState(() {
          _loading = false;
          _error = e.message;
        });
      }
    }
  }

  Future<void> _copy(String text) async {
    await Clipboard.setData(ClipboardData(text: text));
    if (mounted) {
      await globalState.showMessage(
        title: appLocalizations.inviteFriends,
        message: TextSpan(text: appLocalizations.referralCopied),
      );
    }
  }

  Future<void> _share(String link) async {
    await launchUrl(Uri.parse(link), mode: LaunchMode.externalApplication);
  }

  String _successText(ReferralResult r) => r.welcomeDays > 0
      ? appLocalizations.referralAttributed(r.welcomeDays)
      : appLocalizations.referralApplied;

  @override
  Widget build(BuildContext context) {
    final infoAsync = ref.watch(referralInfoProvider);
    return Material(
      // The forui sheet is pushed outside the app's Material tree.
      type: MaterialType.transparency,
      child: Container(
        width: double.infinity,
        decoration: const BoxDecoration(
          color: AppTokens.bg,
          border: Border(top: BorderSide(color: AppTokens.border)),
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        padding: EdgeInsets.fromLTRB(
          24,
          12,
          24,
          24 + MediaQuery.of(context).viewInsets.bottom,
        ),
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
            const SizedBox(height: 20),
            Text(
              appLocalizations.inviteFriends,
              style: const TextStyle(
                  color: AppTokens.text,
                  fontSize: 22,
                  fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 16),
            if (_enteringCode)
              _enterCodeView()
            else
              infoAsync.when(
                loading: () => const Padding(
                  padding: EdgeInsets.symmetric(vertical: 24),
                  child: Center(
                      child:
                          CircularProgressIndicator(color: AppTokens.accent)),
                ),
                error: (_, __) => Text(
                  appLocalizations.accountLoadError,
                  style: const TextStyle(color: AppTokens.muted, fontSize: 13),
                ),
                data: (info) => info == null
                    ? Text(
                        appLocalizations.accountLoadError,
                        style: const TextStyle(
                            color: AppTokens.muted, fontSize: 13),
                      )
                    : _inviteView(info),
              ),
          ],
        ),
      ),
    );
  }

  Widget _inviteView(ReferralInfo info) {
    final shareTarget = info.link.isNotEmpty ? info.link : info.code;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          appLocalizations.referralYourCode,
          style: const TextStyle(color: AppTokens.muted, fontSize: 13),
        ),
        const SizedBox(height: 6),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            color: AppTokens.surface,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppTokens.border),
          ),
          child: Text(
            info.code,
            style: const TextStyle(
              color: AppTokens.text,
              fontSize: 18,
              fontWeight: FontWeight.w600,
              letterSpacing: 2,
            ),
          ),
        ),
        const SizedBox(height: 16),
        RPrimaryButton(
          label: appLocalizations.referralCopyLink,
          onPressed: () => _copy(shareTarget),
        ),
        if (info.link.isNotEmpty) ...[
          const SizedBox(height: 12),
          RSecondaryButton(
            label: appLocalizations.referralShare,
            onPressed: () => _share(info.link),
          ),
        ],
        const SizedBox(height: 16),
        _stat(appLocalizations.referralInvitedCount(info.invitedCount)),
        _stat(appLocalizations.referralEarnedDays(info.earnedDays)),
        if (info.commissionPercent > 0)
          _stat(appLocalizations.referralCommission(info.commissionPercent)),
        const SizedBox(height: 16),
        RSecondaryButton(
          label: appLocalizations.referralEnterCode,
          onPressed: () => setState(() => _enteringCode = true),
        ),
      ],
    );
  }

  Widget _enterCodeView() => Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          TextField(
            controller: _codeController,
            autofocus: true,
            textCapitalization: TextCapitalization.characters,
            textInputAction: TextInputAction.done,
            onSubmitted: (_) => _apply(),
            style: const TextStyle(color: AppTokens.text),
            decoration: InputDecoration(
              hintText: appLocalizations.referralCodeHint,
              hintStyle: const TextStyle(color: AppTokens.muted),
              filled: true,
              fillColor: AppTokens.surface,
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: AppTokens.border),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: AppTokens.accent),
              ),
            ),
          ),
          if (_error != null) ...[
            const SizedBox(height: 14),
            Text(_error!,
                style: const TextStyle(color: AppTokens.amber, fontSize: 13)),
          ],
          if (_success?.attributed ?? false) ...[
            const SizedBox(height: 14),
            Text(_successText(_success!),
                style: const TextStyle(color: AppTokens.accent, fontSize: 13)),
          ],
          const SizedBox(height: 16),
          RPrimaryButton(
            label: _loading ? '…' : appLocalizations.referralApply,
            onPressed: _loading ? null : _apply,
          ),
        ],
      );

  Widget _stat(String text) => Padding(
        padding: const EdgeInsets.only(top: 4),
        child: Text(text,
            style: const TextStyle(color: AppTokens.muted, fontSize: 13)),
      );
}
