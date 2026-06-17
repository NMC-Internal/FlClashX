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

class _AuthSheet extends ConsumerStatefulWidget {
  const _AuthSheet();

  @override
  ConsumerState<_AuthSheet> createState() => _AuthSheetState();
}

class _AuthSheetState extends ConsumerState<_AuthSheet> {
  bool _loading = false;
  String? _error;

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

      final token = switch (cred) {
        IdTokenCredential c => await authApi.google(c.idToken),
        AuthCodeCredential c =>
          await authApi.googleDesktop(c.code, c.codeVerifier, c.redirectUri),
      };
      await preferences.setAuthToken(token);

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

      if (!mounted) return;
      ref.read(authTokenProvider.notifier).state = token; // refreshes meProvider
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
      if (mounted) setState(() => _showError(appLocalizations.authErrorUnknown));
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
                    color: AppTokens.text, fontSize: 22, fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 6),
              Text(
                appLocalizations.authSignInSubtitle,
                style: const TextStyle(color: AppTokens.muted, fontSize: 14),
              ),
              if (_error != null) ...[
                const SizedBox(height: 14),
                Text(_error!,
                    style: const TextStyle(color: AppTokens.amber, fontSize: 13)),
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
