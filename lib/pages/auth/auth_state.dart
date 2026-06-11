import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Current auth token. `null` means "not authenticated" and drives the
/// auth gate (see `AuthGate`). Hydrated from `preferences` at startup and
/// updated after a successful login/register or logout.
final authTokenProvider = StateProvider<String?>((ref) => null);

/// A subscription URL fetched from `GET /v1/me` that still needs to be
/// provisioned as the single profile. Consumed once by `Application` after the
/// gate switches to the authenticated app, then cleared.
final pendingSubscriptionUrlProvider = StateProvider<String?>((ref) => null);
