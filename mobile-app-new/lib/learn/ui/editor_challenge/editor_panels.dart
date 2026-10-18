import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mobile_app_new/fcc_theme.dart';
import 'package:mobile_app_new/learn/models/challenge_model.dart';
import 'package:mobile_app_new/learn/models/curriculum_model.dart';
import 'package:mobile_app_new/learn/services/code_service.dart';
import 'package:mobile_app_new/learn/ui/challenge/widgets/complete_button.dart';
import 'package:mobile_app_new/learn/ui/challenge/widgets/help_dialog.dart';
import 'package:mobile_app_new/learn/ui/challenge/widgets/parsed_html.dart';
import 'package:mobile_app_new/learn/ui/editor_challenge/editor_challenge_viewmodel.dart';
import 'package:mobile_app_new/routing/auth.dart';
import 'package:mobile_app_new/services/auth_service.dart';

const _heading = TextStyle(fontSize: 28, fontWeight: FontWeight.bold);

class InstructionPanel extends StatelessWidget {
  const InstructionPanel({super.key, required this.challenge, this.block});

  final Challenge challenge;
  final Block? block;

  @override
  Widget build(BuildContext context) {
    final step = RegExp(r'^Step (\d+)$').firstMatch(challenge.title)?.group(1);
    final total = block?.challenges.length;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 12, right: 6),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                challenge.title,
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              if (step != null && total != null)
                Text(
                  'Step $step of $total',
                  style: const TextStyle(fontSize: 14, color: Colors.white70),
                ),
            ],
          ),
        ),
        Expanded(
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ParsedHtml(challenge.description),
                ParsedHtml(challenge.instructions),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class HintPanel extends ConsumerWidget {
  const HintPanel({
    super.key,
    required this.challenge,
    required this.block,
    required this.hint,
    required this.onReset,
  });

  final Challenge challenge;
  final Block? block;
  final String hint;
  final VoidCallback onReset;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 16),
          child: Text('Hint', style: _heading),
        ),
        const SizedBox(height: 8),
        Expanded(child: SingleChildScrollView(child: ParsedHtml(hint))),
        const SizedBox(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            IconButton(
              icon: const Icon(Icons.question_mark),
              padding: const EdgeInsets.all(16),
              onPressed: () async {
                final code = await ref
                    .read(learnCodeServiceProvider)
                    .filesMarkdown(challenge);
                if (!context.mounted) return;
                await showHelpDialog(
                  context,
                  challenge,
                  block?.name ?? 'Daily Coding Challenge',
                  code: code,
                );
              },
            ),
            IconButton(
              icon: const Icon(Icons.restart_alt),
              padding: const EdgeInsets.all(16),
              onPressed: onReset,
            ),
          ],
        ),
      ],
    );
  }
}

class PassPanel extends ConsumerWidget {
  const PassPanel({super.key, required this.challenge, this.block});

  final Challenge challenge;
  final Block? block;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final quote = ref.watch(passQuoteProvider).value;
    final user = ref.watch(authProvider).value;
    final block = this.block;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 16),
          child: Text('Passed', style: _heading),
        ),
        Expanded(
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                if (quote != null)
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: Text(
                      '"${quote.quote}"',
                      style: const TextStyle(fontSize: 20),
                    ),
                  ),
                if (user == null)
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: FccColors.yellow50,
                        minimumSize: const Size.fromHeight(50),
                        shape: const RoundedRectangleBorder(),
                      ),
                      onPressed: () => const LoginRoute().push<void>(context),
                      child: const Text(
                        'Sign in to save your progress',
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Colors.black, fontSize: 20),
                      ),
                    ),
                  )
                else if (block != null)
                  _BlockProgress(
                    completed: {
                      for (final c in user.completedChallenges) c.id,
                      challenge.id,
                    },
                    block: block,
                  ),
                CompleteButton(
                  challenge: challenge,
                  block: block,
                  label: 'Next',
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _BlockProgress extends StatelessWidget {
  const _BlockProgress({required this.completed, required this.block});

  final Set<String> completed;
  final Block block;

  @override
  Widget build(BuildContext context) {
    final total = block.challenges.length;
    final done = block.challenges.where((c) => completed.contains(c.id)).length;

    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          LinearProgressIndicator(
            value: done / total,
            minHeight: 7,
            backgroundColor: FccColors.gray75,
          ),
          const SizedBox(height: 16),
          Text('${(done * 100 / total).round()}% Completed'),
        ],
      ),
    );
  }
}
