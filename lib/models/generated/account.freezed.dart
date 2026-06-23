// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of '../account.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

Plan _$PlanFromJson(Map<String, dynamic> json) {
  return _Plan.fromJson(json);
}

/// @nodoc
mixin _$Plan {
  String get uuid => throw _privateConstructorUsedError;
  String get code => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  String get description => throw _privateConstructorUsedError;
  @JsonKey(name: 'duration_days')
  int get durationDays => throw _privateConstructorUsedError;
  @JsonKey(name: 'traffic_limit_bytes')
  int get trafficLimitBytes => throw _privateConstructorUsedError;
  @JsonKey(name: 'price_cents')
  int get priceCents => throw _privateConstructorUsedError;
  String get currency => throw _privateConstructorUsedError;
  @JsonKey(name: 'device_limit')
  int get deviceLimit => throw _privateConstructorUsedError;
  @JsonKey(name: 'sort_order')
  int get sortOrder => throw _privateConstructorUsedError;

  /// Serializes this Plan to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of Plan
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $PlanCopyWith<Plan> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PlanCopyWith<$Res> {
  factory $PlanCopyWith(Plan value, $Res Function(Plan) then) =
      _$PlanCopyWithImpl<$Res, Plan>;
  @useResult
  $Res call(
      {String uuid,
      String code,
      String name,
      String description,
      @JsonKey(name: 'duration_days') int durationDays,
      @JsonKey(name: 'traffic_limit_bytes') int trafficLimitBytes,
      @JsonKey(name: 'price_cents') int priceCents,
      String currency,
      @JsonKey(name: 'device_limit') int deviceLimit,
      @JsonKey(name: 'sort_order') int sortOrder});
}

/// @nodoc
class _$PlanCopyWithImpl<$Res, $Val extends Plan>
    implements $PlanCopyWith<$Res> {
  _$PlanCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of Plan
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? uuid = null,
    Object? code = null,
    Object? name = null,
    Object? description = null,
    Object? durationDays = null,
    Object? trafficLimitBytes = null,
    Object? priceCents = null,
    Object? currency = null,
    Object? deviceLimit = null,
    Object? sortOrder = null,
  }) {
    return _then(_value.copyWith(
      uuid: null == uuid
          ? _value.uuid
          : uuid // ignore: cast_nullable_to_non_nullable
              as String,
      code: null == code
          ? _value.code
          : code // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      description: null == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String,
      durationDays: null == durationDays
          ? _value.durationDays
          : durationDays // ignore: cast_nullable_to_non_nullable
              as int,
      trafficLimitBytes: null == trafficLimitBytes
          ? _value.trafficLimitBytes
          : trafficLimitBytes // ignore: cast_nullable_to_non_nullable
              as int,
      priceCents: null == priceCents
          ? _value.priceCents
          : priceCents // ignore: cast_nullable_to_non_nullable
              as int,
      currency: null == currency
          ? _value.currency
          : currency // ignore: cast_nullable_to_non_nullable
              as String,
      deviceLimit: null == deviceLimit
          ? _value.deviceLimit
          : deviceLimit // ignore: cast_nullable_to_non_nullable
              as int,
      sortOrder: null == sortOrder
          ? _value.sortOrder
          : sortOrder // ignore: cast_nullable_to_non_nullable
              as int,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$PlanImplCopyWith<$Res> implements $PlanCopyWith<$Res> {
  factory _$$PlanImplCopyWith(
          _$PlanImpl value, $Res Function(_$PlanImpl) then) =
      __$$PlanImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String uuid,
      String code,
      String name,
      String description,
      @JsonKey(name: 'duration_days') int durationDays,
      @JsonKey(name: 'traffic_limit_bytes') int trafficLimitBytes,
      @JsonKey(name: 'price_cents') int priceCents,
      String currency,
      @JsonKey(name: 'device_limit') int deviceLimit,
      @JsonKey(name: 'sort_order') int sortOrder});
}

/// @nodoc
class __$$PlanImplCopyWithImpl<$Res>
    extends _$PlanCopyWithImpl<$Res, _$PlanImpl>
    implements _$$PlanImplCopyWith<$Res> {
  __$$PlanImplCopyWithImpl(_$PlanImpl _value, $Res Function(_$PlanImpl) _then)
      : super(_value, _then);

  /// Create a copy of Plan
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? uuid = null,
    Object? code = null,
    Object? name = null,
    Object? description = null,
    Object? durationDays = null,
    Object? trafficLimitBytes = null,
    Object? priceCents = null,
    Object? currency = null,
    Object? deviceLimit = null,
    Object? sortOrder = null,
  }) {
    return _then(_$PlanImpl(
      uuid: null == uuid
          ? _value.uuid
          : uuid // ignore: cast_nullable_to_non_nullable
              as String,
      code: null == code
          ? _value.code
          : code // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      description: null == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String,
      durationDays: null == durationDays
          ? _value.durationDays
          : durationDays // ignore: cast_nullable_to_non_nullable
              as int,
      trafficLimitBytes: null == trafficLimitBytes
          ? _value.trafficLimitBytes
          : trafficLimitBytes // ignore: cast_nullable_to_non_nullable
              as int,
      priceCents: null == priceCents
          ? _value.priceCents
          : priceCents // ignore: cast_nullable_to_non_nullable
              as int,
      currency: null == currency
          ? _value.currency
          : currency // ignore: cast_nullable_to_non_nullable
              as String,
      deviceLimit: null == deviceLimit
          ? _value.deviceLimit
          : deviceLimit // ignore: cast_nullable_to_non_nullable
              as int,
      sortOrder: null == sortOrder
          ? _value.sortOrder
          : sortOrder // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$PlanImpl extends _Plan {
  const _$PlanImpl(
      {this.uuid = '',
      this.code = '',
      this.name = '',
      this.description = '',
      @JsonKey(name: 'duration_days') this.durationDays = 0,
      @JsonKey(name: 'traffic_limit_bytes') this.trafficLimitBytes = 0,
      @JsonKey(name: 'price_cents') this.priceCents = 0,
      this.currency = 'USD',
      @JsonKey(name: 'device_limit') this.deviceLimit = 0,
      @JsonKey(name: 'sort_order') this.sortOrder = 0})
      : super._();

  factory _$PlanImpl.fromJson(Map<String, dynamic> json) =>
      _$$PlanImplFromJson(json);

  @override
  @JsonKey()
  final String uuid;
  @override
  @JsonKey()
  final String code;
  @override
  @JsonKey()
  final String name;
  @override
  @JsonKey()
  final String description;
  @override
  @JsonKey(name: 'duration_days')
  final int durationDays;
  @override
  @JsonKey(name: 'traffic_limit_bytes')
  final int trafficLimitBytes;
  @override
  @JsonKey(name: 'price_cents')
  final int priceCents;
  @override
  @JsonKey()
  final String currency;
  @override
  @JsonKey(name: 'device_limit')
  final int deviceLimit;
  @override
  @JsonKey(name: 'sort_order')
  final int sortOrder;

  @override
  String toString() {
    return 'Plan(uuid: $uuid, code: $code, name: $name, description: $description, durationDays: $durationDays, trafficLimitBytes: $trafficLimitBytes, priceCents: $priceCents, currency: $currency, deviceLimit: $deviceLimit, sortOrder: $sortOrder)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PlanImpl &&
            (identical(other.uuid, uuid) || other.uuid == uuid) &&
            (identical(other.code, code) || other.code == code) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.durationDays, durationDays) ||
                other.durationDays == durationDays) &&
            (identical(other.trafficLimitBytes, trafficLimitBytes) ||
                other.trafficLimitBytes == trafficLimitBytes) &&
            (identical(other.priceCents, priceCents) ||
                other.priceCents == priceCents) &&
            (identical(other.currency, currency) ||
                other.currency == currency) &&
            (identical(other.deviceLimit, deviceLimit) ||
                other.deviceLimit == deviceLimit) &&
            (identical(other.sortOrder, sortOrder) ||
                other.sortOrder == sortOrder));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      uuid,
      code,
      name,
      description,
      durationDays,
      trafficLimitBytes,
      priceCents,
      currency,
      deviceLimit,
      sortOrder);

  /// Create a copy of Plan
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$PlanImplCopyWith<_$PlanImpl> get copyWith =>
      __$$PlanImplCopyWithImpl<_$PlanImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$PlanImplToJson(
      this,
    );
  }
}

