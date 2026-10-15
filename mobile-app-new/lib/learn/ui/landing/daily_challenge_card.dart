import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mobile_app_new/fcc_theme.dart';
import 'package:mobile_app_new/learn/ui/landing/landing_viewmodel.dart';
import 'package:mobile_app_new/routing/learn.dart';
import 'package:mobile_app_new/services/auth_service.dart';
import 'package:timezone/timezone.dart' as tz;

class DailyChallengeCard extends ConsumerWidget {
  const DailyChallengeCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final challenge = ref.watch(dailyChallengeTodayProvider).value;
    if (challenge == null) return const SizedBox.shrink();

    final isCompleted = ref.watch(
      authProvider.select(
        (s) =>
            s.value?.completedDailyCodingChallenges.any(
              (completed) => completed.id == challenge.id,
            ) ??
            false,
      ),
    );

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
      child: Semantics(
        label: isCompleted
            ? 'Daily challenge completed. View past challenges.'
            : 'Daily challenge card',
        container: true,
        child: Container(
          padding: const EdgeInsets.all(20),
          width: double.infinity,
          decoration: BoxDecoration(
            color: FccColors.gray10,
            borderRadius: const BorderRadius.all(Radius.circular(16)),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.10),
                blurRadius: 16,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                isCompleted
                    ? "Today's challenge completed!"
                    : "Today's challenge",
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: FccColors.gray80,
                ),
                textAlign: TextAlign.center,
              ),
              if (isCompleted) ...[
                const SizedBox(height: 14),
                const _Countdown(),
                const SizedBox(height: 14),
                _CtaButton(
                  label: 'View past challenges',
                  tooltip: 'View past daily challenges',
                  icon: Icons.history,
                  onPressed: () => const LearnDailyChallengeArchiveRoute()
                      .push<void>(context),
                ),
              ] else ...[
                const SizedBox(height: 4),
                Text(
                  challenge.title,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: FccColors.gray90,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 14),
                const Text(
                  'Do you have the skills to complete this challenge?',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 18, color: FccColors.gray85),
                ),
                const SizedBox(height: 20),
                _CtaButton(
                  label: 'Start the challenge',
                  tooltip: 'Start the daily challenge now',
                  icon: Icons.arrow_forward_ios,
                  onPressed: () => LearnDailyChallengeRoute(
                    day: challenge.monthDay,
                  ).push<void>(context),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

class _CtaButton extends StatelessWidget {
  const _CtaButton({
    required this.label,
    required this.tooltip,
    required this.icon,
    required this.onPressed,
  });

  final String label;
  final String tooltip;
  final IconData icon;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: Tooltip(
        message: tooltip,
        child: ElevatedButton.icon(
          style: ElevatedButton.styleFrom(
            backgroundColor: FccColors.yellow50,
            foregroundColor: FccColors.gray90,
            elevation: 0,
            padding: const EdgeInsets.symmetric(vertical: 14),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          onPressed: onPressed,
          icon: Icon(icon, size: 20),
          label: Text(
            label,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
        ),
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
      liveRegion: true,
      excludeSemantics: true,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Text(
          'Next challenge in: $timeLeft',
          style: const TextStyle(
            color: FccColors.gray90,
            fontWeight: FontWeight.w600,
            fontSize: 15,
          ),
        ),
      ),
    );
  }
}
