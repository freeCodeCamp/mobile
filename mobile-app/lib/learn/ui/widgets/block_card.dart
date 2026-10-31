import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:freecodecamp/fcc_theme.dart';
import 'package:freecodecamp/learn/models/curriculum_model.dart';
import 'package:freecodecamp/learn/ui/widgets/challenge_grid.dart';
import 'package:freecodecamp/learn/ui/widgets/dialogue_block_card.dart';
import 'package:freecodecamp/learn/ui/widgets/exam_card.dart';
import 'package:freecodecamp/learn/ui/widgets/learn_presentation.dart';
import 'package:freecodecamp/learn/ui/widgets/learning_website.dart';
import 'package:freecodecamp/routing/learn.dart';
import 'package:freecodecamp/services/auth_service.dart';
import 'package:freecodecamp/widgets/html_handler/html_handler.dart';

void _openChallenge(BuildContext context, Block block, String challengeId) {
  LearnChallengeRoute(
    superBlock: block.superBlock,
    block: block.dashedName,
    challengeId: challengeId,
  ).push<void>(context);
}

void _showUnavailable(BuildContext context) {
  ScaffoldMessenger.of(context)
    ..hideCurrentSnackBar()
    ..showSnackBar(
      const SnackBar(content: Text('Temporarily unavailable, come back soon.')),
    );
}

class BlockList extends ConsumerStatefulWidget {
  const BlockList({
    super.key,
    required this.blocks,
    required this.padding,
    this.header,
    this.showActions = true,
  });

  final List<Block> blocks;
  final EdgeInsets padding;
  final Widget? header;
  final bool showActions;

  @override
  ConsumerState<BlockList> createState() => _BlockListState();
}

class _BlockListState extends ConsumerState<BlockList> {
  final _open = <String, bool>{};

  @override
  Widget build(BuildContext context) {
    final completed = ref.watch(
      authProvider.select(
        (s) => {...?s.value?.completedChallenges.map((c) => c.id)},
      ),
    );
    final active = widget.blocks.indexWhere(
      (b) =>
          !b.isDisabledByOverride &&
          b.label != BlockLabel.exam &&
          b.challenges.any((c) => !completed.contains(c.id)),
    );
    final headerCount = widget.header == null ? 0 : 1;
    return ListView.builder(
      physics: const AlwaysScrollableScrollPhysics(),
      padding: widget.padding,
      itemCount: widget.blocks.length + headerCount,
      itemBuilder: (context, index) {
        if (index < headerCount) return widget.header!;
        final blockIndex = index - headerCount;
        final block = widget.blocks[blockIndex];
        final isOpen = _open[block.dashedName] ?? blockIndex == active;
        return BlockCard(
          key: ValueKey(block.dashedName),
          block: block,
          isOpen: isOpen,
          showAction: widget.showActions,
          onToggle: () => setState(() => _open[block.dashedName] = !isOpen),
        );
      },
    );
  }
}

class BlockCard extends ConsumerWidget {
  const BlockCard({
    super.key,
    required this.block,
    required this.isOpen,
    required this.onToggle,
    this.showAction = true,
  });

