import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:freecodecamp/fcc_theme.dart';
import 'package:freecodecamp/learn/models/curriculum_model.dart';
import 'package:freecodecamp/learn/ui/widgets/challenge_grid.dart';
import 'package:freecodecamp/learn/ui/widgets/learn_presentation.dart';
import 'package:freecodecamp/routing/learn.dart';
import 'package:freecodecamp/services/auth_service.dart';

typedef _Dialogue = ({ChallengeOrder header, List<ChallengeOrder> tasks});

List<_Dialogue> _dialogues(Block block) {
  final sections = <_Dialogue>[];
  for (final challenge in block.challenges) {
    if (RegExp(
      r'^Dialogue\b',
      caseSensitive: false,
    ).hasMatch(challenge.title)) {
      sections.add((header: challenge, tasks: []));
    } else if (sections.isNotEmpty) {
      sections.last.tasks.add(challenge);
    }
  }
  return sections;
}

void _open(BuildContext context, Block block, ChallengeOrder challenge) {
  LearnChallengeRoute(
    superBlock: block.superBlock,
    block: block.dashedName,
    challengeId: challenge.id,
  ).push<void>(context);
}

// Dialogue watches and numbered tasks have separate completion states.
class DialogueBlockCard extends ConsumerWidget {
  const DialogueBlockCard({
    super.key,
    required this.block,
    this.showAction = true,
  });

  final Block block;
  final bool showAction;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = Theme.of(context).colorScheme;
    final completed = ref.watch(
      authProvider.select(
        (s) => {...?s.value?.completedChallenges.map((c) => c.id)},
      ),
    );
    final sections = _dialogues(block);
    final active =
        sections
            .where(
              (section) =>
                  !completed.contains(section.header.id) ||
                  section.tasks.any((task) => !completed.contains(task.id)),
            )
            .firstOrNull ??
        sections.firstOrNull;
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(18),
          side: BorderSide(color: colors.outlineVariant),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                block.name,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w800,
                  height: 1.15,
                ),
              ),
              const SizedBox(height: 12),
              if (block.isDisabledByOverride)
                Text(
                  'Temporarily unavailable, come back soon.',
                  style: TextStyle(color: colors.onSurfaceVariant),
                )
              else if (sections.isEmpty)
                const Text('No dialogues available right now.')
              else
                for (final (index, section) in sections.indexed) ...[
                  if (index > 0) const SizedBox(height: 12),
                  _DialogueCard(
                    key: PageStorageKey(
                      '${block.superBlock}/${block.dashedName}/${section.header.id}',
                    ),
                    block: block,
                    section: section,
                    completed: completed,
                    initiallyExpanded: section == active,
                    showAction: showAction,
                  ),
                ],
            ],
          ),
        ),
      ),
    );
  }
}

class _DialogueCard extends StatefulWidget {
  const _DialogueCard({
    super.key,
    required this.block,
    required this.section,
    required this.completed,
    required this.initiallyExpanded,
    required this.showAction,
  });

  final Block block;
  final _Dialogue section;
  final Set<String> completed;
  final bool initiallyExpanded;
  final bool showAction;

  @override
  State<_DialogueCard> createState() => _DialogueCardState();
}

