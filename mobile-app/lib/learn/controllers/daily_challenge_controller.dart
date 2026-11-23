import 'dart:async';

import 'package:freecodecamp/learn/models/daily_challenge_model.dart';
import 'package:freecodecamp/learn/services/daily_challenge_service.dart';
import 'package:freecodecamp/utils/riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:timezone/timezone.dart' as tz;

part 'daily_challenge_controller.g.dart';

@Riverpod(retry: noRetry)
class DailyChallengeTodayNotifier extends _$DailyChallengeTodayNotifier {
  DailyChallengeTodayNotifier({DateTime Function()? now})
    : _now = now ?? DateTime.now;

  final DateTime Function() _now;

  @override
  Future<DailyChallengeOverview> build() {
    // A new challenge unlocks at midnight US Central, including DST changes.
    final chicago = tz.getLocation('America/Chicago');
    final now = tz.TZDateTime.from(_now(), chicago);
    final midnight = tz.TZDateTime(chicago, now.year, now.month, now.day + 1);
    final refreshTimer = Timer(midnight.difference(now), () {
      if (ref.mounted) ref.invalidateSelf();
    });
    ref.onDispose(refreshTimer.cancel);

    return ref.watch(learnDailyChallengeServiceProvider).getToday();
  }
}
