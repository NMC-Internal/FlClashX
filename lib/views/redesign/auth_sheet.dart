import 'dart:async';

import 'package:flclashx/common/common.dart';
import 'package:flclashx/common/social_auth.dart';
import 'package:flclashx/design/tokens.dart';
import 'package:flclashx/pages/auth/auth_state.dart';
import 'package:flclashx/state.dart';
import 'package:flclashx/views/redesign/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:forui/forui.dart';

/// Opens the social-login sheet (ADR 0014) — the on-demand gate of the guest
/// flow (claim a subscription). Returns `true` if the user authenticated.
Future<bool> showAuthSheet(BuildContext context) async {
  final ok = await showFSheet<bool>(
    context: context,
    side: FLayout.btt,
    mainAxisMaxRatio: null,
    builder: (context) => const _AuthSheet(),
  );
  return ok ?? false;
}

/// Claims the one-per-account trial (ADR 0017 §3) from any "Start free trial"
/// CTA. A guest is prompted to sign in first; then [AuthApi.claimTrial] runs and
/// `/v1/me` is refreshed so the new (provisioning→active) subscription appears.
/// 204 and 409 both count as success (the account has its trial either way). A
/// session expiry is handled globally by the shell listener; other failures show
/// a message. Safe to call from the Connect CTA and the Plans trial card.
Future<void> claimTrialFlow(BuildContext context, WidgetRef ref) async {
  var token = ref.read(authTokenProvider);
  if (token == null || token.isEmpty) {
    final ok = await showAuthSheet(context);
    if (!ok) return; // user dismissed sign-in
    token = ref.read(authTokenProvider);
    if (token == null || token.isEmpty) return;
  }

  try {
    await authApi.claimTrial(token);
    ref.invalidate(
        meProvider); // surface the new provisioning→active subscription
  } on AuthException catch (e) {
    ref.invalidate(
        meProvider); // a sessionExpired drops to guest via the shell listener
    if (e.kind != AuthErrorKind.sessionExpired) {
      await globalState.showMessage(
        title: appLocalizations.startFreeTrial,
        message: TextSpan(text: e.message),
      );
    }
  }
}

class _AuthSheet extends ConsumerStatefulWidget {
  const _AuthSheet();

  @override
  ConsumerState<_AuthSheet> createState() => _AuthSheetState();
}

class _AuthSheetState extends ConsumerState<_AuthSheet> {
  bool _loading = false;
  String? _error;
  final _referralController = TextEditingController();

  @override
  void dispose() {
    _referralController.dispose();
    super.dispose();
  }

  Future<void> _signInWithGoogle() async {
    setState(() {
      _loading = true;
      _error = null;
    });
    try {
      final cred = await googleAuth.obtainCredential();
      if (cred == null) {
        // User cancelled the Google flow.
        if (mounted) setState(() => _loading = false);
        return;
      }

      final tokens = switch (cred) {
        IdTokenCredential c => await authApi.google(c.idToken),
        AuthCodeCredential c =>
          await authApi.googleDesktop(c.code, c.codeVerifier, c.redirectUri),
      };
      final token = tokens.accessToken;
      // Persist BOTH the access and refresh token (ADR 0021).
      await preferences.setAuthTokens(token, tokens.refreshToken);

      // Fetch the account; provision the active subscription's profile so the
      // tunnel is ready (Application.initState only provisions once, at boot).
      String? url;
      try {
        final me = await authApi.getMe(token);
        if (me.email.isNotEmpty) await preferences.setUserEmail(me.email);
        url = me.subscriptionUrl;
      } on AuthException {
        // best-effort; the reconciler / next /me will heal it
      }

      // Best-effort referral attribution (ADR 0020): runs while `token` is in scope,
      // BEFORE the meProvider invalidate below, so the welcome bonus shows on the
      // first /v1/me. A bad/absent code must NEVER block sign-in.
      final referral = _referralController.text.trim().toUpperCase();
      if (referral.isNotEmpty) {
        try {
          await authApi.applyReferral(token, referral);
        } on AuthException {
          // ignore — a referral failure never breaks sign-in
        } catch (_) {
          // ignore — same
        }
      }

      if (!mounted) return;
      ref.read(authTokenProvider.notifier).state =
          token; // refreshes meProvider
      if (url != null && url.isNotEmpty) {
        unawaited(globalState.appController.provisionSubscription(url));
      }
      ref.invalidate(meProvider);
      Navigator.of(context).pop(true);
    } on AuthException catch (e) {
      if (mounted) setState(() => _showError(e.message));
    } on SocialAuthException catch (e) {
      if (mounted) setState(() => _showError(e.message));
    } catch (_) {
      if (mounted) {
        setState(() => _showError(appLocalizations.authErrorUnknown));
      }
    }
  }

  void _showError(String message) {
    _error = message;
    _loading = false;
  }

  @override
  Widget build(BuildContext context) => Material(
        // The forui sheet is pushed outside the app's Material tree; Material
        // widgets (buttons) need a Material ancestor.
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
                appLocalizations.authSignInTitle,
                style: const TextStyle(
                    color: AppTokens.text,
                    fontSize: 22,
                    fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 6),
              Text(
                appLocalizations.authSignInSubtitle,
                style: const TextStyle(color: AppTokens.muted, fontSize: 14),
              ),
              const SizedBox(height: 16),
              // Optional referral code (ADR 0020) — applied after sign-in, best-effort.
              TextField(
                controller: _referralController,
                textCapitalization: TextCapitalization.characters,
                textInputAction: TextInputAction.done,
                style: const TextStyle(color: AppTokens.text),
                decoration: InputDecoration(
                  hintText: appLocalizations.referralCodeHintOptional,
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
                    style:
                        const TextStyle(color: AppTokens.amber, fontSize: 13)),
              ],
              const SizedBox(height: 24),
              RPrimaryButton(
                label: _loading ? '…' : appLocalizations.continueWithGoogle,
                icon: _loading ? null : Icons.g_mobiledata,
                onPressed: _loading ? null : _signInWithGoogle,
              ),
              const SizedBox(height: 12),
              // Apple sign-in is reserved (ADR 0014) — disabled until implemented.
              RSecondaryButton(
                label: appLocalizations.appleComingSoon,
                onPressed: null,
              ),
              const SizedBox(height: 16),
              Text(
                appLocalizations.authLegal,
                textAlign: TextAlign.center,
                style: const TextStyle(
                    color: AppTokens.muted, fontSize: 12, height: 1.4),
              ),
            ],
          ),
        ),
      );
}
