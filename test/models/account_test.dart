import 'dart:convert';
import 'dart:io';

import 'package:flclashx/models/account.dart';
import 'package:flutter_test/flutter_test.dart';

/// Contract tests for the `/v1/me` v2 and `/v1/plans` parsers (ADR 0010).
/// Fixtures are real captured backend responses — these guard against the
/// client/backend JSON contract drifting.
void main() {
  Map<String, Object?> loadJson(String path) =>
      jsonDecode(File(path).readAsStringSync()) as Map<String, Object?>;

  group('Me.fromJson — /v1/me v2 fixture', () {
    late Me me;
    setUpAll(() => me = Me.fromJson(loadJson('test/fixtures/me_v2.json')));

    test('parses identity and account flags', () {
      expect(me.email, contains('@'));
      expect(me.trialEligible, isFalse);
      expect(me.deviceLimit, 1);
      expect(me.subscriptions, hasLength(1));
      expect(me.hasSubscription, isTrue);
    });

    test('exposes the active subscription and its url', () {
      final sub = me.activeSubscription;
      expect(sub, isNotNull);
      expect(sub!.plan, 'trial');
      expect(sub.active, isTrue);
      expect(me.subscriptionUrl, startsWith('http://127.0.0.1:8080/v1/sub/'));
    });

    test('parses traffic/limit/expiry of the active subscription', () {
      final sub = me.activeSubscription!;
      expect(sub.trafficLimitBytes, 5368709120);
      expect(sub.isUnlimited, isFalse);
      expect(sub.expiresAt, DateTime.utc(2026, 6, 22, 12, 36, 59));
    });
  });

  group('Me — empty / guest shapes', () {
    test('authed-no-subscription is valid (not an error)', () {
      const me = Me(email: 'a@b.com');
      expect(me.activeSubscription, isNull);
      expect(me.subscriptionUrl, isEmpty);
      expect(me.hasSubscription, isFalse);
    });

    test('activeSubscription picks the active one among many', () {
      const me = Me(subscriptions: [
        Subscription(plan: 'monthly', active: false),
        Subscription(plan: 'trial', active: true, subscriptionUrl: 'u'),
      ]);
      expect(me.activeSubscription?.plan, 'trial');
      expect(me.subscriptionUrl, 'u');
    });
  });

  group('Subscription — status/expiry logic', () {
    String iso(Duration d) => DateTime.now().toUtc().add(d).toIso8601String();

    test('isExpired reflects expire_at vs now', () {
      expect(Subscription(expireAt: iso(const Duration(days: -1))).isExpired, isTrue);
      expect(Subscription(expireAt: iso(const Duration(days: 1))).isExpired, isFalse);
      expect(const Subscription().isExpired, isFalse); // unknown expiry
    });

    test('status flags', () {
      expect(const Subscription(status: 'provisioning').isProvisioning, isTrue);
      expect(const Subscription(status: 'failed').isFailed, isTrue);
      expect(const Subscription(status: 'active').isProvisioning, isFalse);
    });

    test('isUnlimited when traffic limit is 0', () {
      expect(const Subscription(trafficLimitBytes: 0).isUnlimited, isTrue);
      expect(const Subscription(trafficLimitBytes: 100).isUnlimited, isFalse);
    });
  });

  group('Plan.fromJson — /v1/plans fixture', () {
    late List<Plan> plans;
    setUpAll(() {
      final json = loadJson('test/fixtures/plans.json');
      plans = (json['plans']! as List)
          .map((e) => Plan.fromJson(e as Map<String, Object?>))
          .toList();
    });

    test('parses all catalog plans', () {
      expect(plans, hasLength(3));
      expect(plans.map((p) => p.code), ['trial', 'monthly', 'yearly']);
    });

    test('trial flag + pricing', () {
      final trial = plans.firstWhere((p) => p.code == 'trial');
      expect(trial.isTrial, isTrue);
      expect(trial.priceCents, 0);
      expect(trial.isUnlimited, isFalse);
      expect(plans.firstWhere((p) => p.code == 'monthly').isTrial, isFalse);
    });

    test('yearly is unlimited traffic', () {
      final yearly = plans.firstWhere((p) => p.code == 'yearly');
      expect(yearly.trafficLimitBytes, 0);
      expect(yearly.isUnlimited, isTrue);
      expect(yearly.durationDays, 365);
    });
  });
}
