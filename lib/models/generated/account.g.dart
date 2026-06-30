// GENERATED CODE - DO NOT MODIFY BY HAND

part of '../account.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$PlanImpl _$$PlanImplFromJson(Map<String, dynamic> json) => _$PlanImpl(
      uuid: json['uuid'] as String? ?? '',
      code: json['code'] as String? ?? '',
      name: json['name'] as String? ?? '',
      description: json['description'] as String? ?? '',
      durationDays: (json['duration_days'] as num?)?.toInt() ?? 0,
      trafficLimitBytes: (json['traffic_limit_bytes'] as num?)?.toInt() ?? 0,
      priceCents: (json['price_cents'] as num?)?.toInt() ?? 0,
      currency: json['currency'] as String? ?? 'USD',
      deviceLimit: (json['device_limit'] as num?)?.toInt() ?? 0,
      sortOrder: (json['sort_order'] as num?)?.toInt() ?? 0,
    );

Map<String, dynamic> _$$PlanImplToJson(_$PlanImpl instance) =>
    <String, dynamic>{
      'uuid': instance.uuid,
      'code': instance.code,
      'name': instance.name,
      'description': instance.description,
      'duration_days': instance.durationDays,
      'traffic_limit_bytes': instance.trafficLimitBytes,
      'price_cents': instance.priceCents,
      'currency': instance.currency,
      'device_limit': instance.deviceLimit,
      'sort_order': instance.sortOrder,
    };

_$SubscriptionImpl _$$SubscriptionImplFromJson(Map<String, dynamic> json) =>
    _$SubscriptionImpl(
      plan: json['plan'] as String? ?? '',
      planName: json['plan_name'] as String? ?? '',
      status: json['status'] as String? ?? '',
      active: json['active'] as bool? ?? false,
      subscriptionUrl: json['subscription_url'] as String? ?? '',
      deviceLimit: (json['device_limit'] as num?)?.toInt() ?? 0,
      enriched: json['enriched'] as bool? ?? false,
      expireAt: json['expire_at'] as String?,
      usedTrafficBytes: (json['used_traffic_bytes'] as num?)?.toInt() ?? 0,
      trafficLimitBytes: (json['traffic_limit_bytes'] as num?)?.toInt() ?? 0,
      createdAt: json['created_at'] as String? ?? '',
    );

Map<String, dynamic> _$$SubscriptionImplToJson(_$SubscriptionImpl instance) =>
    <String, dynamic>{
      'plan': instance.plan,
      'plan_name': instance.planName,
      'status': instance.status,
      'active': instance.active,
      'subscription_url': instance.subscriptionUrl,
      'device_limit': instance.deviceLimit,
      'enriched': instance.enriched,
      'expire_at': instance.expireAt,
      'used_traffic_bytes': instance.usedTrafficBytes,
      'traffic_limit_bytes': instance.trafficLimitBytes,
      'created_at': instance.createdAt,
    };

_$MeImpl _$$MeImplFromJson(Map<String, dynamic> json) => _$MeImpl(
      email: json['email'] as String? ?? '',
      subscriptions: (json['subscriptions'] as List<dynamic>?)
              ?.map((e) => Subscription.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const <Subscription>[],
      trialEligible: json['trial_eligible'] as bool? ?? false,
      deviceLimit: (json['device_limit'] as num?)?.toInt() ?? 0,
      providers: (json['providers'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const <String>[],
    );

Map<String, dynamic> _$$MeImplToJson(_$MeImpl instance) => <String, dynamic>{
      'email': instance.email,
      'subscriptions': instance.subscriptions,
      'trial_eligible': instance.trialEligible,
      'device_limit': instance.deviceLimit,
      'providers': instance.providers,
    };
