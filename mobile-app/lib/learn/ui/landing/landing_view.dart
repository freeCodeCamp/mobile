import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:freecodecamp/fcc_theme.dart';
import 'package:freecodecamp/learn/constants/curriculum.dart';
import 'package:freecodecamp/learn/controllers/curriculum_controller.dart';
import 'package:freecodecamp/learn/models/curriculum_model.dart';
import 'package:freecodecamp/learn/services/curriculum_service.dart';
import 'package:freecodecamp/learn/ui/landing/daily_challenge_card.dart';
import 'package:freecodecamp/learn/ui/landing/landing_viewmodel.dart';
import 'package:freecodecamp/learn/ui/landing/learning_resume.dart';
import 'package:freecodecamp/learn/ui/landing/superblock_button.dart';
import 'package:freecodecamp/learn/ui/widgets/learn_presentation.dart';
import 'package:freecodecamp/learn/ui/widgets/learning_website.dart';
import 'package:freecodecamp/routing/auth.dart';
import 'package:freecodecamp/routing/learn.dart';
import 'package:freecodecamp/services/auth_service.dart';
import 'package:freecodecamp/widgets/app_bottom_navigation.dart';
import 'package:freecodecamp/widgets/app_page_title.dart';
import 'package:freecodecamp/widgets/error_retry.dart';

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
        automaticallyImplyLeading: false,
        title: const AppPageTitle('Courses'),
        toolbarHeight: AppPageTitle.toolbarHeight(context),
      ),
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
                  for (final stage in value) ..._stage(context, ref, stage),
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
                _ => [const CoursesSkeleton()],
              },
            ],
          ),
        ),
      ),
    );
  }

  List<Widget> _stage(
    BuildContext context,
    WidgetRef ref,
    CurriculumStage stage,
  ) {
    final returning =
        ref.watch(learningResumeProvider).value?.isReturning ?? false;
    return [
      const SizedBox(height: 24),
      Text(
        stage.title.replaceAll(RegExp(r':$'), ''),
        style: Theme.of(context).textTheme.titleMedium?.copyWith(
          fontSize: 20,
          fontWeight: FontWeight.w900,
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
                iconAsset:
                    superBlockIcons[superBlock.dashedName] ??
                    defaultSuperBlockIcon,
                isEnabled: superBlock.isPublic,
                subtitle: superBlock.isDisabledByOverride
                    ? 'Temporarily unavailable'
                    : !superBlock.isPublic
                    ? 'Opens freecodecamp.org'
                    : superBlock.dashedName.contains('responsive-web-design')
                    ? returning
                          ? 'In progress'
                          : 'Start here'
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
    final guest = !ref.watch(authProvider).isLoggedIn;
    if (guest && !returning) {
      return FirstVisitHero(
        course: course,
        next: next,
        loading: resume.isLoading,
        onStart: next == null
            ? () => LearnSuperBlockRoute(
                superBlock: course.dashedName,
              ).push<void>(context)
            : () => LearnChallengeRoute(
                superBlock: next.block.superBlock,
                block: next.block.dashedName,
                challengeId: next.challenge.id,
              ).push<void>(context),
        onSignIn: () => const LoginRoute().push<void>(context),
      );
    }
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: FccDesignColors.of(context).hero,
        borderRadius: BorderRadius.circular(16),
        boxShadow: const [
          BoxShadow(
            color: Color(0x59000000),
            offset: Offset(0, 6),
            blurRadius: 18,
          ),
        ],
      ),
      child: DefaultTextStyle.merge(
        style: TextStyle(color: FccDesignColors.of(context).heroForeground),
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
                  fontSize: 20,
                  fontWeight: FontWeight.w900,
                  height: 1.25,
                ),
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: SizedBox(
                      height: 6,
                      child: LearnProgress(
                        done: next.completed,
                        total: next.block.challenges.length,
                        color: Colors.white,
                        backgroundColor: Colors.white.withValues(alpha: .30),
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
                  fontSize: 17,
                  fontWeight: FontWeight.w900,
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

class FirstVisitHero extends StatelessWidget {
  const FirstVisitHero({
    super.key,
    required this.course,
    required this.next,
    required this.loading,
    required this.onStart,
    required this.onSignIn,
  });
  final SuperBlockSummary course;
  final LearningResume? next;
  final bool loading;
  final VoidCallback onStart;
  final VoidCallback onSignIn;

  @override
  Widget build(BuildContext context) {
    final design = FccDesignColors.of(context);
    return Container(
      decoration: BoxDecoration(
        color: design.hero,
        borderRadius: BorderRadius.circular(16),
        boxShadow: const [
          BoxShadow(
            color: Color(0x59000000),
            offset: Offset(0, 6),
            blurRadius: 18,
          ),
        ],
      ),
      child: DefaultTextStyle.merge(
        style: TextStyle(color: design.heroForeground),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const Text('New here? Start here'),
                  const SizedBox(height: 8),
                  const Text(
                    'Learn to code for free, one short hands-on step at a time.',
                  ),
                  const SizedBox(height: 16),
                  Text(
                    course.title,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w900,
                      height: 1.25,
                    ),
                  ),
                  const SizedBox(height: 8),
                  if (next != null)
                    Text(
                      'First up: ${next!.block.name} · ${next!.block.challenges.length} steps',
                    )
                  else if (loading)
                    const Text('Getting your courses ready…'),
                  const SizedBox(height: 16),
                  FilledButton.icon(
                    onPressed: loading ? null : onStart,
                    style: FilledButton.styleFrom(
                      textStyle: const TextStyle(
                        fontFamily: 'Lato',
                        fontSize: 17,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    iconAlignment: IconAlignment.end,
                    icon: const Icon(Icons.arrow_forward),
                    label: const Text('Start learning'),
                  ),
                ],
              ),
            ),
            Container(
              decoration: BoxDecoration(
                border: Border(
                  top: BorderSide(
                    color: design.heroForeground.withValues(alpha: .3),
                  ),
                ),
              ),
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const Text(
                    'Already learning? Sign in to pick up where you left off.',
                  ),
                  const SizedBox(height: 8),
                  OutlinedButton(
                    onPressed: onSignIn,
                    style:
                        OutlinedButton.styleFrom(
                          foregroundColor: Colors.white,
                          side: const BorderSide(
                            color: Colors.white,
                            width: 1.5,
                          ),
                        ).copyWith(
                          shape: FccTheme.focusShape(
                            context,
                            color: Colors.white,
                          ),
                        ),
                    child: const Text('Sign in'),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class CoursesSkeleton extends StatelessWidget {
  const CoursesSkeleton({super.key});
  @override
  Widget build(BuildContext context) {
    final fill = Theme.of(context).colorScheme.surfaceContainer;
    return Semantics(
      liveRegion: true,
      label: 'Getting your courses ready…',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Text('Getting your courses ready…'),
          const SizedBox(height: 16),
          ExcludeSemantics(
            child: Column(
              children: [
                Container(
                  height: 190,
                  decoration: BoxDecoration(
                    color: fill,
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
                const SizedBox(height: 24),
                for (var i = 0; i < 4; i++)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 16),
                    child: Row(
                      children: [
                        Container(
                          width: 44,
                          height: 44,
                          decoration: BoxDecoration(
                            color: fill,
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(child: Container(height: 18, color: fill)),
                      ],
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
