import 'package:flclashx/common/common.dart';
import 'package:flclashx/pages/auth/auth_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'auth_form_scaffold.dart';

/// Email + password registration. On success: persist token, fetch the
/// subscription URL via `GET /v1/me`, and flip the auth gate to the app.
class RegisterPage extends ConsumerStatefulWidget {
  const RegisterPage({super.key});

  @override
  ConsumerState<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends ConsumerState<RegisterPage> {
  bool _loading = false;
  String? _error;

  Future<void> _submit(String email, String password) async {
    setState(() {
      _loading = true;
      _error = null;
    });
    try {
      final token = await authApi.register(email, password);
      final me = await authApi.getMe(token);
      await preferences.setAuthToken(token);
      ref.read(pendingSubscriptionUrlProvider.notifier).state =
          me.subscriptionUrl;
      ref.read(authTokenProvider.notifier).state = token;
      // Gate rebuilds into Application; this page (and the login page below it
      // in the stack) are disposed with it.
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
  Widget build(BuildContext context) => AuthFormScaffold(
        title: appLocalizations.register,
        submitLabel: appLocalizations.register,
        loading: _loading,
        errorText: _error,
        onSubmit: _submit,
        footer: TextButton(
          onPressed: _loading ? null : () => Navigator.of(context).maybePop(),
          child: Text(appLocalizations.haveAccountLogin),
        ),
      );
}
