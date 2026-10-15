import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart' show GoRouterHelper;
import 'package:mobile_app_new/fcc_theme.dart';
import 'package:mobile_app_new/learn/models/challenge_model.dart';
import 'package:mobile_app_new/learn/models/curriculum_model.dart';
import 'package:mobile_app_new/learn/ui/challenge/challenge_viewmodel.dart';
import 'package:mobile_app_new/learn/ui/challenge/widgets/challenge_button.dart';
import 'package:mobile_app_new/routing/learn.dart';

class CompleteButton extends ConsumerWidget {
  const CompleteButton({
    super.key,
    required this.challenge,
    required this.block,
    required this.label,
    this.solution,
    this.enabled = true,
  });

  final Challenge challenge;
  final Block block;
  final String label;
  final String? solution;
  final bool enabled;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final provider = challengeSubmitProvider(challenge.id);
    final submit = ref.watch(provider);

    return Column(
      children: [
        if (submit.hasError)
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: Text(
              'Your progress could not be saved. Check your connection and try again.',
              style: TextStyle(fontSize: 16, color: FccColors.red15),
            ),
          ),
        ChallengeButton(
          label: label,
          loading: submit.isLoading,
          onPressed: !enabled
              ? null
              : () async {
                  final saved = await ref
                      .read(provider.notifier)
                      .submit(challenge, solution: solution);
                  if (saved && context.mounted) _goToNext(context);
                },
        ),
      ],
    );
  }

  void _goToNext(BuildContext context) {
    final index = block.challenges.indexWhere((c) => c.id == challenge.id);
    if (index == -1 || index == block.challenges.length - 1) {
      context.pop();
      return;
    }

    LearnChallengeRoute(
      superBlock: block.superBlock,
      block: block.dashedName,
      challengeId: block.challenges[index + 1].id,
    ).pushReplacement(context);
  }
}
