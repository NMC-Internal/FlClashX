import 'package:flclashx/common/auth_api.dart';
import 'package:flclashx/common/plans_api.dart';
import 'package:flclashx/models/models.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Current auth token. `null` means "not authenticated" and drives the
/// auth gate (see `AuthGate`). Hydrated from `preferences` at startup and
/// updated after a successful login/register or logout.
final authTokenProvider = StateProvider<String?>((ref) => null);

/// Selected section of the redesigned shell (0=Connect, 1=Servers, 2=Activity,
/// 3=Account, 4=Settings). A provider — not local state — so any screen can jump
/// tabs (e.g. the Connect server chip → Servers).
final shellTabProvider = StateProvider<int>((ref) => 0);

/// A subscription URL fetched from `GET /v1/me` that still needs to be
/// provisioned as the single profile. Consumed once by `Application` after the
/// gate switches to the authenticated app, then cleared.
final pendingSubscriptionUrlProvider = StateProvider<String?>((ref) => null);

/// The authenticated account view (`GET /v1/me` v2, ADR 0010). Returns `null`
/// for a guest (no token). An authed account with no subscription resolves to a
/// [Me] with an empty subscriptions list (valid, not an error). A 401 surfaces
/// as an [AuthException] with [AuthErrorKind.sessionExpired].
final meProvider = FutureProvider.autoDispose<Me?>((ref) async {
  final token = ref.watch(authTokenProvider);
  if (token == null || token.isEmpty) return null;
  return authApi.getMe(token);
});

/// The public plan catalog (`GET /v1/plans`). Available to guests; the trial
/// card is gated on [Me.trialEligible] at the screen level.
final plansProvider = FutureProvider.autoDispose<List<Plan>>(
  (ref) async => plansApi.list(),
);
