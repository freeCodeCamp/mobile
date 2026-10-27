import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:freecodecamp/fcc_theme.dart';
import 'package:freecodecamp/learn/ui/landing/landing_viewmodel.dart';
import 'package:freecodecamp/routing/learn.dart';
import 'package:freecodecamp/services/auth_service.dart';
import 'package:timezone/timezone.dart' as tz;

class DailyChallengeCard extends ConsumerStatefulWidget {
  const DailyChallengeCard({super.key, this.showArchiveLink = true});
  final bool showArchiveLink;

  @override
  ConsumerState<DailyChallengeCard> createState() => _DailyChallengeCardState();
}

class _DailyChallengeCardState extends ConsumerState<DailyChallengeCard> {
  Timer? _refreshTimer;
  bool get showArchiveLink => widget.showArchiveLink;

  @override
  void initState() {
    super.initState();
    _scheduleRefresh();
  }

  void _scheduleRefresh() {
    // A new challenge unlocks at midnight US Central time. Keep this refresh
    // without displaying a countdown or rebuilding the card every second.
    final chicago = tz.getLocation('America/Chicago');
    final now = tz.TZDateTime.now(chicago);
    final midnight = tz.TZDateTime(chicago, now.year, now.month, now.day + 1);
    _refreshTimer = Timer(midnight.difference(now), () {
      if (!mounted) return;
      ref.invalidate(dailyChallengeTodayProvider);
      _scheduleRefresh();
    });
  }

  @override
  void dispose() {
    _refreshTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final today = ref.watch(dailyChallengeTodayProvider);
    final challenge = today.value;
    if (challenge == null) {
      return Container(
        margin: const EdgeInsets.only(top: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: colors.surface,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: colors.outlineVariant),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Daily challenge',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 12),
            if (today.hasError) ...[
              const Text('Could not load today’s challenge.'),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                children: [
                  OutlinedButton(
                    onPressed: () =>
                        ref.invalidate(dailyChallengeTodayProvider),
                    child: const Text('Try again'),
                  ),
                  if (showArchiveLink) const _ArchiveLink(),
                ],
              ),
            ] else ...[
              const Text('Loading today’s challenge…'),
              const SizedBox(height: 12),
              const LinearProgressIndicator(
                semanticsLabel: 'Loading daily challenge',
              ),
            ],
          ],
        ),
      );
    }
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
        color: colors.surface,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: colors.outlineVariant),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            'Daily challenge',
            style: TextStyle(
              color: colors.onSurface,
              fontFamily: 'Lato',
              letterSpacing: 0,
              fontSize: 11,
              fontWeight: FontWeight.w600,
              height: 1.2,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            isCompleted ? "Today's challenge completed!" : challenge.title,
            style: TextStyle(
              color: colors.onSurface,
              fontSize: 20,
              fontWeight: FontWeight.w700,
              height: 1.25,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            isCompleted
                ? 'Come back tomorrow for a new challenge.'
                : 'Solve it in JavaScript or Python.',
            style: TextStyle(
              color: colors.onSurfaceVariant,
              fontSize: 14,
              height: 1.45,
            ),
          ),
          const SizedBox(height: 8),
          LayoutBuilder(
            builder: (context, constraints) {
              final button = FilledButton(
                style: FilledButton.styleFrom(
                  minimumSize: const Size(48, 44),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 10,
                  ),
                  textStyle: const TextStyle(
                    fontFamily: 'Lato',
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    height: 1.25,
                  ),
                  backgroundColor: colors.secondary,
                  foregroundColor: colors.onSecondary,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                onPressed: () => LearnDailyChallengeRoute(
                  day: challenge.monthDay,
                ).push<void>(context),
                child: Text(
                  isCompleted ? 'Review challenge' : 'Start challenge',
                  textAlign: TextAlign.center,
                ),
              );
              // Give the primary action the remaining row width. At narrow
              // widths or large text, stack instead of squeezing either label.
              if (!showArchiveLink ||
                  constraints.maxWidth < 300 ||
                  MediaQuery.textScalerOf(context).scale(16) > 20) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    button,
                    if (showArchiveLink) ...[
                      const SizedBox(height: 4),
                      const Align(
                        alignment: Alignment.centerRight,
                        child: _ArchiveLink(),
                      ),
                    ],
                  ],
                );
              }
              return Row(
                children: [
                  Expanded(child: button),
                  const SizedBox(width: 12),
                  const _ArchiveLink(),
                ],
              );
            },
          ),
        ],
      ),
    );
  }
}

class _ArchiveLink extends StatelessWidget {
  const _ArchiveLink();

  @override
  Widget build(BuildContext context) => TextButton(
    style: TextButton.styleFrom(
      foregroundColor: FccDesignColors.of(context).accentText,
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
      textStyle: const TextStyle(
        fontFamily: 'Lato',
        fontSize: 16,
        fontWeight: FontWeight.w600,
        decoration: TextDecoration.underline,
      ),
    ),
    onPressed: () =>
        const LearnDailyChallengeArchiveRoute().push<void>(context),
    child: const Text(
      'Past challenges',
      style: TextStyle(decoration: TextDecoration.underline),
    ),
  );
}
