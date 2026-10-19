import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mobile_app_new/fcc_theme.dart';
import 'package:mobile_app_new/learn/models/challenge_model.dart';
import 'package:mobile_app_new/learn/models/curriculum_model.dart';
import 'package:mobile_app_new/learn/ui/challenge/widgets/parsed_html.dart';
import 'package:mobile_app_new/learn/ui/widgets/celebration_confetti.dart';
import 'package:mobile_app_new/learn/ui/widgets/learn_presentation.dart';
import 'package:mobile_app_new/routing/auth.dart';
import 'package:mobile_app_new/services/auth_service.dart';

class InstructionPanel extends StatelessWidget {
  const InstructionPanel({super.key, required this.challenge, this.block});

  final Challenge challenge;
  final Block? block;

  @override
  Widget build(BuildContext context) => SingleChildScrollView(
    padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        for (final html in [challenge.description, challenge.instructions])
          if (html.trim().isNotEmpty)
            ParsedHtml(
              html,
              outlinedInlineCode: true,
              customStyles: {'*': Style(lineHeight: const LineHeight(1.45))},
            ),
      ],
    ),
  );
}

class HintPanel extends StatelessWidget {
  const HintPanel({super.key, required this.hint});

  final String hint;

  @override
  Widget build(BuildContext context) {
    final dark = Theme.of(context).brightness == Brightness.dark;
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: dark ? const Color(0xFF29216C) : const Color(0xFFF6F6FE),
              borderRadius: BorderRadius.circular(16),
            ),
            child: ParsedHtml(
              hint,
              outlinedInlineCode: true,
              customStyles: {
                '*': Style(lineHeight: const LineHeight(1.45)),
                'p': Style(margin: Margins.zero),
              },
            ),
          ),
          const SizedBox(height: 12),
          Align(
            alignment: Alignment.centerLeft,
            child: OutlinedButton(
              onPressed: null,
              style: OutlinedButton.styleFrom(
                minimumSize: const Size(0, 44),
                textStyle: const TextStyle(
                  fontFamily: 'Lato',
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                ),
              ),
              child: const Text(
                'Ask for another hint',
                textAlign: TextAlign.center,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class PassPanel extends ConsumerWidget {
  const PassPanel({
    super.key,
    required this.challenge,
    this.block,
    required this.onReviewCode,
  });

  final Challenge challenge;
  final Block? block;
  final VoidCallback onReviewCode;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;
    final dark = theme.brightness == Brightness.dark;
    final success = FccDesignColors.of(context).success;
    final user = ref.watch(authProvider).value;
    final block = this.block;
    final step = RegExp(r'^Step (\d+)$').firstMatch(challenge.title)?.group(1);
    final index =
        block?.challenges.indexWhere((c) => c.id == challenge.id) ?? -1;
    final next =
        block != null && index >= 0 && index + 1 < block.challenges.length
        ? RegExp(
            r'^Step (\d+)$',
          ).firstMatch(block.challenges[index + 1].title)?.group(1)
        : null;
    final tests = challenge.tests.length;
    final completed = {
      ...?user?.completedChallenges.map((c) => c.id),
      challenge.id,
    };
    final tint = dark ? const Color(0xFF003D1B) : const Color(0xFFCCFBD7);

    return DecoratedBox(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [tint, tint.withValues(alpha: 0)],
        ),
      ),
      child: Stack(
        children: [
          const Positioned.fill(child: CelebrationConfetti()),
          SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(16, 24, 16, 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Center(
                  child: ExcludeSemantics(
                    child: Container(
                      width: 48,
                      height: 48,
                      decoration: BoxDecoration(
                        color: dark
                            ? const Color(0xFF8DDAA2)
                            : const Color(0xFFB0EEBF),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.check_rounded,
                        color: dark ? colors.onSecondary : success,
                        size: 30,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  step == null ? 'Challenge complete!' : 'Step $step complete!',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 28,
                    height: 1.15,
                    fontWeight: FontWeight.w800,
                    color: colors.onSurface,
                  ),
                ),
                if (tests > 0) ...[
                  const SizedBox(height: 12),
                  Text(
                    '${tests == 1 ? '1 test' : 'All $tests tests'} passed.${next == null ? '' : ' On to step $next.'}',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 16,
                      color: colors.onSurfaceVariant,
                    ),
                  ),
                ],
                if (block != null && block.challenges.isNotEmpty) ...[
                  const SizedBox(height: 20),
                  _BlockProgress(completed: completed, block: block),
                ],
                if (user == null) ...[
                  const SizedBox(height: 24),
                  FilledButton(
                    onPressed: () => const LoginRoute().push<void>(context),
                    style: FilledButton.styleFrom(
                      backgroundColor: colors.secondary,
                      foregroundColor: colors.onSecondary,
                      minimumSize: const Size.fromHeight(52),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 12,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      textStyle: const TextStyle(
                        fontFamily: 'Lato',
                        fontSize: 16,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    child: const Text(
                      'Sign in to save your progress',
                      textAlign: TextAlign.center,
                    ),
                  ),
                ],
                const SizedBox(height: 12),
                TextButton(
                  onPressed: onReviewCode,
                  style: TextButton.styleFrom(
                    foregroundColor: FccDesignColors.of(context).accentText,
                    textStyle: const TextStyle(
                      fontFamily: 'Lato',
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      decoration: TextDecoration.underline,
                    ),
                  ),
                  child: const Text('Review code'),
                ),
              ],
            ),
          ),
        ],
      ),
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
    final colors = Theme.of(context).colorScheme;
    final style = TextStyle(
      fontSize: 12,
      fontWeight: FontWeight.w700,
      color: colors.onSurfaceVariant,
    );
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(flex: 2, child: Text(block.name, style: style)),
            const SizedBox(width: 12),
            Flexible(
              child: Text(
                '$done of ${countLabel(total, 'step')}',
                textAlign: TextAlign.right,
                style: style,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        LearnProgress(
          done: done,
          total: total,
          backgroundColor: colors.surface,
        ),
      ],
    );
  }
}
