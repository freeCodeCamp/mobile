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
import 'package:mobile_app_new/routing/auth.dart';
import 'package:mobile_app_new/routing/learn.dart';
import 'package:mobile_app_new/services/auth_service.dart';
import 'package:mobile_app_new/widgets/drawer/drawer.dart';
import 'package:mobile_app_new/widgets/error_retry.dart';

class LearnLandingView extends ConsumerWidget {
  const LearnLandingView({super.key});

  // NOTE: Errors are swallowed because each provider renders its own error state.
  Future<void> _refresh(WidgetRef ref) => Future.wait([
    ref.refresh(curriculumStagesProvider.future),
    ref.refresh(dailyChallengeTodayProvider.future),
  ]).then((_) {}, onError: (_) {});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final stages = ref.watch(curriculumStagesProvider);
    final username = ref.watch(authProvider.select((s) => s.value?.username));

    return Scaffold(
      backgroundColor: FccColors.gray90,
      appBar: AppBar(title: const Text('LEARN')),
      drawer: const DrawerWidget(),
      body: RefreshIndicator(
        backgroundColor: FccColors.gray90,
        color: Colors.white,
        onRefresh: () => _refresh(ref),
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.all(4),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 32),
              if (username != null)
                Text(
                  'Welcome back, ${username.startsWith('fcc') ? 'User' : username}',
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 20,
                  ),
                ),
              const _Quote(),
              if (username == null) const _LoginButton(),
              const DailyChallengeCard(),
              ...switch (stages) {
                AsyncData(:final value) => [
                  for (final stage in value) ..._stage(context, stage),
                ],
                AsyncError() => [
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 64),
                    child: ErrorRetry(
                      message:
                          'Oops! Something went wrong. Please try again in a moment.',
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
    return [
      Text(stage.title, style: const TextStyle(fontSize: 21)),
      for (final superBlock in stage.superBlocks)
        SuperBlockButton(
          key: ValueKey(superBlock.dashedName),
          title: superBlock.title,
          svgAsset:
              superBlockIcons[superBlock.dashedName] ?? defaultSuperBlockIcon,
          isEnabled: superBlock.isPublic,
          onPressed: () => _openSuperBlock(context, superBlock),
        ),
      // NOTE: The daily challenge archive sits after the core curriculum.
      if (stage.key == 'core') ...[
        const Text(
          'A year of coding challenges',
          style: TextStyle(fontSize: 21),
        ),
        SuperBlockButton(
          title: 'View challenge archive',
          icon: Icons.calendar_today,
          onPressed: () =>
              const LearnDailyChallengeArchiveRoute().push<void>(context),
        ),
      ],
    ];
  }

  void _openSuperBlock(BuildContext context, SuperBlockSummary superBlock) {
    if (superBlock.isPublic) {
      LearnSuperBlockRoute(
        superBlock: superBlock.dashedName,
      ).push<void>(context);
      return;
    }

    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text(
            superBlock.isDisabledByOverride
                ? 'Temporarily unavailable, come back soon.'
                : 'Not available, use the web version',
          ),
          duration: const Duration(milliseconds: 2500),
        ),
      );
  }
}

class _LoginButton extends StatelessWidget {
  const _LoginButton();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: FccColors.yellow50,
          minimumSize: const Size.fromHeight(50),
          shape: const RoundedRectangleBorder(),
        ),
        onPressed: () => const LoginRoute().push<void>(context),
        child: const Padding(
          padding: EdgeInsets.all(8),
          child: Text(
            'Sign in to save your progress',
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.black, fontSize: 20),
          ),
        ),
      ),
    );
  }
}

class _Quote extends ConsumerWidget {
  const _Quote();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final quote = ref.watch(motivationalQuoteProvider).value;
    if (quote == null) return const SizedBox.shrink();

    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          Text(
            '"${quote.quote}"',
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 18),
          ),
          Padding(
            padding: const EdgeInsets.all(8),
            child: Text(
              '- ${quote.author}',
              style: const TextStyle(fontStyle: FontStyle.italic, fontSize: 18),
            ),
          ),
        ],
      ),
    );
  }
}
