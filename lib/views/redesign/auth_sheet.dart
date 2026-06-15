import 'dart:async';

import 'package:flclashx/common/common.dart';
import 'package:flclashx/design/tokens.dart';
import 'package:flclashx/pages/auth/auth_state.dart';
import 'package:flclashx/state.dart';
import 'package:flclashx/views/redesign/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:forui/forui.dart';

/// Opens the redesigned auth modal (forui bottom sheet) — the on-demand gate of
/// the guest flow (claim a subscription). Returns `true` if the user
/// authenticated. [register] selects the initial Sign in / Create account tab.
Future<bool> showAuthSheet(BuildContext context, {bool register = true}) async {
  final ok = await showFSheet<bool>(
    context: context,
    side: FLayout.btt,
    mainAxisMaxRatio: null,
    builder: (context) => _AuthSheet(initialRegister: register),
  );
  return ok ?? false;
}

class _AuthSheet extends ConsumerStatefulWidget {
  const _AuthSheet({required this.initialRegister});

  final bool initialRegister;

  @override
  ConsumerState<_AuthSheet> createState() => _AuthSheetState();
}

class _AuthSheetState extends ConsumerState<_AuthSheet> {
  late bool _register = widget.initialRegister;
  final _email = TextEditingController();
  final _password = TextEditingController();
  bool _loading = false;
  bool _obscure = true;
  String? _error;

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    final email = _email.text.trim();
    final password = _password.text;
    if (email.isEmpty || password.isEmpty) {
      setState(() => _error = appLocalizations.authErrorInvalidCredentials);
      return;
    }
    setState(() {
      _loading = true;
      _error = null;
    });
    try {
      final token = _register
          ? await authApi.register(email, password)
          : await authApi.login(email, password);
      await preferences.setAuthToken(token);
      await preferences.setUserEmail(email);
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
      ref.read(authTokenProvider.notifier).state =
          token; // refreshes meProvider
      if (url != null && url.isNotEmpty) {
        unawaited(globalState.appController.provisionSubscription(url));
      }
      ref.invalidate(meProvider);
      Navigator.of(context).pop(true);
    } on AuthException catch (e) {
      if (!mounted) return;
      setState(() {
        _error = e.message;
        _loading = false;
      });
    } catch (_) {
      if (!mounted) return;
      setState(() {
        _error = appLocalizations.authErrorUnknown;
        _loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) => Material(
        // The forui sheet is pushed outside the app's Material tree; Material
        // form widgets (TextField/FilledButton) need a Material ancestor.
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
                _register
                    ? appLocalizations.authCreateTitle
                    : appLocalizations.authWelcomeTitle,
                style: const TextStyle(
                    color: AppTokens.text,
                    fontSize: 22,
                    fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 6),
              Text(
                _register
                    ? appLocalizations.authCreateSubtitle
                    : appLocalizations.signInToManage,
                style: const TextStyle(color: AppTokens.muted, fontSize: 14),
              ),
              const SizedBox(height: 20),
              _Toggle(
                register: _register,
                onChanged:
                    _loading ? null : (v) => setState(() => _register = v),
              ),
              const SizedBox(height: 20),
              RSectionLabel(appLocalizations.email),
              _Field(
                  controller: _email,
                  hint: 'you@email.com',
                  icon: Icons.mail_outline,
                  keyboard: TextInputType.emailAddress),
              const SizedBox(height: 14),
              RSectionLabel(appLocalizations.password),
              _Field(
                controller: _password,
                hint: '••••••••',
                icon: Icons.lock_outline,
                obscure: _obscure,
                trailing: IconButton(
                  icon: Icon(
                      _obscure
                          ? Icons.visibility_outlined
                          : Icons.visibility_off_outlined,
                      color: AppTokens.muted,
                      size: 20),
                  onPressed: () => setState(() => _obscure = !_obscure),
                ),
              ),
              if (_error != null) ...[
                const SizedBox(height: 12),
                Text(_error!,
                    style:
                        const TextStyle(color: AppTokens.amber, fontSize: 13)),
              ],
              const SizedBox(height: 20),
              RPrimaryButton(
                label: _loading
                    ? '…'
                    : (_register
                        ? appLocalizations.createAccount
                        : appLocalizations.signIn),
                onPressed: _loading ? null : _submit,
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

class _Toggle extends StatelessWidget {
  const _Toggle({required this.register, required this.onChanged});

  final bool register;
  final ValueChanged<bool>? onChanged;

  @override
  Widget build(BuildContext context) => Container(
        height: 44,
        padding: const EdgeInsets.all(4),
        decoration: BoxDecoration(
          color: AppTokens.surface,
          borderRadius: BorderRadius.circular(AppTokens.rField),
        ),
        child: Row(
          children: [
            _seg(appLocalizations.signIn, !register,
                () => onChanged?.call(false)),
            _seg(appLocalizations.createAccount, register,
                () => onChanged?.call(true)),
          ],
        ),
      );

  Widget _seg(String label, bool selected, VoidCallback onTap) => Expanded(
        child: GestureDetector(
          onTap: onTap,
          child: Container(
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: selected ? AppTokens.accentTint : Colors.transparent,
              borderRadius: BorderRadius.circular(AppTokens.rSegment),
            ),
            child: Text(
              label,
              style: TextStyle(
                color: selected ? AppTokens.accent : AppTokens.muted,
                fontSize: 14,
                fontWeight: selected ? FontWeight.w600 : FontWeight.w500,
              ),
            ),
          ),
        ),
      );
}

class _Field extends StatelessWidget {
  const _Field({
    required this.controller,
    required this.hint,
    required this.icon,
    this.obscure = false,
    this.trailing,
    this.keyboard,
  });

  final TextEditingController controller;
  final String hint;
  final IconData icon;
  final bool obscure;
  final Widget? trailing;
  final TextInputType? keyboard;

  @override
  Widget build(BuildContext context) => TextField(
        controller: controller,
        obscureText: obscure,
        keyboardType: keyboard,
        style: const TextStyle(color: AppTokens.text, fontSize: 15),
        cursorColor: AppTokens.accent,
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: const TextStyle(color: AppTokens.muted, fontSize: 15),
          prefixIcon: Icon(icon, color: AppTokens.muted, size: 20),
          suffixIcon: trailing,
          filled: true,
          fillColor: AppTokens.surface,
          contentPadding: const EdgeInsets.symmetric(vertical: 14),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(AppTokens.rField),
            borderSide: const BorderSide(color: AppTokens.border),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(AppTokens.rField),
            borderSide: const BorderSide(color: AppTokens.accent, width: 1.5),
          ),
        ),
      );
}
