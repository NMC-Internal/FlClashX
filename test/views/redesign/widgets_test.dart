import 'package:flclashx/views/redesign/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

/// Unit tests for the redesign's pure helpers + a button smoke test.
void main() {
  group('formatBytes', () {
    test('formats common sizes', () {
      expect(formatBytes(0), '0 B');
      expect(formatBytes(512), '512 B');
      expect(formatBytes(5368709120), '5.0 GB');
      expect(formatBytes(107374182400), '100 GB');
      expect(formatBytes(4509715660), '4.2 GB');
    });
  });

  group('formatShortDate', () {
    test('formats as MMM d', () {
      expect(formatShortDate(DateTime(2026, 6, 22)), 'Jun 22');
      expect(formatShortDate(DateTime(2026, 1, 1)), 'Jan 1');
      expect(formatShortDate(DateTime(2026, 12, 31)), 'Dec 31');
    });
  });

  group('leadingFlag / stripFlag', () {
    test('extracts a leading flag emoji', () {
      expect(leadingFlag('🇱🇹 Lithuania'), '🇱🇹');
      expect(leadingFlag('Lithuania'), isNull);
      expect(leadingFlag(''), isNull);
    });

    test('strips the leading flag for a clean label', () {
      expect(stripFlag('🇱🇹 Lithuania'), 'Lithuania');
      expect(stripFlag('Tokyo'), 'Tokyo');
    });
  });

  group('RPrimaryButton', () {
    testWidgets('renders label and fires onPressed', (tester) async {
      var tapped = false;
      await tester.pumpWidget(MaterialApp(
        home: Scaffold(
          body: RPrimaryButton(label: 'Connect', onPressed: () => tapped = true),
        ),
      ));
      expect(find.text('Connect'), findsOneWidget);
      await tester.tap(find.text('Connect'));
      expect(tapped, isTrue);
    });
  });
}