abstract class _Plan extends Plan {
  const factory _Plan(
      {final String uuid,
      final String code,
      final String name,
      final String description,
      @JsonKey(name: 'duration_days') final int durationDays,
      @JsonKey(name: 'traffic_limit_bytes') final int trafficLimitBytes,
      @JsonKey(name: 'price_cents') final int priceCents,
      final String currency,
      @JsonKey(name: 'device_limit') final int deviceLimit,
      @JsonKey(name: 'sort_order') final int sortOrder}) = _$PlanImpl;
  const _Plan._() : super._();

  factory _Plan.fromJson(Map<String, dynamic> json) = _$PlanImpl.fromJson;

  @override
  String get uuid;
  @override
  String get code;
  @override
  String get name;
  @override
  String get description;
  @override
  @JsonKey(name: 'duration_days')
  int get durationDays;
  @override
  @JsonKey(name: 'traffic_limit_bytes')
  int get trafficLimitBytes;
  @override
  @JsonKey(name: 'price_cents')
  int get priceCents;
  @override
  String get currency;
  @override
  @JsonKey(name: 'device_limit')
  int get deviceLimit;
  @override
  @JsonKey(name: 'sort_order')
  int get sortOrder;

  /// Create a copy of Plan
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$PlanImplCopyWith<_$PlanImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

Subscription _$SubscriptionFromJson(Map<String, dynamic> json) {
  return _Subscription.fromJson(json);
}

/// @nodoc
mixin _$Subscription {
  String get plan => throw _privateConstructorUsedError;
  String get status => throw _privateConstructorUsedError;
  bool get active => throw _privateConstructorUsedError;
  @JsonKey(name: 'subscription_url')
  String get subscriptionUrl => throw _privateConstructorUsedError;
  @JsonKey(name: 'device_limit')
  int get deviceLimit => throw _privateConstructorUsedError;
  bool get enriched => throw _privateConstructorUsedError;
  @JsonKey(name: 'expire_at')
  String? get expireAt => throw _privateConstructorUsedError;
  @JsonKey(name: 'used_traffic_bytes')
  int get usedTrafficBytes => throw _privateConstructorUsedError;
  @JsonKey(name: 'traffic_limit_bytes')
  int get trafficLimitBytes => throw _privateConstructorUsedError;
  @JsonKey(name: 'created_at')
  String get createdAt => throw _privateConstructorUsedError;

  /// Serializes this Subscription to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of Subscription
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $SubscriptionCopyWith<Subscription> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $SubscriptionCopyWith<$Res> {
  factory $SubscriptionCopyWith(
          Subscription value, $Res Function(Subscription) then) =
      _$SubscriptionCopyWithImpl<$Res, Subscription>;
  @useResult
  $Res call(
      {String plan,
      String status,
      bool active,
      @JsonKey(name: 'subscription_url') String subscriptionUrl,
      @JsonKey(name: 'device_limit') int deviceLimit,
      bool enriched,
      @JsonKey(name: 'expire_at') String? expireAt,
      @JsonKey(name: 'used_traffic_bytes') int usedTrafficBytes,
      @JsonKey(name: 'traffic_limit_bytes') int trafficLimitBytes,
      @JsonKey(name: 'created_at') String createdAt});
}

/// @nodoc
class _$SubscriptionCopyWithImpl<$Res, $Val extends Subscription>
    implements $SubscriptionCopyWith<$Res> {
  _$SubscriptionCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of Subscription
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? plan = null,
    Object? status = null,
    Object? active = null,
    Object? subscriptionUrl = null,
    Object? deviceLimit = null,
    Object? enriched = null,
    Object? expireAt = freezed,
    Object? usedTrafficBytes = null,
    Object? trafficLimitBytes = null,
    Object? createdAt = null,
  }) {
    return _then(_value.copyWith(
      plan: null == plan
          ? _value.plan
          : plan // ignore: cast_nullable_to_non_nullable
              as String,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as String,
      active: null == active
          ? _value.active
          : active // ignore: cast_nullable_to_non_nullable
              as bool,
      subscriptionUrl: null == subscriptionUrl
          ? _value.subscriptionUrl
          : subscriptionUrl // ignore: cast_nullable_to_non_nullable
              as String,
      deviceLimit: null == deviceLimit
          ? _value.deviceLimit
          : deviceLimit // ignore: cast_nullable_to_non_nullable
              as int,
      enriched: null == enriched
          ? _value.enriched
          : enriched // ignore: cast_nullable_to_non_nullable
              as bool,
      expireAt: freezed == expireAt
          ? _value.expireAt
          : expireAt // ignore: cast_nullable_to_non_nullable
              as String?,
      usedTrafficBytes: null == usedTrafficBytes
          ? _value.usedTrafficBytes
          : usedTrafficBytes // ignore: cast_nullable_to_non_nullable
              as int,
      trafficLimitBytes: null == trafficLimitBytes
          ? _value.trafficLimitBytes
          : trafficLimitBytes // ignore: cast_nullable_to_non_nullable
              as int,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$SubscriptionImplCopyWith<$Res>
    implements $SubscriptionCopyWith<$Res> {
  factory _$$SubscriptionImplCopyWith(
          _$SubscriptionImpl value, $Res Function(_$SubscriptionImpl) then) =
      __$$SubscriptionImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String plan,
      String status,
      bool active,
      @JsonKey(name: 'subscription_url') String subscriptionUrl,
      @JsonKey(name: 'device_limit') int deviceLimit,
      bool enriched,
      @JsonKey(name: 'expire_at') String? expireAt,
      @JsonKey(name: 'used_traffic_bytes') int usedTrafficBytes,
      @JsonKey(name: 'traffic_limit_bytes') int trafficLimitBytes,
      @JsonKey(name: 'created_at') String createdAt});
}

/// @nodoc
class __$$SubscriptionImplCopyWithImpl<$Res>
    extends _$SubscriptionCopyWithImpl<$Res, _$SubscriptionImpl>
    implements _$$SubscriptionImplCopyWith<$Res> {
  __$$SubscriptionImplCopyWithImpl(
      _$SubscriptionImpl _value, $Res Function(_$SubscriptionImpl) _then)
      : super(_value, _then);

  /// Create a copy of Subscription
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? plan = null,
    Object? status = null,
    Object? active = null,
    Object? subscriptionUrl = null,
    Object? deviceLimit = null,
    Object? enriched = null,
    Object? expireAt = freezed,
    Object? usedTrafficBytes = null,
    Object? trafficLimitBytes = null,
    Object? createdAt = null,
  }) {
    return _then(_$SubscriptionImpl(
      plan: null == plan
          ? _value.plan
          : plan // ignore: cast_nullable_to_non_nullable
              as String,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as String,
      active: null == active
          ? _value.active
          : active // ignore: cast_nullable_to_non_nullable
              as bool,
      subscriptionUrl: null == subscriptionUrl
          ? _value.subscriptionUrl
          : subscriptionUrl // ignore: cast_nullable_to_non_nullable
              as String,
      deviceLimit: null == deviceLimit
          ? _value.deviceLimit
          : deviceLimit // ignore: cast_nullable_to_non_nullable
              as int,
      enriched: null == enriched
          ? _value.enriched
          : enriched // ignore: cast_nullable_to_non_nullable
              as bool,
      expireAt: freezed == expireAt
          ? _value.expireAt
          : expireAt // ignore: cast_nullable_to_non_nullable
              as String?,
      usedTrafficBytes: null == usedTrafficBytes
          ? _value.usedTrafficBytes
          : usedTrafficBytes // ignore: cast_nullable_to_non_nullable
              as int,
      trafficLimitBytes: null == trafficLimitBytes
          ? _value.trafficLimitBytes
          : trafficLimitBytes // ignore: cast_nullable_to_non_nullable
              as int,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$SubscriptionImpl extends _Subscription {
  const _$SubscriptionImpl(
      {this.plan = '',
      this.status = '',
      this.active = false,
      @JsonKey(name: 'subscription_url') this.subscriptionUrl = '',
      @JsonKey(name: 'device_limit') this.deviceLimit = 0,
      this.enriched = false,
      @JsonKey(name: 'expire_at') this.expireAt,
      @JsonKey(name: 'used_traffic_bytes') this.usedTrafficBytes = 0,
      @JsonKey(name: 'traffic_limit_bytes') this.trafficLimitBytes = 0,
      @JsonKey(name: 'created_at') this.createdAt = ''})
      : super._();

  factory _$SubscriptionImpl.fromJson(Map<String, dynamic> json) =>
      _$$SubscriptionImplFromJson(json);

  @override
  @JsonKey()
  final String plan;
  @override
  @JsonKey()
  final String status;
  @override
  @JsonKey()
  final bool active;
  @override
  @JsonKey(name: 'subscription_url')
  final String subscriptionUrl;
  @override
  @JsonKey(name: 'device_limit')
  final int deviceLimit;
  @override
  @JsonKey()
  final bool enriched;
  @override
  @JsonKey(name: 'expire_at')
  final String? expireAt;
  @override
  @JsonKey(name: 'used_traffic_bytes')
  final int usedTrafficBytes;
  @override
  @JsonKey(name: 'traffic_limit_bytes')
  final int trafficLimitBytes;
  @override
  @JsonKey(name: 'created_at')
  final String createdAt;

  @override
  String toString() {
    return 'Subscription(plan: $plan, status: $status, active: $active, subscriptionUrl: $subscriptionUrl, deviceLimit: $deviceLimit, enriched: $enriched, expireAt: $expireAt, usedTrafficBytes: $usedTrafficBytes, trafficLimitBytes: $trafficLimitBytes, createdAt: $createdAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SubscriptionImpl &&
            (identical(other.plan, plan) || other.plan == plan) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.active, active) || other.active == active) &&
            (identical(other.subscriptionUrl, subscriptionUrl) ||
                other.subscriptionUrl == subscriptionUrl) &&
            (identical(other.deviceLimit, deviceLimit) ||
                other.deviceLimit == deviceLimit) &&
            (identical(other.enriched, enriched) ||
                other.enriched == enriched) &&
            (identical(other.expireAt, expireAt) ||
                other.expireAt == expireAt) &&
            (identical(other.usedTrafficBytes, usedTrafficBytes) ||
                other.usedTrafficBytes == usedTrafficBytes) &&
            (identical(other.trafficLimitBytes, trafficLimitBytes) ||
                other.trafficLimitBytes == trafficLimitBytes) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      plan,
      status,
      active,
      subscriptionUrl,
      deviceLimit,
      enriched,
      expireAt,
      usedTrafficBytes,
      trafficLimitBytes,
      createdAt);

  /// Create a copy of Subscription
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$SubscriptionImplCopyWith<_$SubscriptionImpl> get copyWith =>
      __$$SubscriptionImplCopyWithImpl<_$SubscriptionImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$SubscriptionImplToJson(
      this,
    );
  }
}

abstract class _Subscription extends Subscription {
  const factory _Subscription(
          {final String plan,
          final String status,
          final bool active,
          @JsonKey(name: 'subscription_url') final String subscriptionUrl,
          @JsonKey(name: 'device_limit') final int deviceLimit,
          final bool enriched,
          @JsonKey(name: 'expire_at') final String? expireAt,
          @JsonKey(name: 'used_traffic_bytes') final int usedTrafficBytes,
          @JsonKey(name: 'traffic_limit_bytes') final int trafficLimitBytes,
          @JsonKey(name: 'created_at') final String createdAt}) =
      _$SubscriptionImpl;
  const _Subscription._() : super._();

