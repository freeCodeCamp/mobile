import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:freecodecamp/services/analytics_service.dart';
import 'package:freecodecamp/services/experiment_service.dart';
import 'package:freecodecamp/services/notification_service.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../helpers/fake_analytics.dart';

void main() {
  late FakeAnalyticsSink sink;
  late AnalyticsService analytics;

  setUp(() {
    sink = FakeAnalyticsSink();
    analytics = AnalyticsService(sink);
    SharedPreferences.setMockInitialValues({});
  });

  // NOTE: Calls every catalog method once, so the catalog tests below see every event.
  Future<void> logEveryEvent() async {
    const challenge = (
      superBlock: 'responsive-web-design-v9',
      block: 'basic-html',
      challengeType: 0,
    );
    await analytics.challengeTestsRun(
      superBlock: challenge.superBlock,
      block: challenge.block,
      challengeType: challenge.challengeType,
      passed: false,
      failedTests: 2,
    );
    await analytics.challengeCompleted(
      superBlock: challenge.superBlock,
      block: challenge.block,
      challengeType: challenge.challengeType,
    );
    await analytics.dailyChallengeCompleted(language: 'python');
    await analytics.codeReset(
      superBlock: challenge.superBlock,
      block: challenge.block,
      challengeType: challenge.challengeType,
    );
    await analytics.helpRequested(
      superBlock: challenge.superBlock,
      block: challenge.block,
      challengeType: challenge.challengeType,
    );
    await analytics.login(LoginMethod.github);
    await analytics.logout();
    await analytics.accountDeleted();
    await analytics.notificationOpened(NotificationKind.dailyChallenge);
    await analytics.reportNotificationPermission(granted: true);
  }

  group('catalog', () {
    test(
      'every event method logs a name listed in eventNames, and every listed name is logged',
      () async {
        await logEveryEvent();
        expect(
          sink.events.map((e) => e.name).toSet(),
          AnalyticsService.eventNames,
        );
      },
    );

    test(
      'every event and parameter name follows the naming standard',
      () async {
        await logEveryEvent();
        for (final event in sink.events) {
          expect(isValidAnalyticsName(event.name), isTrue, reason: event.name);
          expect(event.parameters.length, lessThanOrEqualTo(maxParameters));
          for (final key in event.parameters.keys) {
            expect(
              isValidAnalyticsName(key),
              isTrue,
              reason: '${event.name}.$key',
            );
          }
        }
      },
    );

    test('experiment exposure events follow the naming standard', () {
      for (final experiment in Experiment.values) {
        expect(
          isValidAnalyticsName(experiment.exposureEvent),
          isTrue,
          reason: experiment.exposureEvent,
        );
      }
    });

    test('user property names follow the naming standard', () {
      for (final name in AnalyticsService.userPropertyNames) {
        expect(
          isValidAnalyticsName(name, maxLength: maxUserPropertyNameLength),
          isTrue,
          reason: name,
        );
      }
    });

    test('docs/ANALYTICS.md documents every event and user property', () {
      final doc = File('../docs/ANALYTICS.md').readAsStringSync();
      for (final name in {
        ...AnalyticsService.eventNames,
        ...AnalyticsService.userPropertyNames,
      }) {
        expect(
          doc,
          contains('`$name`'),
          reason: '$name is missing from docs/ANALYTICS.md',
        );
      }
    });
  });

  group('events', () {
    test(
      'challenge_tests_run carries the challenge context and result',
      () async {
        await analytics.challengeTestsRun(
          superBlock: 'javascript-v9',
          block: 'lab-palindrome',
          challengeType: 1,
          passed: true,
          failedTests: 0,
        );
        expect(sink.logged, [
          [
            'challenge_tests_run',
            {
              'superblock': 'javascript-v9',
              'block': 'lab-palindrome',
              'challenge_type': 1,
              'passed': 'true',
              'failed_tests': 0,
            },
          ],
        ]);
      },
    );

    test('login records the method', () async {
      await analytics.login(LoginMethod.fromConnection('google-oauth2'));
      expect(sink.logged, [
        [
          'login',
          {'method': 'google'},
        ],
      ]);
    });

    test(
      'notification_opened falls back to unknown for a notification without a known payload',
      () async {
        await analytics.notificationOpened(null);
        expect(sink.logged, [
          [
            'notification_opened',
            {'type': 'unknown'},
          ],
        ]);
      },
    );

    test('experiment exposure records the variant', () async {
      await analytics.experimentExposure(
        Experiment.aaTest.exposureEvent,
        variant: 'variant_a',
      );
      expect(sink.logged, [
        [
          'exp_aa_test_exposure',
          {'variant': 'variant_a'},
        ],
      ]);
    });

    test(
      'an invalid event name fails its own future, not the caller',
      () async {
        late Future<void> logged;
        expect(
          () => logged = analytics.experimentExposure(
            'Bad-Name',
            variant: 'control',
          ),
          returnsNormally,
        );
        await expectLater(logged, throwsA(isA<AssertionError>()));
        expect(sink.events, isEmpty);
      },
    );
  });

  group('user properties', () {
    test('signed_in is set as text', () async {
      await analytics.setSignedIn(true);
      expect(sink.userProperties, {'signed_in': 'true'});
    });

    test(
      'notification_permission fires only when the answer changes',
      () async {
        await analytics.reportNotificationPermission(granted: false);
        await analytics.reportNotificationPermission(granted: false);
        await analytics.reportNotificationPermission(granted: true);
        await analytics.reportNotificationPermission(granted: true);

        expect(sink.logged, [
          [
            'notification_permission',
            {'granted': 'false'},
          ],
          [
            'notification_permission',
            {'granted': 'true'},
          ],
        ]);
        expect(sink.userProperties, {'notifications_enabled': 'true'});
      },
    );
  });

  group('standards', () {
    test(
      'names must be lowercase snake_case, within length, and not reserved',
      () {
        expect(isValidAnalyticsName('challenge_completed'), isTrue);
        expect(isValidAnalyticsName('ChallengeCompleted'), isFalse);
        expect(isValidAnalyticsName('challenge-completed'), isFalse);
        expect(isValidAnalyticsName('1st_challenge'), isFalse);
        expect(isValidAnalyticsName('firebase_thing'), isFalse);
        expect(isValidAnalyticsName('google_thing'), isFalse);
        expect(isValidAnalyticsName('ga_thing'), isFalse);
        expect(isValidAnalyticsName('a' * 40), isTrue);
        expect(isValidAnalyticsName('a' * 41), isFalse);
      },
    );

    test(
      'parameters: bools become text, nulls are dropped, long strings are cut to 100',
      () {
        expect(
          normaliseParameters({
            'passed': true,
            'skipped': null,
            'note': 'x' * 150,
            'count': 3,
          }),
          {'passed': 'true', 'note': 'x' * 100, 'count': 3},
        );
      },
    );

    test('parameters: other value types are rejected', () {
      expect(() => normaliseParameters({'list': <int>[]}), throwsArgumentError);
    });

    test('parameters: more than 25 fail in debug builds', () {
      expect(
        () => normaliseParameters({for (var i = 0; i < 26; i++) 'p$i': i}),
        throwsA(isA<AssertionError>()),
      );
    });
  });

  group('mappings', () {
    test('Auth0 connections map to login methods', () {
      expect(LoginMethod.fromConnection('google-oauth2'), LoginMethod.google);
      expect(LoginMethod.fromConnection('github'), LoginMethod.github);
      expect(LoginMethod.fromConnection('apple'), LoginMethod.apple);
      expect(LoginMethod.fromConnection('email'), LoginMethod.email);
    });

    test('notification payloads map back to their kind', () {
      for (final kind in NotificationKind.values) {
        expect(NotificationKind.fromPayload(kind.payload), kind);
      }
      expect(NotificationKind.fromPayload(null), isNull);
      expect(NotificationKind.fromPayload('something_else'), isNull);
    });
  });

  group('screenViewOf', () {
    GoRouter buildRouter(String initialLocation) => GoRouter(
      initialLocation: initialLocation,
      routes: [
        GoRoute(path: '/learn', builder: (_, _) => const Text('learn')),
        GoRoute(path: '/news/:slug', builder: (_, _) => const Text('post')),
      ],
      errorBuilder: (_, _) => const Text('not found'),
    );

    testWidgets(
      'a matched route logs the location as the name and the template as the class',
      (tester) async {
        final router = buildRouter('/news/how-to-learn-react');
        await tester.pumpWidget(MaterialApp.router(routerConfig: router));
        expect(screenViewOf(router), (
          name: '/news/how-to-learn-react',
          screenClass: '/news/:slug',
        ));
      },
    );

    testWidgets('an unmatched location logs not_found instead of throwing', (
      tester,
    ) async {
      final router = buildRouter('/no-such-page');
      await tester.pumpWidget(MaterialApp.router(routerConfig: router));
      expect(() => router.state, throwsA(anything));
      expect(screenViewOf(router), (
        name: '/no-such-page',
        screenClass: 'not_found',
      ));
    });
  });
}
