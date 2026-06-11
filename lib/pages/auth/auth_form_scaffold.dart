import 'package:flclashx/common/common.dart';
import 'package:flutter/material.dart';

/// Shared scaffold for the login and register forms: an email field, a
/// password field with validation (valid email, password >= 8 chars), a
/// submit button with a loading indicator, an inline error message, and a
/// caller-supplied [footer] (e.g. the "switch to register/login" link).
class AuthFormScaffold extends StatefulWidget {
  const AuthFormScaffold({
    super.key,
    required this.title,
    required this.submitLabel,
    required this.loading,
    required this.onSubmit,
    this.errorText,
    this.footer,
  });

  final String title;
  final String submitLabel;
  final bool loading;
  final String? errorText;
  final Future<void> Function(String email, String password) onSubmit;
  final Widget? footer;

  @override
  State<AuthFormScaffold> createState() => _AuthFormScaffoldState();
}

class _AuthFormScaffoldState extends State<AuthFormScaffold> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscurePassword = true;

  static final _emailRegExp = RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$');

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  String? _validateEmail(String? value) {
    final text = value?.trim() ?? '';
    if (text.isEmpty) {
      return appLocalizations.authEmailRequired;
    }
    if (!_emailRegExp.hasMatch(text)) {
      return appLocalizations.authEmailInvalid;
    }
    return null;
  }

  String? _validatePassword(String? value) {
    final text = value ?? '';
    if (text.isEmpty) {
      return appLocalizations.authPasswordRequired;
    }
    if (text.length < 8) {
      return appLocalizations.authPasswordTooShort;
    }
    return null;
  }

  void _handleSubmit() {
    if (widget.loading) return;
    FocusScope.of(context).unfocus();
    if (_formKey.currentState?.validate() != true) return;
    widget.onSubmit(
      _emailController.text.trim(),
      _passwordController.text,
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 360),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(
                      widget.title,
                      style: theme.textTheme.headlineSmall,
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 32),
                    TextFormField(
                      controller: _emailController,
                      enabled: !widget.loading,
                      keyboardType: TextInputType.emailAddress,
                      autocorrect: false,
                      autofillHints: const [AutofillHints.email],
                      textInputAction: TextInputAction.next,
                      decoration: InputDecoration(
                        labelText: appLocalizations.email,
                        border: const OutlineInputBorder(),
                        prefixIcon: const Icon(Icons.alternate_email),
                      ),
                      validator: _validateEmail,
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _passwordController,
                      enabled: !widget.loading,
                      obscureText: _obscurePassword,
                      autofillHints: const [AutofillHints.password],
                      textInputAction: TextInputAction.done,
                      onFieldSubmitted: (_) => _handleSubmit(),
                      decoration: InputDecoration(
                        labelText: appLocalizations.password,
                        border: const OutlineInputBorder(),
                        prefixIcon: const Icon(Icons.lock_outline),
                        suffixIcon: IconButton(
                          onPressed: () => setState(
                            () => _obscurePassword = !_obscurePassword,
                          ),
                          icon: Icon(
                            _obscurePassword
                                ? Icons.visibility_outlined
                                : Icons.visibility_off_outlined,
                          ),
                        ),
                      ),
                      validator: _validatePassword,
                    ),
                    if (widget.errorText != null) ...[
                      const SizedBox(height: 16),
                      Text(
                        widget.errorText!,
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: theme.colorScheme.error,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                    const SizedBox(height: 24),
                    FilledButton(
                      onPressed: widget.loading ? null : _handleSubmit,
                      style: FilledButton.styleFrom(
                        minimumSize: const Size.fromHeight(48),
                      ),
                      child: widget.loading
                          ? const SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            )
                          : Text(widget.submitLabel),
                    ),
                    if (widget.footer != null) ...[
                      const SizedBox(height: 8),
                      widget.footer!,
                    ],
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
