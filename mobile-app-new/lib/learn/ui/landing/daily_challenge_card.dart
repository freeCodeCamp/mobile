import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mobile_app_new/fcc_theme.dart';
import 'package:mobile_app_new/learn/ui/landing/landing_viewmodel.dart';
import 'package:mobile_app_new/routing/learn.dart';
import 'package:mobile_app_new/services/auth_service.dart';
import 'package:timezone/timezone.dart' as tz;

class DailyChallengeCard extends ConsumerWidget {
  const DailyChallengeCard({super.key, this.showArchiveLink = true});
  final bool showArchiveLink;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final challenge = ref.watch(dailyChallengeTodayProvider).value;
    if (challenge == null) return const SizedBox.shrink();
    final colors = Theme.of(context).colorScheme;
    final design = FccDesignColors.of(context);
    final isCompleted = ref.watch(
      authProvider.select(
        (s) =>
            s.value?.completedDailyCodingChallenges.any(
              (c) => c.id == challenge.id,
            ) ??
            false,
      ),
    );
    return Container(
      margin: const EdgeInsets.only(top: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: design.donate,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: design.onDonate.withValues(alpha: .2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Wrap(
            spacing: 12,
            runSpacing: 8,
            alignment: WrapAlignment.spaceBetween,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              Text(
                'DAILY CHALLENGE',
                style: TextStyle(
                  color: design.onDonate,
                  fontFamily: 'monospace',
                  letterSpacing: 1.2,
                  fontSize: 11,
                ),
              ),
              const _Countdown(),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            isCompleted ? "Today's challenge completed!" : challenge.title,
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 6),
          Text(
            isCompleted
                ? 'Come back tomorrow for a new challenge.'
                : 'Solve it in JavaScript or Python.',
            style: TextStyle(color: colors.onSurfaceVariant, fontSize: 13),
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 12,
            runSpacing: 4,
            crossAxisAlignment: WrapCrossAlignment.center,
            alignment: WrapAlignment.spaceBetween,
            children: [
              FilledButton(
                style: FilledButton.styleFrom(
                  backgroundColor: colors.onSurface,
                  foregroundColor: colors.surface,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                onPressed: () => LearnDailyChallengeRoute(
                  day: challenge.monthDay,
                ).push<void>(context),
                child: Text(
                  isCompleted ? 'Review challenge' : 'Start challenge',
                ),
              ),
              if (showArchiveLink)
                TextButton(
                  style: TextButton.styleFrom(foregroundColor: design.onDonate),
                  onPressed: () => const LearnDailyChallengeArchiveRoute()
                      .push<void>(context),
                  child: const Text('Past challenges'),
                ),
            ],
          ),
        ],
      ),
    );
  }
}

// NOTE: A new daily challenge unlocks at midnight US Central time.
class _Countdown extends ConsumerStatefulWidget {
  const _Countdown();

  @override
  ConsumerState<_Countdown> createState() => _CountdownState();
}

class _CountdownState extends ConsumerState<_Countdown> {
  late final Timer _timer;
  late Duration _timeLeft = _untilMidnight();

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      final next = _untilMidnight();
      final passedMidnight = next > _timeLeft;
      if (passedMidnight) ref.invalidate(dailyChallengeTodayProvider);
      setState(() => _timeLeft = next);
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  Duration _untilMidnight() {
    final chicago = tz.getLocation('America/Chicago');
    final now = tz.TZDateTime.now(chicago);
    return tz.TZDateTime(
      chicago,
      now.year,
      now.month,
      now.day + 1,
    ).difference(now);
  }

  @override
  Widget build(BuildContext context) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final timeLeft =
        '${twoDigits(_timeLeft.inHours)}:${twoDigits(_timeLeft.inMinutes % 60)}:${twoDigits(_timeLeft.inSeconds % 60)}';

    return Semantics(
      label: 'Countdown timer. Next challenge in $timeLeft',
      excludeSemantics: true,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Text(
          'New in $timeLeft',
          style: TextStyle(
            color: Theme.of(context).colorScheme.onSurfaceVariant,
            fontFamily: 'monospace',
            fontSize: 10,
          ),
        ),
      ),
    );
  }
}
