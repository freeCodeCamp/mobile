import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
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
    this.buttonStyle,
    this.trailingIcon,
  });

  final Challenge challenge;
  final Block? block;
  final String label;
  final String? solution;
  final bool enabled;
  final ButtonStyle? buttonStyle;
  final IconData? trailingIcon;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final provider = challengeSubmitProvider(challenge.id);
    final submit = ref.watch(provider);

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (submit.hasError)
          Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: Text(
              'Your progress could not be saved. Check your connection and try again.',
              style: TextStyle(
                fontSize: 14,
                color: Theme.of(context).colorScheme.error,
              ),
            ),
          ),
        ChallengeButton(
          label: label,
          style: buttonStyle,
          trailingIcon: trailingIcon,
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
    final block = this.block;
    final index =
        block?.challenges.indexWhere((c) => c.id == challenge.id) ?? -1;
    if (block == null || index == -1 || index == block.challenges.length - 1) {
      // NOTE: Inside an open drawer a plain pop only closes the drawer.
      final route = ModalRoute.of(context);
      Navigator.of(context).popUntil((r) => r != route);
      return;
    }

    LearnChallengeRoute(
      superBlock: block.superBlock,
      block: block.dashedName,
      challengeId: block.challenges[index + 1].id,
    ).pushReplacement(context);
  }
}
