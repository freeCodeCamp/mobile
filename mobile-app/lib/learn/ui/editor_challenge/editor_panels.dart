import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:freecodecamp/fcc_theme.dart';
import 'package:freecodecamp/learn/models/challenge_model.dart';
import 'package:freecodecamp/learn/models/curriculum_model.dart';
import 'package:freecodecamp/learn/ui/challenge/widgets/parsed_html.dart';
import 'package:freecodecamp/learn/ui/widgets/celebration_confetti.dart';
import 'package:freecodecamp/learn/ui/widgets/learn_presentation.dart';
import 'package:freecodecamp/routing/auth.dart';
import 'package:freecodecamp/services/auth_service.dart';
import 'package:html/parser.dart' show parseFragment;

class DailyInstructionCard extends StatelessWidget {
  const DailyInstructionCard({
    super.key,
    required this.challenge,
    required this.maxHeight,
  });

  final Challenge challenge;
  final double maxHeight;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final fragment = parseFragment(challenge.description);
    final summary = (fragment.querySelector('p')?.text ?? fragment.text ?? '')
        .replaceAll(RegExp(r'\s+'), ' ')
        .trim();
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 12),
      constraints: BoxConstraints(maxHeight: maxHeight),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: theme.colorScheme.outlineVariant),
      ),
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              challenge.title,
              style: theme.textTheme.titleLarge?.copyWith(
                fontSize: 20,
                fontWeight: FontWeight.w900,
              ),
            ),
            if (summary.isNotEmpty) ...[
              const SizedBox(height: 8),
              Text(summary, maxLines: 2, overflow: TextOverflow.ellipsis),
            ],
            Align(
              alignment: Alignment.centerLeft,
              child: TextButton(
                onPressed: () => showModalBottomSheet<void>(
                  context: context,
                  isScrollControlled: true,
                  useSafeArea: true,
                  showDragHandle: true,
                  builder: (context) => SizedBox(
                    height: MediaQuery.sizeOf(context).height * .7,
                    child: InstructionPanel(challenge: challenge),
                  ),
                ),
                child: const Text(
                  'Read more',
                  style: TextStyle(decoration: TextDecoration.underline),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class DailyChallengeExample extends StatelessWidget {
  const DailyChallengeExample({super.key, required this.test});

  final ChallengeTest test;

  @override
  Widget build(BuildContext context) {
    final fragment = parseFragment(test.text);
    final paragraph = fragment.children.singleOrNull;
    final example = paragraph?.localName == 'p'
        ? paragraph!.innerHtml
        : test.text;
    return ParsedHtml(
      'Example: $example',
      outlinedInlineCode: true,
      customStyles: {
        '*': Style(
          fontSize: FontSize(13),
          color: Theme.of(context).colorScheme.onSurfaceVariant,
        ),
        'p': Style(margin: Margins.zero),
        'code': Style(fontFamily: 'JetBrains Mono', fontSize: FontSize(13)),
      },
    );
  }
}

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
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: FccDesignColors.of(context).editorHighlight,
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
    final tint = FccDesignColors.of(context).successContainer;

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
                            ? success
                            : FccDesignColors.of(context).successContainer,
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
                    fontSize: 26,
                    height: 1.15,
                    fontWeight: FontWeight.w900,
                    color: colors.onSurface,
                  ),
                ),
                if (tests > 0) ...[
                  const SizedBox(height: 12),
                  Text(
                    '${tests == 1 ? '1 test' : 'All $tests tests'} passed.${next == null ? '' : ' On to step $next.'}',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 15,
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
                  Text(
                    "You're not signed in, so this progress is only saved on this device.",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 14,
                      color: colors.onSurfaceVariant,
                    ),
                  ),
                  const SizedBox(height: 12),
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
                      textStyle: const TextStyle(
                        fontFamily: 'Lato',
                        fontSize: 17,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    child: const Text(
                      'Sign in to save progress',
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
      fontSize: 13,
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
