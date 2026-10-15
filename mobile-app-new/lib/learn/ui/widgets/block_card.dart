import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mobile_app_new/learn/models/curriculum_model.dart';
import 'package:mobile_app_new/learn/ui/widgets/learn_presentation.dart';
import 'package:mobile_app_new/routing/learn.dart';
import 'package:mobile_app_new/services/auth_service.dart';
import 'package:mobile_app_new/widgets/html_handler/html_handler.dart';

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
  });

  final List<Block> blocks;
  final EdgeInsets padding;
  final Widget? header;

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
  });

  final Block block;
  final bool isOpen;
  final VoidCallback onToggle;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
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
    final progress = done > 0
        ? '$done of ${countLabel(total, unit)}'
        : countLabel(total, unit);
    final toggle = disabled ? () => _showUnavailable(context) : onToggle;

    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Card(
        clipBehavior: Clip.antiAlias,
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
                        ),
                        const SizedBox(width: 12),
                      ],
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            LearnEyebrow(block.label.value, color: color),
                            const SizedBox(height: 6),
                            Text(
                              block.name,
                              style: Theme.of(context).textTheme.titleMedium,
                            ),
                            const SizedBox(height: 4),
                            Text(
                              disabled ? 'Temporarily unavailable' : progress,
                              style: TextStyle(
                                fontSize: 13,
                                color: colors.onSurfaceVariant,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 8),
                      Icon(
                        expanded ? Icons.expand_less : Icons.chevron_right,
                        color: colors.onSurfaceVariant,
                        size: 22,
                      ),
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
                          fontSize: FontSize(14),
                          color: colors.onSurfaceVariant,
                        ),
                      },
                    ),
                    const SizedBox(height: 12),
                    if (total == 0)
                      const Text('No challenges available right now.')
                    else ...[
                      switch (block.layout) {
                        BlockLayout.challengeGrid => _StepGrid(
                          block: block,
                          challenges: block.challenges,
                          completed: completed,
                        ),
                        BlockLayout.challengeDialogue => _Dialogues(
                          block: block,
                          completed: completed,
                        ),
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
                      const SizedBox(height: 12),
                      FilledButton(
                        style: FilledButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        onPressed: () => _openChallenge(
                          context,
                          block,
                          (next ?? block.challenges.first).id,
                        ),
                        child: Text(
                          complete
                              ? 'Review ${unit == 'step' ? 'steps' : block.label.value}'
                              : done > 0 && unit == 'step'
                              ? 'Continue step ${block.challenges.indexOf(next!) + 1}'
                              : done > 0
                              ? 'Continue ${block.label.value}'
                              : 'Start ${block.label.value == 'legacy' ? 'learning' : block.label.value}',
                        ),
                      ),
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
        color: active
            ? colors.primaryContainer.withValues(alpha: 0.4)
            : colors.surface,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: BorderSide(
            color: active ? colors.primary : colors.outlineVariant,
          ),
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
                      style: TextStyle(fontSize: 12, color: colors.onSurface),
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

class _StepGrid extends StatelessWidget {
  const _StepGrid({
    required this.block,
    required this.challenges,
    required this.completed,
  });
  final Block block;
  final List<ChallengeOrder> challenges;
  final Set<String> completed;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final next = challenges.where((c) => !completed.contains(c.id)).firstOrNull;
    return LayoutBuilder(
      builder: (context, constraints) {
        final scale = MediaQuery.textScalerOf(context).scale(14) / 14;
        final minimumSide = 48 * scale;
        final columns = ((constraints.maxWidth + 6) / (minimumSide + 6))
            .floor()
            .clamp(1, 6);
        final side = (constraints.maxWidth - (columns - 1) * 6) / columns;
        return ConstrainedBox(
          constraints: const BoxConstraints(maxHeight: 300),
          child: GridView.builder(
            shrinkWrap: true,
            primary: false,
            padding: EdgeInsets.zero,
            physics: (challenges.length / columns).ceil() * (side + 6) - 6 > 300
                ? const ClampingScrollPhysics()
                : const NeverScrollableScrollPhysics(),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: columns,
              childAspectRatio: 1,
              mainAxisSpacing: 6,
              crossAxisSpacing: 6,
            ),
            itemCount: challenges.length,
            itemBuilder: (context, index) {
              final challenge = challenges[index];
              final done = completed.contains(challenge.id);
              final active = challenge == next;
              final number =
                  RegExp(r'\d+').firstMatch(challenge.title)?.group(0) ??
                  '${index + 1}';
              return Semantics(
                label: '${challenge.title}${done ? ', completed' : ''}',
                button: true,
                excludeSemantics: true,
                child: TextButton(
                  style: TextButton.styleFrom(
                    padding: EdgeInsets.zero,
                    backgroundColor: done
                        ? colors.primary
                        : active
                        ? colors.surfaceContainer
                        : colors.surface,
                    foregroundColor: done ? colors.onPrimary : colors.onSurface,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                      side: BorderSide(
                        color: done || active
                            ? colors.primary
                            : colors.outlineVariant,
                      ),
                    ),
                  ),
                  onPressed: () => _openChallenge(context, block, challenge.id),
                  child: done
                      ? const Icon(Icons.check, size: 20)
                      : Text(
                          number,
                          style: const TextStyle(
                            fontFamily: 'monospace',
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                ),
              );
            },
          ),
        );
      },
    );
  }
}

class _Dialogues extends StatelessWidget {
  const _Dialogues({required this.block, required this.completed});
  final Block block;
  final Set<String> completed;

  @override
  Widget build(BuildContext context) {
    final sections = <({ChallengeOrder header, List<ChallengeOrder> tasks})>[];
    for (final (index, challenge) in block.challenges.indexed) {
      if (index == 0 || challenge.title.contains('Dialogue')) {
        sections.add((header: challenge, tasks: []));
      } else {
        sections.last.tasks.add(challenge);
      }
    }
    return Column(
      children: [
        for (final (:header, :tasks) in sections)
          Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: Card(
              clipBehavior: Clip.antiAlias,
              child: ExpansionTile(
                initiallyExpanded: header == sections.first.header,
                tilePadding: const EdgeInsets.symmetric(horizontal: 12),
                childrenPadding: const EdgeInsets.fromLTRB(12, 0, 12, 12),
                leading: Icon(
                  Icons.play_circle_outline,
                  color: Theme.of(context).colorScheme.tertiary,
                ),
                title: Text(
                  header.title,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                subtitle: Text(
                  '${tasks.where((c) => completed.contains(c.id)).length} of ${countLabel(tasks.length, 'task')}',
                ),
                children: [
                  Align(
                    alignment: Alignment.centerLeft,
                    child: TextButton.icon(
                      onPressed: () =>
                          _openChallenge(context, block, header.id),
                      icon: const Icon(Icons.play_arrow),
                      label: Text(
                        completed.contains(header.id)
                            ? 'Watch again'
                            : 'Watch dialogue',
                      ),
                    ),
                  ),
                  _StepGrid(
                    block: block,
                    challenges: tasks,
                    completed: completed,
                  ),
                ],
              ),
            ),
          ),
      ],
    );
  }
}
