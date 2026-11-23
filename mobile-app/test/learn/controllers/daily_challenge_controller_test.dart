import 'package:fake_async/fake_async.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:freecodecamp/learn/controllers/daily_challenge_controller.dart';
import 'package:freecodecamp/learn/models/daily_challenge_model.dart';
import 'package:freecodecamp/learn/services/daily_challenge_service.dart';
import 'package:timezone/data/latest.dart' as tz;

class _DailyChallengeService extends Fake
    implements LearnDailyChallengeService {
  int requests = 0;
  bool fail = false;

  @override
  Future<DailyChallengeOverview> getToday() async {
    requests++;
    if (fail) throw StateError('Offline');
    return DailyChallengeOverview(
      id: 'daily-$requests',
      challengeNumber: requests,
      date: DateTime(2026, 11, requests),
      title: 'Challenge $requests',
    );
  }
}

ProviderContainer _container(
  FakeAsync async,
  DateTime start,
  _DailyChallengeService service,
) => ProviderContainer(
  overrides: [
    learnDailyChallengeServiceProvider.overrideWithValue(service),
    dailyChallengeTodayProvider.overrideWith(
      () => DailyChallengeTodayNotifier(now: async.getClock(start).now),
    ),
  ],
);

void main() {
  setUpAll(tz.initializeTimeZones);

  test(
    'shared listeners refresh once at Chicago midnight and the next day',
    () {
      fakeAsync((async) {
        final service = _DailyChallengeService();
        final container = _container(
          async,
          DateTime.utc(2026, 11, 23, 5, 59, 59),
          service,
        );
        container.listen(dailyChallengeTodayProvider, (_, _) {});
        container.listen(dailyChallengeTodayProvider, (_, _) {});
        async.flushMicrotasks();
        expect(service.requests, 1);

        async.elapse(const Duration(milliseconds: 999));
        expect(service.requests, 1);
        async.elapse(const Duration(milliseconds: 1));
        async.flushMicrotasks();
        expect(service.requests, 2);
        expect(
          container.read(dailyChallengeTodayProvider).value?.id,
          'daily-2',
        );

        async.elapse(const Duration(days: 1));
        async.flushMicrotasks();
        expect(service.requests, 3);
        container.dispose();
        expect(async.pendingTimers, isEmpty);
      });
    },
  );

  for (final boundary in [
    (start: DateTime.utc(2026, 3, 8, 6), hours: 23),
    (start: DateTime.utc(2026, 11, 1, 5), hours: 25),
  ]) {
    test('Chicago midnight handles a ${boundary.hours}-hour DST day', () {
      fakeAsync((async) {
        final service = _DailyChallengeService();
        final container = _container(async, boundary.start, service);
        container.listen(dailyChallengeTodayProvider, (_, _) {});
        async.flushMicrotasks();

        async.elapse(
          Duration(hours: boundary.hours) - const Duration(seconds: 1),
        );
        expect(service.requests, 1);
        async.elapse(const Duration(seconds: 1));
        async.flushMicrotasks();
        expect(service.requests, 2);
        container.dispose();
      });
    });
  }

  test(
    'manual retry replaces the timer and keeps the next midnight refresh',
    () {
      fakeAsync((async) {
        final service = _DailyChallengeService();
        final container = _container(
          async,
          DateTime.utc(2026, 11, 23, 5, 59, 58),
          service,
        );
        container.listen(dailyChallengeTodayProvider, (_, _) {});
        async.flushMicrotasks();

        async.elapse(const Duration(seconds: 1));
        container.invalidate(dailyChallengeTodayProvider);
        async.elapse(Duration.zero);
        async.flushMicrotasks();
        expect(service.requests, 2);
        expect(async.nonPeriodicTimerCount, 1);

        async.elapse(const Duration(seconds: 1));
        async.flushMicrotasks();
        expect(service.requests, 3);
        container.dispose();
      });
    },
  );

  test('closing the last listener cancels midnight work', () {
    fakeAsync((async) {
      final service = _DailyChallengeService();
      final container = _container(
        async,
        DateTime.utc(2026, 11, 23, 5, 59, 59),
        service,
      );
      final subscription = container.listen(
        dailyChallengeTodayProvider,
        (_, _) {},
      );
      async.flushMicrotasks();

      subscription.close();
      async.elapse(Duration.zero);
      async.flushMicrotasks();
      expect(async.pendingTimers, isEmpty);
      async.elapse(const Duration(days: 2));
      expect(service.requests, 1);
      container.dispose();
    });
  });

  test('a failed fetch shows an error until manually retried', () {
    fakeAsync((async) {
      final service = _DailyChallengeService()..fail = true;
      final container = _container(
        async,
        DateTime.utc(2026, 11, 23, 12),
        service,
      );
      container.listen(dailyChallengeTodayProvider, (_, _) {});
      async.flushMicrotasks();
      expect(container.read(dailyChallengeTodayProvider).hasError, isTrue);

      async.elapse(const Duration(minutes: 1));
      expect(service.requests, 1);
      service.fail = false;
      container.invalidate(dailyChallengeTodayProvider);
      async.elapse(Duration.zero);
      async.flushMicrotasks();
      expect(service.requests, 2);
      expect(container.read(dailyChallengeTodayProvider).hasError, isFalse);
      container.dispose();
    });
  });
}
