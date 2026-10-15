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
import 'package:mobile_app_new/routing/auth.dart';
import 'package:mobile_app_new/routing/learn.dart';
import 'package:mobile_app_new/services/auth_service.dart';
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
    final username = ref.watch(authProvider.select((s) => s.value?.username));
    final first = stages.value
        ?.expand((s) => s.superBlocks)
        .where((s) => s.isPublic)
        .firstOrNull;
    return Scaffold(
      appBar: AppBar(title: const Text('Learn')),
      drawer: const DrawerWidget(),
      body: RefreshIndicator(
        onRefresh: () => _refresh(ref),
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 32),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              if (first != null)
                _StartCard(
                  course: first,
                  onPressed: () => _openSuperBlock(context, first),
                ),
              if (username == null)
                Align(
                  alignment: Alignment.center,
                  child: TextButton(
                    onPressed: () => const LoginRoute().push<void>(context),
                    child: const Text('Sign in to save your progress'),
                  ),
                ),
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
      colors.tertiary,
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
        style: Theme.of(context).textTheme.titleMedium,
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
                    : null,
                onPressed: () => _openSuperBlock(context, superBlock),
              ),
            ],
          ],
        ),
      ),
      if (stage.key == 'core') ...[
        const SizedBox(height: 16),
        Card(
          clipBehavior: Clip.antiAlias,
          child: SuperBlockButton(
            title: 'Daily challenge archive',
            icon: Icons.calendar_today_outlined,
            color: colors.tertiary,
            onPressed: () =>
                const LearnDailyChallengeArchiveRoute().push<void>(context),
          ),
        ),
      ],
    ];
  }

  void _openSuperBlock(BuildContext context, SuperBlockSummary superBlock) {
    if (superBlock.isPublic) {
      LearnSuperBlockRoute(
        superBlock: superBlock.dashedName,
      ).push<void>(context);
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

class _StartCard extends StatelessWidget {
  const _StartCard({required this.course, required this.onPressed});
  final SuperBlockSummary course;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.all(18),
    decoration: BoxDecoration(
      color: FccDesignColors.of(context).hero,
      borderRadius: BorderRadius.circular(18),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const LearnEyebrow('Build your skills', color: Color(0xFFFFF8EC)),
        const SizedBox(height: 8),
        Text(
          course.title,
          style: const TextStyle(
            color: Color(0xFFFFF8EC),
            fontSize: 22,
            fontWeight: FontWeight.w800,
            height: 1.2,
          ),
        ),
        const SizedBox(height: 8),
        const Text(
          'Learn by building, one step at a time.',
          style: TextStyle(color: Color(0xFFFFF8EC), fontSize: 14),
        ),
        const SizedBox(height: 16),
        FilledButton.icon(
          style: FilledButton.styleFrom(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          onPressed: onPressed,
          iconAlignment: IconAlignment.end,
          icon: const Icon(Icons.arrow_forward, size: 18),
          label: const Text('Explore course'),
        ),
      ],
    ),
  );
}