  final Block block;
  final bool isOpen;
  final VoidCallback onToggle;
  final bool showAction;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (block.label == BlockLabel.exam) {
      return Padding(
        padding: const EdgeInsets.only(bottom: 12),
        child: ExamCard(
          eyebrow: 'Exam',
          title: block.name,
          locked: block.isDisabledByOverride,
          onOpen: () => openLearningWebsite(
            context,
            block.superBlock,
            chapter: block.dashedName,
          ),
        ),
      );
    }
    if (block.layout == BlockLayout.challengeDialogue) {
      return DialogueBlockCard(block: block, showAction: showAction);
    }
    final colors = Theme.of(context).colorScheme;
    final completed = ref.watch(
      authProvider.select(
        (s) => {...?s.value?.completedChallenges.map((c) => c.id)},
      ),
    );
    final done = block.challenges.where((c) => completed.contains(c.id)).length;
    final total = block.challenges.length;
    final complete = total > 0 && done == total;
    final disabled = block.isDisabledByOverride;
    final expanded = isOpen && !disabled;
    final color = blockLabelColor(context, block.label);
    final next = block.challenges
        .where((c) => !completed.contains(c.id))
        .firstOrNull;
    final unit = blockUnit(block);
    final progress = '$done of ${countLabel(total, unit)}';
    final toggle = disabled ? () => _showUnavailable(context) : onToggle;

    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Card(
        clipBehavior: Clip.antiAlias,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: BorderSide(
            color: done > 0 && !complete
                ? colors.primary
                : colors.outlineVariant,
            width: done > 0 && !complete ? 2 : 1,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            InkWell(
              onTap: toggle,
              child: Semantics(
                button: true,
                expanded: expanded,
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    children: [
                      if (!expanded) ...[
                        LearnStatus(
                          complete: complete,
                          active: done > 0 && !complete,
                          large: true,
                        ),
                        const SizedBox(width: 12),
                      ],
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            if (expanded)
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Expanded(
                                    child: LearnEyebrow(
                                      block.label.value,
                                      color: color,
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  Flexible(
                                    child: Align(
                                      alignment: Alignment.topRight,
                                      heightFactor: 1,
                                      child: Text(
                                        progress,
                                        textAlign: TextAlign.right,
                                        style: TextStyle(
                                          fontSize: 13,
                                          color: colors.onSurfaceVariant,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              )
                            else
                              LearnEyebrow(block.label.value, color: color),
                            SizedBox(height: expanded ? 12 : 6),
                            Text(
                              block.name,
                              style: expanded
                                  ? Theme.of(context).textTheme.titleLarge
                                  : Theme.of(context).textTheme.titleMedium
                                        ?.copyWith(fontSize: 17),
                            ),
                            if (!expanded) ...[
                              const SizedBox(height: 4),
                              Text(
                                disabled
                                    ? 'Temporarily unavailable'
                                    : done > 0
                                    ? progress
                                    : countLabel(total, unit),
                                style: TextStyle(
                                  fontSize: 13,
                                  fontWeight: done > 0 && !complete
                                      ? FontWeight.w700
                                      : FontWeight.w400,
                                  color: done > 0 && !complete
                                      ? FccDesignColors.of(context).accentText
                                      : colors.onSurfaceVariant,
                                ),
                              ),
                            ],
                          ],
                        ),
                      ),
                      if (!expanded) ...[
                        const SizedBox(width: 8),
                        Icon(
                          Icons.chevron_right,
                          color: colors.onSurfaceVariant,
                          size: 22,
                        ),
                      ],
                    ],
                  ),
                ),
              ),
            ),
            if (expanded)
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    LearnProgress(done: done, total: total, color: color),
                    const SizedBox(height: 12),
                    ...HTMLParser(context: context).parse(
                      '<p>${block.description.join(' ')}</p>',
                      isSelectable: false,
                      customStyles: {
                        'body': Style(
                          margin: Margins.zero,
                          padding: HtmlPaddings.zero,
                        ),
                        'p': Style(
                          margin: Margins.zero,
                          fontSize: FontSize(15),
                          lineHeight: const LineHeight(1.45),
                          color: colors.onSurfaceVariant,
                        ),
                      },
                    ),
                    const SizedBox(height: 12),
                    if (total == 0)
                      const Text('No challenges available right now.')
                    else ...[
                      switch (block.layout) {
                        BlockLayout.challengeGrid => ChallengeGrid(
                          onSelected: (challenge) =>
                              _openChallenge(context, block, challenge.id),
                          challenges: block.challenges,
                          completed: completed,
                        ),
                        BlockLayout.challengeDialogue =>
                          const SizedBox.shrink(),
                        BlockLayout.challengeList => Column(
                          children: [
                            for (final (index, challenge)
                                in block.challenges.indexed)
                              _ChallengeTile(
                                block: block,
                                challenge: challenge,
                                index: index + 1,
                                completed: completed.contains(challenge.id),
                                active: challenge == next,
                              ),
                          ],
                        ),
                        BlockLayout.challengeLink => const SizedBox.shrink(),
                      },
                      if (showAction) ...[
                        const SizedBox(height: 12),
                        BlockActionButton(block: block, completed: completed),
                      ],
                    ],
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _ChallengeTile extends StatelessWidget {
  const _ChallengeTile({
    required this.block,
    required this.challenge,
    required this.index,
    required this.completed,
    required this.active,
  });
  final Block block;
  final ChallengeOrder challenge;
  final int index;
  final bool completed;
  final bool active;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Material(
        color: active ? colors.primaryContainer : colors.surface,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: BorderSide(color: active ? colors.primary : colors.outline),
        ),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: () => _openChallenge(context, block, challenge.id),
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              children: [
                if (completed)
                  const LearnStatus(complete: true)
                else
                  CircleAvatar(
                    radius: 14,
                    backgroundColor: colors.surfaceContainer,
                    child: Text(
                      '$index',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                        color: colors.onSurface,
                      ),
                    ),
                  ),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    challenge.title,
                    style: const TextStyle(fontSize: 14),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class BlockActionButton extends StatelessWidget {
  const BlockActionButton({
    super.key,
    required this.block,
    required this.completed,
    this.height = 48,
    this.showArrow = false,
  });
  final Block block;
  final Set<String> completed;
  final double height;
  final bool showArrow;

  @override
  Widget build(BuildContext context) {
    final next = block.challenges
        .where((c) => !completed.contains(c.id))
        .firstOrNull;
    final done = block.challenges.where((c) => completed.contains(c.id)).length;
    final unit = blockUnit(block);
    final label = Text(
      next == null
          ? 'Review ${unit == 'step' ? 'steps' : block.label.value}'
          : done > 0 && unit == 'step'
          ? 'Continue step ${block.challenges.indexOf(next) + 1}'
          : done > 0
          ? 'Continue ${block.label.value}'
          : 'Start ${block.label == BlockLabel.legacy ? 'learning' : block.label.value}',
    );
    return FilledButton(
      style: FilledButton.styleFrom(
        minimumSize: Size(double.infinity, height),
        textStyle: const TextStyle(
          fontFamily: 'Lato',
          fontSize: 17,
          fontWeight: FontWeight.w900,
        ),
      ),
      onPressed: block.challenges.isEmpty
          ? null
          : () => _openChallenge(
              context,
              block,
              (next ?? block.challenges.first).id,
            ),
      child: showArrow
          ? Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                label,
                const SizedBox(width: 8),
                SvgPicture.asset(
                  'assets/icons/arrow-right.svg',
                  width: 18,
                  height: 18,
                  theme: SvgTheme(
                    currentColor: Theme.of(context).colorScheme.onPrimary,
                  ),
                  excludeFromSemantics: true,
                ),
              ],
            )
          : label,
    );
  }
}
