import 'package:mobile_app_new/learn/ui/landing/learning_resume.dart';
import 'package:mobile_app_new/learn/ui/widgets/learning_website.dart';
import 'package:mobile_app_new/widgets/app_page_title.dart';
import 'package:mobile_app_new/widgets/app_bottom_navigation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mobile_app_new/fcc_theme.dart';
import 'package:mobile_app_new/learn/constants/curriculum.dart';
import 'package:mobile_app_new/learn/controllers/curriculum_controller.dart';
import 'package:mobile_app_new/learn/models/curriculum_model.dart';
import 'package:mobile_app_new/learn/services/curriculum_service.dart';
import 'package:mobile_app_new/learn/ui/landing/daily_challenge_card.dart';
import 'package:mobile_app_new/learn/ui/landing/landing_viewmodel.dart';
import 'package:mobile_app_new/learn/ui/landing/superblock_button.dart';
import 'package:mobile_app_new/learn/ui/widgets/learn_presentation.dart';
import 'package:mobile_app_new/routing/learn.dart';
import 'package:mobile_app_new/widgets/drawer/drawer.dart';
import 'package:mobile_app_new/widgets/error_retry.dart';

class LearnLandingView extends ConsumerWidget {
  const LearnLandingView({super.key});

  Future<void> _refresh(WidgetRef ref) => Future.wait([
    ref.refresh(curriculumStagesProvider.future),
    ref.refresh(dailyChallengeTodayProvider.future),
  ]).then((_) {}, onError: (_) {});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final stages = ref.watch(curriculumStagesProvider);
    final first = stages.value
        ?.expand((s) => s.superBlocks)
        .where((s) => s.isPublic)
        .firstOrNull;
    return Scaffold(
      bottomNavigationBar: const AppNavigationFooter(
        selected: AppDestination.learn,
      ),
      appBar: AppBar(
        title: const AppPageTitle('Courses'),
        toolbarHeight: AppPageTitle.toolbarHeight(context),
      ),
      drawer: const DrawerWidget(),
      body: RefreshIndicator(
        onRefresh: () => _refresh(ref),
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 32),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              if (first != null) _ResumeCard(course: first),
              const DailyChallengeCard(),
              ...switch (stages) {
                AsyncData(:final value) => [
                  for (final stage in value) ..._stage(context, stage),
                ],
                AsyncError() => [
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 32),
                    child: ErrorRetry(
                      message:
                          'Could not load the curriculum. Please try again.',
                      onRetry: () => _refresh(ref),
                    ),
                  ),
                ],
                _ => [
                  const Padding(
                    padding: EdgeInsets.all(32),
                    child: Center(child: CircularProgressIndicator()),
                  ),
                ],
              },
            ],
          ),
        ),
      ),
    );
  }

  List<Widget> _stage(BuildContext context, CurriculumStage stage) {
    final colors = Theme.of(context).colorScheme;
    final accents = [
      FccDesignColors.of(context).accentText,
      Theme.of(context).brightness == Brightness.dark
          ? colors.secondary
          : const Color(0xFF9C6B00),
      blockLabelColor(context, BlockLabel.lecture),
      FccDesignColors.of(context).success,
      blockLabelColor(context, BlockLabel.workshop),
      blockLabelColor(context, BlockLabel.quiz),
    ];
    return [
      const SizedBox(height: 24),
      Text(
        stage.title.replaceAll(RegExp(r':$'), ''),
        style: Theme.of(context).textTheme.titleMedium?.copyWith(
          fontSize: 18,
          fontWeight: FontWeight.w800,
        ),
      ),
      const SizedBox(height: 8),
      Card(
        clipBehavior: Clip.antiAlias,
        child: Column(
          children: [
            for (final (index, superBlock) in stage.superBlocks.indexed) ...[
              if (index != 0) const Divider(),
              SuperBlockButton(
                key: ValueKey(superBlock.dashedName),
                title: superBlock.title,
                color: accents[index % accents.length],
                svgAsset:
                    superBlockIcons[superBlock.dashedName] ??
                    defaultSuperBlockIcon,
                isEnabled: superBlock.isPublic,
                subtitle: superBlock.isDisabledByOverride
                    ? 'Temporarily unavailable'
                    : !superBlock.isPublic
                    ? 'Opens freecodecamp.org'
                    : null,
                isExternal:
                    !superBlock.isPublic && !superBlock.isDisabledByOverride,
                onPressed: () => _openSuperBlock(context, superBlock),
              ),
            ],
          ],
        ),
      ),
    ];
  }

  void _openSuperBlock(BuildContext context, SuperBlockSummary superBlock) {
    if (superBlock.isPublic) {
      LearnSuperBlockRoute(
        superBlock: superBlock.dashedName,
      ).push<void>(context);
    } else if (!superBlock.isDisabledByOverride) {
      openLearningWebsite(context, superBlock.dashedName);
    } else {
      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(
          SnackBar(
            content: Text(
              superBlock.isDisabledByOverride
                  ? 'Temporarily unavailable, come back soon.'
                  : 'Not available, use the web version',
            ),
          ),
        );
    }
  }
}

class _ResumeCard extends ConsumerWidget {
  const _ResumeCard({required this.course});
  final SuperBlockSummary course;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final resume = ref.watch(learningResumeProvider);
    final next = resume.value;
    final returning = next?.isReturning ?? false;
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: FccDesignColors.of(context).hero,
        borderRadius: BorderRadius.circular(16),
      ),
      child: DefaultTextStyle.merge(
        style: const TextStyle(color: Color(0xFFFFF8EC)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              next?.course.title ?? course.title,
              style: const TextStyle(fontSize: 14, height: 1.4),
            ),
            if (next != null) ...[
              Text(
                next.block.name,
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w800,
                  height: 1.25,
                ),
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: SizedBox(
                      height: 8,
                      child: LearnProgress(
                        done: next.completed,
                        total: next.block.challenges.length,
                        color: Theme.of(context).colorScheme.secondary,
                        backgroundColor: Colors.white24,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    '${next.completed} of ${next.block.challenges.length} steps',
                    style: const TextStyle(fontSize: 14),
                  ),
                ],
              ),
            ] else if (resume.isLoading) ...[
              const Text('Finding your next step…'),
              const SizedBox(height: 12),
              LinearProgressIndicator(
                color: Theme.of(context).colorScheme.secondary,
                backgroundColor: Colors.white24,
                semanticsLabel: 'Loading your next step',
              ),
            ] else
              Text(
                resume.hasError
                    ? 'Could not load your next step.'
                    : 'Explore the curriculum to keep learning.',
              ),
            const SizedBox(height: 16),
            FilledButton.icon(
              style: FilledButton.styleFrom(
                textStyle: const TextStyle(
                  fontFamily: 'Lato',
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              onPressed: resume.isLoading
                  ? null
                  : next != null
                  ? () => LearnChallengeRoute(
                      superBlock: next.block.superBlock,
                      block: next.block.dashedName,
                      challengeId: next.challenge.id,
                    ).push<void>(context)
                  : resume.hasError
                  ? () => retryLearningResume(ref)
                  : () => LearnSuperBlockRoute(
                      superBlock: course.dashedName,
                    ).push<void>(context),
              iconAlignment: IconAlignment.end,
              icon: const Icon(Icons.arrow_forward, size: 18),
              label: Text(
                next != null
                    ? '${returning ? 'Continue' : 'Start'} ${blockUnit(next.block)} ${next.step}'
                    : resume.hasError
                    ? 'Try again'
                    : 'Explore course',
              ),
            ),
          ],
        ),
      ),
    );
  }
}
