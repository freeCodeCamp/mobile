import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:jiffy/jiffy.dart';
import 'package:mobile_app_new/fcc_theme.dart';
import 'package:mobile_app_new/learn/models/daily_challenge_model.dart';
import 'package:mobile_app_new/learn/services/daily_challenge_service.dart';
import 'package:mobile_app_new/learn/ui/daily_challenge_archive/daily_challenge_archive_viewmodel.dart';
import 'package:mobile_app_new/routing/learn.dart';
import 'package:mobile_app_new/services/auth_service.dart';
import 'package:mobile_app_new/widgets/drawer/drawer.dart';
import 'package:mobile_app_new/widgets/error_retry.dart';

class DailyChallengeArchiveView extends ConsumerStatefulWidget {
  const DailyChallengeArchiveView({super.key});

  @override
  ConsumerState<DailyChallengeArchiveView> createState() =>
      _DailyChallengeArchiveViewState();
}

class _DailyChallengeArchiveViewState
    extends ConsumerState<DailyChallengeArchiveView> {
  final _toggled = <DateTime>{};

  @override
  Widget build(BuildContext context) {
    final archive = ref.watch(dailyChallengeArchiveProvider);
    final completedChallenges = ref.watch(
      authProvider.select((s) => s.value?.completedDailyCodingChallenges),
    );
    final completed = {...?completedChallenges?.map((c) => c.id)};

    return Scaffold(
      appBar: AppBar(title: const Text('Daily Coding Challenges')),
      drawer: const DrawerWidget(),
      body: archive.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => ErrorRetry(
          message: 'No challenges available at the moment.',
          onRetry: () => ref.invalidate(dailyChallengeArchiveProvider),
        ),
        data: (months) => months.isEmpty
            ? const ErrorRetry(
                message: 'No challenges available at the moment.',
              )
            : ListView.builder(
                padding: const EdgeInsets.all(8),
                itemCount: months.length,
                itemBuilder: (context, index) {
                  final month = months[index].month;

                  return _MonthCard(
                    key: ValueKey(month),
                    month: months[index],
                    completed: completed,
                    isOpen: (index == 0) != _toggled.contains(month),
                    onToggle: () => setState(() {
                      if (!_toggled.remove(month)) _toggled.add(month);
                    }),
                  );
                },
              ),
      ),
    );
  }
}

class _MonthCard extends StatelessWidget {
  const _MonthCard({
    super.key,
    required this.month,
    required this.completed,
    required this.isOpen,
    required this.onToggle,
  });

  final DailyChallengeMonth month;
  final Set<String> completed;
  final bool isOpen;
  final VoidCallback onToggle;

  @override
  Widget build(BuildContext context) {
    final challenges = month.challenges;
    final done = challenges.where((c) => completed.contains(c.id)).length;
    final jiffy = Jiffy.parseFromDateTime(month.month);

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: FccColors.gray75),
        color: FccColors.gray85,
      ),
      padding: const EdgeInsets.all(8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Padding(
                padding: EdgeInsets.all(8),
                child: Icon(
                  Icons.calendar_today,
                  color: FccColors.gray00,
                  size: 30,
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(8),
                  child: Text(
                    jiffy.format(pattern: 'MMMM'),
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: FccColors.gray00,
                    ),
                  ),
                ),
              ),
            ],
          ),
          if (done == challenges.length)
            const Padding(
              padding: EdgeInsets.all(8),
              child: Row(
                children: [
                  Padding(
                    padding: EdgeInsets.only(right: 8),
                    child: Icon(Icons.check_circle, color: FccColors.blue30),
                  ),
                  Text(
                    'Completed',
                    style: TextStyle(
                      color: FccColors.blue30,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            )
          else
            Padding(
              padding: const EdgeInsets.all(10),
              child: LinearProgressIndicator(
                minHeight: 12,
                value: done == 0 ? 0.01 : done / challenges.length,
                valueColor: const AlwaysStoppedAnimation<Color>(
                  FccColors.blue30,
                ),
                backgroundColor: FccColors.gray80,
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4),
            child: Text(
              'Explore the daily coding challenges for ${jiffy.format(pattern: 'MMMM')}. '
              'Stay motivated and keep your learning streak alive!',
              style: const TextStyle(fontSize: 20, color: FccColors.gray05),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8),
            child: TextButton(
              onPressed: onToggle,
              style: TextButton.styleFrom(
                backgroundColor: FccColors.gray85,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5),
                  side: const BorderSide(color: FccColors.gray75),
                ),
              ),
              child: Text(isOpen ? 'Hide Challenges' : 'Show Challenges'),
            ),
          ),
          if (isOpen)
            for (final challenge in challenges)
              _ChallengeItem(
                challenge: challenge,
                isCompleted: completed.contains(challenge.id),
              ),
        ],
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
    final title = 'Challenge ${challenge.challengeNumber}: ${challenge.title}';

    return Semantics(
      label: '$title, ${isCompleted ? 'completed' : 'not completed'}',
      button: true,
      excludeSemantics: true,
      child: Card(
        margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        clipBehavior: Clip.antiAlias,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(5),
          side: BorderSide(
            color: isCompleted ? FccColors.blue10 : FccColors.gray75,
          ),
        ),
        color: isCompleted ? FccColors.blue90Translucent : FccColors.gray80,
        child: InkWell(
          onTap: () => LearnDailyChallengeRoute(
            day: challenge.monthDay,
          ).push<void>(context),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                if (isCompleted)
                  const Padding(
                    padding: EdgeInsets.only(right: 8),
                    child: Icon(
                      Icons.check_circle,
                      color: FccColors.blue10,
                      size: 20,
                    ),
                  ),
                Expanded(
                  child: Text(title, style: const TextStyle(fontSize: 18)),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