  factory _Subscription.fromJson(Map<String, dynamic> json) =
      _$SubscriptionImpl.fromJson;

  @override
  String get plan;
  @override
  String get status;
  @override
  bool get active;
  @override
  @JsonKey(name: 'subscription_url')
  String get subscriptionUrl;
  @override
  @JsonKey(name: 'device_limit')
  int get deviceLimit;
  @override
  bool get enriched;
  @override
  @JsonKey(name: 'expire_at')
  String? get expireAt;
  @override
  @JsonKey(name: 'used_traffic_bytes')
  int get usedTrafficBytes;
  @override
  @JsonKey(name: 'traffic_limit_bytes')
  int get trafficLimitBytes;
  @override
  @JsonKey(name: 'created_at')
  String get createdAt;

  /// Create a copy of Subscription
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$SubscriptionImplCopyWith<_$SubscriptionImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

Me _$MeFromJson(Map<String, dynamic> json) {
  return _Me.fromJson(json);
}

/// @nodoc
mixin _$Me {
  String get email => throw _privateConstructorUsedError;
  List<Subscription> get subscriptions => throw _privateConstructorUsedError;
  @JsonKey(name: 'trial_eligible')
  bool get trialEligible => throw _privateConstructorUsedError;
  @JsonKey(name: 'device_limit')
  int get deviceLimit => throw _privateConstructorUsedError;
  List<String> get providers => throw _privateConstructorUsedError;

  /// Serializes this Me to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of Me
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $MeCopyWith<Me> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $MeCopyWith<$Res> {
  factory $MeCopyWith(Me value, $Res Function(Me) then) =
      _$MeCopyWithImpl<$Res, Me>;
  @useResult
  $Res call(
      {String email,
      List<Subscription> subscriptions,
      @JsonKey(name: 'trial_eligible') bool trialEligible,
      @JsonKey(name: 'device_limit') int deviceLimit,
      List<String> providers});
}

/// @nodoc
class _$MeCopyWithImpl<$Res, $Val extends Me> implements $MeCopyWith<$Res> {
  _$MeCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of Me
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? email = null,
    Object? subscriptions = null,
    Object? trialEligible = null,
    Object? deviceLimit = null,
    Object? providers = null,
  }) {
    return _then(_value.copyWith(
      email: null == email
          ? _value.email
          : email // ignore: cast_nullable_to_non_nullable
              as String,
      subscriptions: null == subscriptions
          ? _value.subscriptions
          : subscriptions // ignore: cast_nullable_to_non_nullable
              as List<Subscription>,
      trialEligible: null == trialEligible
          ? _value.trialEligible
          : trialEligible // ignore: cast_nullable_to_non_nullable
              as bool,
      deviceLimit: null == deviceLimit
          ? _value.deviceLimit
          : deviceLimit // ignore: cast_nullable_to_non_nullable
              as int,
      providers: null == providers
          ? _value.providers
          : providers // ignore: cast_nullable_to_non_nullable
              as List<String>,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$MeImplCopyWith<$Res> implements $MeCopyWith<$Res> {
  factory _$$MeImplCopyWith(_$MeImpl value, $Res Function(_$MeImpl) then) =
      __$$MeImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String email,
      List<Subscription> subscriptions,
      @JsonKey(name: 'trial_eligible') bool trialEligible,
      @JsonKey(name: 'device_limit') int deviceLimit,
      List<String> providers});
}

/// @nodoc
class __$$MeImplCopyWithImpl<$Res> extends _$MeCopyWithImpl<$Res, _$MeImpl>
    implements _$$MeImplCopyWith<$Res> {
  __$$MeImplCopyWithImpl(_$MeImpl _value, $Res Function(_$MeImpl) _then)
      : super(_value, _then);

  /// Create a copy of Me
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? email = null,
    Object? subscriptions = null,
    Object? trialEligible = null,
    Object? deviceLimit = null,
    Object? providers = null,
  }) {
    return _then(_$MeImpl(
      email: null == email
          ? _value.email
          : email // ignore: cast_nullable_to_non_nullable
              as String,
      subscriptions: null == subscriptions
          ? _value._subscriptions
          : subscriptions // ignore: cast_nullable_to_non_nullable
              as List<Subscription>,
      trialEligible: null == trialEligible
          ? _value.trialEligible
          : trialEligible // ignore: cast_nullable_to_non_nullable
              as bool,
      deviceLimit: null == deviceLimit
          ? _value.deviceLimit
          : deviceLimit // ignore: cast_nullable_to_non_nullable
              as int,
      providers: null == providers
          ? _value._providers
          : providers // ignore: cast_nullable_to_non_nullable
              as List<String>,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$MeImpl extends _Me {
  const _$MeImpl(
      {this.email = '',
      final List<Subscription> subscriptions = const <Subscription>[],
      @JsonKey(name: 'trial_eligible') this.trialEligible = false,
      @JsonKey(name: 'device_limit') this.deviceLimit = 0,
      final List<String> providers = const <String>[]})
      : _subscriptions = subscriptions,
        _providers = providers,
        super._();

  factory _$MeImpl.fromJson(Map<String, dynamic> json) =>
      _$$MeImplFromJson(json);

  @override
  @JsonKey()
  final String email;
  final List<Subscription> _subscriptions;
  @override
  @JsonKey()
  List<Subscription> get subscriptions {
    if (_subscriptions is EqualUnmodifiableListView) return _subscriptions;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_subscriptions);
  }

  @override
  @JsonKey(name: 'trial_eligible')
  final bool trialEligible;
  @override
  @JsonKey(name: 'device_limit')
  final int deviceLimit;
  final List<String> _providers;
  @override
  @JsonKey()
  List<String> get providers {
    if (_providers is EqualUnmodifiableListView) return _providers;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_providers);
  }

  @override
  String toString() {
    return 'Me(email: $email, subscriptions: $subscriptions, trialEligible: $trialEligible, deviceLimit: $deviceLimit, providers: $providers)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$MeImpl &&
            (identical(other.email, email) || other.email == email) &&
            const DeepCollectionEquality()
                .equals(other._subscriptions, _subscriptions) &&
            (identical(other.trialEligible, trialEligible) ||
                other.trialEligible == trialEligible) &&
            (identical(other.deviceLimit, deviceLimit) ||
                other.deviceLimit == deviceLimit) &&
            const DeepCollectionEquality()
                .equals(other._providers, _providers));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      email,
      const DeepCollectionEquality().hash(_subscriptions),
      trialEligible,
      deviceLimit,
      const DeepCollectionEquality().hash(_providers));

  /// Create a copy of Me
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$MeImplCopyWith<_$MeImpl> get copyWith =>
      __$$MeImplCopyWithImpl<_$MeImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$MeImplToJson(
      this,
    );
  }
}

abstract class _Me extends Me {
  const factory _Me(
      {final String email,
      final List<Subscription> subscriptions,
      @JsonKey(name: 'trial_eligible') final bool trialEligible,
      @JsonKey(name: 'device_limit') final int deviceLimit,
      final List<String> providers}) = _$MeImpl;
  const _Me._() : super._();

  factory _Me.fromJson(Map<String, dynamic> json) = _$MeImpl.fromJson;

  @override
  String get email;
  @override
  List<Subscription> get subscriptions;
  @override
  @JsonKey(name: 'trial_eligible')
  bool get trialEligible;
  @override
  @JsonKey(name: 'device_limit')
  int get deviceLimit;
  @override
  List<String> get providers;

  /// Create a copy of Me
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$MeImplCopyWith<_$MeImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
