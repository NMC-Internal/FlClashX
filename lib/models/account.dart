// ignore_for_file: invalid_annotation_target
import 'package:freezed_annotation/freezed_annotation.dart';

part 'generated/account.freezed.dart';
part 'generated/account.g.dart';

/// A catalog plan from the public `GET /v1/plans` endpoint (ADR 0010).
@freezed
class Plan with _$Plan {
  const factory Plan({
    @Default('') String uuid,
    @Default('') String code,
    @Default('') String name,
    @Default('') String description,
    @JsonKey(name: 'duration_days') @Default(0) int durationDays,
    @JsonKey(name: 'traffic_limit_bytes') @Default(0) int trafficLimitBytes,
    @JsonKey(name: 'price_cents') @Default(0) int priceCents,
    @Default('USD') String currency,
    @JsonKey(name: 'device_limit') @Default(0) int deviceLimit,
    @JsonKey(name: 'sort_order') @Default(0) int sortOrder,
  }) = _Plan;

  const Plan._();

  factory Plan.fromJson(Map<String, Object?> json) => _$PlanFromJson(json);

  /// The free trial is the zero-price plan with the canonical "trial" code.
  bool get isTrial => code == 'trial';

  /// A 0 byte traffic limit means "unlimited" (matches the Remnawave convention).
  bool get isUnlimited => trafficLimitBytes == 0;
}

/// One of the user's subscriptions as reported by `GET /v1/me` (ADR 0010).
/// The list is newest-first; the [active] one carries the [subscriptionUrl] and
/// — when [enriched] — live [expireAt]/traffic from the panel.
@freezed
class Subscription with _$Subscription {
  const factory Subscription({
    @Default('') String plan,
    @Default('') String status,
    @Default(false) bool active,
    @JsonKey(name: 'subscription_url') @Default('') String subscriptionUrl,
    @JsonKey(name: 'device_limit') @Default(0) int deviceLimit,
    @Default(false) bool enriched,
    @JsonKey(name: 'expire_at') String? expireAt,
    @JsonKey(name: 'used_traffic_bytes') @Default(0) int usedTrafficBytes,
    @JsonKey(name: 'traffic_limit_bytes') @Default(0) int trafficLimitBytes,
    @JsonKey(name: 'created_at') @Default('') String createdAt,
  }) = _Subscription;

  const Subscription._();

  factory Subscription.fromJson(Map<String, Object?> json) =>
      _$SubscriptionFromJson(json);

  bool get isProvisioning => status == 'provisioning';
  bool get isFailed => status == 'failed';
  bool get isUnlimited => trafficLimitBytes == 0;

  /// Parsed expiry, or null when not yet known (e.g. still provisioning).
  DateTime? get expiresAt => (expireAt == null || expireAt!.isEmpty)
      ? null
      : DateTime.tryParse(expireAt!);

  /// Whether the subscription is past its expiry.
  bool get isExpired {
    final at = expiresAt;
    return at != null && at.isBefore(DateTime.now());
  }
}

/// The authenticated account view from `GET /v1/me` v2 (ADR 0010): email, the
/// list of subscriptions, whether the one-per-account trial may still be
/// claimed, and the active plan's device limit. An authenticated user with NO
/// subscription is valid (empty [subscriptions]).
@freezed
class Me with _$Me {
  const factory Me({
    @Default('') String email,
    @Default(<Subscription>[]) List<Subscription> subscriptions,
    @JsonKey(name: 'trial_eligible') @Default(false) bool trialEligible,
    @JsonKey(name: 'device_limit') @Default(0) int deviceLimit,
  }) = _Me;

  const Me._();

  factory Me.fromJson(Map<String, Object?> json) => _$MeFromJson(json);

  /// The current subscription (the one marked active), or null when the account
  /// has none (valid — the client shows the claim-trial / no-subscription state).
  Subscription? get activeSubscription {
    for (final s in subscriptions) {
      if (s.active) return s;
    }
    return null;
  }

  /// Absolute personal subscription URL of the active subscription, or empty.
  String get subscriptionUrl => activeSubscription?.subscriptionUrl ?? '';

  bool get hasSubscription => subscriptions.isNotEmpty;
}
