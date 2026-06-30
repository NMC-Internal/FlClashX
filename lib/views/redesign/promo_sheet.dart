import 'package:flclashx/common/common.dart';
import 'package:flclashx/design/tokens.dart';
import 'package:flclashx/pages/auth/auth_state.dart';
import 'package:flclashx/state.dart';
import 'package:flclashx/views/redesign/auth_sheet.dart';
import 'package:flclashx/views/redesign/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:forui/forui.dart';

/// Redeems a REWARD promo code (ADR 0016) from the Account screen. A guest signs in
/// first; the user enters a code; [AuthApi.validatePromo] checks it — a discount code
/// is rejected with a "use the bot" hint (the client has no checkout) — then
/// [AuthApi.applyPromo] runs and `/v1/me` is refreshed so the new expiry/traffic
/// appears. A session expiry drops to guest via the shell listener; other failures
/// show a message. Mirrors [claimTrialFlow].
Future<void> redeemPromoFlow(BuildContext context, WidgetRef ref) async {
  var token = ref.read(authTokenProvider);
  if (token == null || token.isEmpty) {
    final ok = await showAuthSheet(context);
    if (!ok) return; // user dismissed sign-in
    token = ref.read(authTokenProvider);
    if (token == null || token.isEmpty) return;
  }

  if (!context.mounted) return;
  final code = await showFSheet<String>(
    context: context,
    side: FLayout.btt,
    mainAxisMaxRatio: null,
    builder: (context) => const _PromoSheet(),
  );
  if (code == null || code.isEmpty) return;

  try {
    final preview = await authApi.validatePromo(token, code);
    if (!preview.isReward) {
      // Discount codes apply to a bot/Telegram-Payments invoice; the client has no
      // checkout, so there is nothing to discount here.
      await globalState.showMessage(
        title: appLocalizations.redeemPromo,
        message: TextSpan(text: appLocalizations.promoDiscountBotOnly),
      );
      return;
    }

    await authApi.applyPromo(token, code);
    ref.invalidate(meProvider); // surface the new expiry/traffic
    await globalState.showMessage(
      title: appLocalizations.redeemPromo,
      message: TextSpan(text: appLocalizations.promoApplied),
    );
  } on AuthException catch (e) {
    ref.invalidate(meProvider); // a sessionExpired drops to guest via the shell listener
    if (e.kind != AuthErrorKind.sessionExpired) {
      await globalState.showMessage(
        title: appLocalizations.redeemPromo,
        message: TextSpan(text: e.message),
      );
    }
  }
}

/// The promo-code entry sheet: a single code field that pops the trimmed,
/// upper-cased code (or null on cancel).
class _PromoSheet extends StatefulWidget {
  const _PromoSheet();

  @override
  State<_PromoSheet> createState() => _PromoSheetState();
}

class _PromoSheetState extends State<_PromoSheet> {
  final _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _submit() {
    final code = _controller.text.trim().toUpperCase();
    if (code.isEmpty) return;

    Navigator.of(context).pop(code);
  }

  @override
  Widget build(BuildContext context) => Material(
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
                appLocalizations.redeemPromo,
                style: const TextStyle(
                    color: AppTokens.text, fontSize: 22, fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _controller,
                autofocus: true,
                textCapitalization: TextCapitalization.characters,
                textInputAction: TextInputAction.done,
                onSubmitted: (_) => _submit(),
                style: const TextStyle(color: AppTokens.text),
                decoration: InputDecoration(
                  hintText: appLocalizations.promoCodeHint,
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
              const SizedBox(height: 16),
              RPrimaryButton(label: appLocalizations.promoApply, onPressed: _submit),
            ],
          ),
        ),
      );
}