class _DialogueCardState extends State<_DialogueCard> {
  bool? _expanded;
  bool _showAll = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final saved = PageStorage.maybeOf(
      context,
    )?.readState(context, identifier: widget.key);
    if (saved is ({bool? expanded, bool showAll})) {
      _expanded = saved.expanded;
      _showAll = saved.showAll;
    }
  }

  void _saveState() => PageStorage.maybeOf(context)?.writeState(context, (
    expanded: _expanded,
    showAll: _showAll,
  ), identifier: widget.key);

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final expanded = _expanded ?? widget.initiallyExpanded;
    final (:header, :tasks) = widget.section;
    final done = tasks
        .where((task) => widget.completed.contains(task.id))
        .length;
    final next = tasks
        .where((task) => !widget.completed.contains(task.id))
        .firstOrNull;
    final watched = widget.completed.contains(header.id);
    final complete = watched && done == tasks.length;
    final active = watched || done > 0;
    final progress = done == 0
        ? countLabel(tasks.length, 'task')
        : '$done of ${countLabel(tasks.length, 'task')}';

    return Material(
      color: colors.surface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: colors.outlineVariant),
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Semantics(
            expanded: expanded,
            child: InkWell(
              onTap: () => setState(() {
                _expanded = !expanded;
                _saveState();
              }),
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Row(
                  children: [
                    if (!expanded) ...[
                      Semantics(
                        label: complete
                            ? 'Completed'
                            : active
                            ? 'In progress'
                            : 'Not started',
                        excludeSemantics: true,
                        child: LearnStatus(complete: complete, active: active),
                      ),
                      const SizedBox(width: 12),
                    ],
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            header.title,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                              height: 1.25,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            progress,
                            style: TextStyle(
                              fontSize: 12,
                              height: 1.2,
                              color: colors.onSurfaceVariant,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 8),
                    Icon(
                      expanded ? Icons.expand_less : Icons.expand_more,
                      size: 16,
                      color: colors.onSurfaceVariant,
                    ),
                  ],
                ),
              ),
            ),
          ),
          if (expanded) ...[
            Padding(
              padding: const EdgeInsets.fromLTRB(12, 0, 12, 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  _WatchDialogue(
                    block: widget.block,
                    challenge: header,
                    watched: watched,
                  ),
                  if (tasks.isNotEmpty) ...[
                    const SizedBox(height: 12),
                    ChallengeGrid(
                      challenges: tasks,
                      completed: widget.completed,
                      onSelected: (task) => _open(context, widget.block, task),
                      maxVisibleItems: _showAll ? null : 12,
                      maxHeight: double.infinity,
                    ),
                    if (widget.showAction) ...[
                      const SizedBox(height: 12),
                      FilledButton(
                        style: FilledButton.styleFrom(
                          textStyle: const TextStyle(
                            fontFamily: 'Lato',
                            fontSize: 17,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                        onPressed: () =>
                            _open(context, widget.block, next ?? tasks.first),
                        child: Text(
                          next == null
                              ? 'Review tasks'
                              : done > 0
                              ? 'Continue task ${RegExp(r'\d+').firstMatch(next.title)?.group(0) ?? tasks.indexOf(next) + 1}'
                              : 'Start tasks',
                        ),
                      ),
                    ],
                  ],
                ],
              ),
            ),
            if (tasks.length > 12)
              DecoratedBox(
                decoration: BoxDecoration(
                  color: Theme.of(context).scaffoldBackgroundColor,
                  border: Border(top: BorderSide(color: colors.outlineVariant)),
                ),
                child: TextButton(
                  style: TextButton.styleFrom(
                    foregroundColor: FccDesignColors.of(context).accentText,
                    minimumSize: const Size.fromHeight(44),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 12,
                    ),
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    shape: const RoundedRectangleBorder(),
                    textStyle: const TextStyle(
                      fontFamily: 'Lato',
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  onPressed: () => setState(() {
                    _showAll = !_showAll;
                    _saveState();
                  }),
                  child: Text(
                    _showAll
                        ? 'Show fewer tasks'
                        : 'Show all ${tasks.length} tasks',
                  ),
                ),
              ),
          ],
        ],
      ),
    );
  }
}

class _WatchDialogue extends StatelessWidget {
  const _WatchDialogue({
    required this.block,
    required this.challenge,
    required this.watched,
  });

  final Block block;
  final ChallengeOrder challenge;
  final bool watched;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    final status = Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(Icons.check, size: 14, color: FccDesignColors.of(context).success),
        const SizedBox(width: 4),
        Text(
          'Watched',
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w700,
            color: FccDesignColors.of(context).success,
          ),
        ),
      ],
    );

    return Material(
      color: colors.primaryContainer,
      borderRadius: BorderRadius.circular(12),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: () => _open(context, block, challenge),
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: LayoutBuilder(
            builder: (context, constraints) {
              final stacked =
                  constraints.maxWidth < 260 ||
                  MediaQuery.textScalerOf(context).scale(16) > 20;
              return Row(
                children: [
                  Container(
                    width: 36,
                    height: 36,
                    decoration: BoxDecoration(
                      color: colors.primary,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.play_arrow,
                      size: 22,
                      color: colors.onPrimary,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Watch the dialogue',
                          style: TextStyle(
                            fontSize: 16,
                            height: 1.15,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        if (watched && stacked) ...[
                          const SizedBox(height: 6),
                          status,
                        ],
                      ],
                    ),
                  ),
                  if (watched && !stacked) ...[
                    const SizedBox(width: 8),
                    status,
                  ],
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
