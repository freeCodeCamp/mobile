import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:freecodecamp/fcc_theme.dart';
import 'package:freecodecamp/learn/models/daily_challenge_model.dart';
import 'package:freecodecamp/learn/services/daily_challenge_service.dart';
import 'package:freecodecamp/learn/ui/daily_challenge_archive/daily_challenge_archive_viewmodel.dart';
import 'package:freecodecamp/learn/ui/landing/daily_challenge_card.dart';
import 'package:freecodecamp/learn/ui/widgets/learn_presentation.dart';
import 'package:freecodecamp/routing/learn.dart';
import 'package:freecodecamp/services/auth_service.dart';
import 'package:freecodecamp/widgets/app_bottom_navigation.dart';
import 'package:freecodecamp/widgets/error_retry.dart';
import 'package:jiffy/jiffy.dart';

enum _Filter {
  all('All'),
  pending('Not done yet'),
  complete('Done');

  const _Filter(this.label);
  final String label;
}

class DailyChallengeArchiveView extends ConsumerStatefulWidget {
  const DailyChallengeArchiveView({super.key});
  @override
  ConsumerState<DailyChallengeArchiveView> createState() =>
      _DailyChallengeArchiveViewState();
}

class _DailyChallengeArchiveViewState
    extends ConsumerState<DailyChallengeArchiveView> {
  final _toggled = <DateTime>{};
  _Filter _filter = _Filter.all;

  @override
  Widget build(BuildContext context) {
    final archive = ref.watch(dailyChallengeArchiveProvider);
    final completed = ref.watch(
      authProvider.select(
        (s) => {...?s.value?.completedDailyCodingChallenges.map((c) => c.id)},
      ),
    );
    return Scaffold(
      bottomNavigationBar: const AppNavigationFooter(
        selected: AppDestination.learn,
      ),
      appBar: AppBar(title: const Text('Daily coding challenges')),
      body: archive.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => ErrorRetry(
          message: 'No challenges available at the moment.',
          onRetry: () => ref.invalidate(dailyChallengeArchiveProvider),
        ),
        data: (months) {
          bool matches(DailyChallengeOverview challenge) => switch (_filter) {
            _Filter.all => true,
            _Filter.pending => !completed.contains(challenge.id),
            _Filter.complete => completed.contains(challenge.id),
          };
          final shown = months.where((m) => m.challenges.any(matches)).toList();
          return ListView(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 32),
            children: [
              const DailyChallengeCard(showArchiveLink: false),
              const SizedBox(height: 16),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  for (final filter in _Filter.values)
                    ChoiceChip(
                      label: Text(filter.label),
                      showCheckmark: false,
                      labelStyle: TextStyle(
                        color: _filter == filter
                            ? Theme.of(context).colorScheme.onPrimary
                            : Theme.of(context).colorScheme.onSurface,
                      ),
                      selected: _filter == filter,
                      onSelected: (_) => setState(() => _filter = filter),
                    ),
                ],
              ),
              const SizedBox(height: 16),
              if (shown.isEmpty)
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 32),
                  child: Text(
                    _filter == _Filter.complete
                        ? 'No completed challenges yet.'
                        : _filter == _Filter.pending
                        ? 'You have completed every challenge in the archive.'
                        : 'No challenges available at the moment.',
                    textAlign: TextAlign.center,
                  ),
                ),
              for (final (index, month) in shown.indexed)
                _MonthCard(
                  key: ValueKey(month.month),
                  month: month,
                  visible: month.challenges.where(matches).toList(),
                  completed: completed,
                  isOpen: (index == 0) != _toggled.contains(month.month),
                  onToggle: () => setState(() {
                    if (!_toggled.remove(month.month)) {
                      _toggled.add(month.month);
                    }
                  }),
                ),
            ],
          );
        },
      ),
    );
  }
}

class _MonthCard extends StatelessWidget {
  const _MonthCard({
    super.key,
    required this.month,
    required this.visible,
    required this.completed,
    required this.isOpen,
    required this.onToggle,
  });
  final DailyChallengeMonth month;
  final List<DailyChallengeOverview> visible;
  final Set<String> completed;
  final bool isOpen;
  final VoidCallback onToggle;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final done = month.challenges.where((c) => completed.contains(c.id)).length;
    final allDone =
        month.challenges.isNotEmpty && done == month.challenges.length;
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Card(
        clipBehavior: Clip.antiAlias,
        child: Column(
          children: [
            InkWell(
              onTap: onToggle,
              child: Semantics(
                button: true,
                expanded: isOpen,
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              Jiffy.parseFromDateTime(
                                month.month,
                              ).format(pattern: 'MMMM'),
                              style: Theme.of(context).textTheme.titleLarge,
                            ),
                            Text(
                              allDone
                                  ? 'All done'
                                  : '$done of ${month.challenges.length} done',
                              style: TextStyle(
                                color: allDone
                                    ? FccDesignColors.of(context).success
                                    : colors.onSurfaceVariant,
                                fontSize: 13,
                              ),
                            ),
                            const SizedBox(height: 8),
                            LearnProgress(
                              done: done,
                              total: month.challenges.length,
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 16),
                      Icon(
                        isOpen ? Icons.expand_less : Icons.expand_more,
                        color: colors.onSurfaceVariant,
                      ),
                    ],
                  ),
                ),
              ),
            ),
            if (isOpen)
              for (final challenge in visible) ...[
                const Divider(),
                _ChallengeItem(
                  challenge: challenge,
                  isCompleted: completed.contains(challenge.id),
                ),
              ],
          ],
        ),
      ),
    );
  }
}

class _ChallengeItem extends StatelessWidget {
  const _ChallengeItem({required this.challenge, required this.isCompleted});
  final DailyChallengeOverview challenge;
  final bool isCompleted;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return Semantics(
      label:
          '${challenge.title}, ${isCompleted ? 'completed' : 'not completed'}',
      button: true,
      excludeSemantics: true,
      child: InkWell(
        onTap: () => LearnDailyChallengeRoute(
          day: challenge.monthDay,
        ).push<void>(context),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              if (isCompleted)
                const LearnStatus(complete: true)
              else
                CircleAvatar(
                  radius: 14,
                  backgroundColor: colors.surfaceContainer,
                  child: Icon(
                    Icons.add,
                    size: 16,
                    color: colors.onSurfaceVariant,
                  ),
                ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    LearnEyebrow(
                      '#${challenge.challengeNumber} · ${Jiffy.parseFromDateTime(challenge.date).format(pattern: 'MMM d')}',
                    ),
                    const SizedBox(height: 4),
                    Text(
                      challenge.title,
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              Icon(
                Icons.chevron_right,
                color: colors.onSurfaceVariant,
                size: 22,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
