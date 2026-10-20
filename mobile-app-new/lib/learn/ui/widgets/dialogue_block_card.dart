import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mobile_app_new/fcc_theme.dart';
import 'package:mobile_app_new/learn/models/curriculum_model.dart';
import 'package:mobile_app_new/learn/ui/challenge/challenge_viewmodel.dart';
import 'package:mobile_app_new/learn/ui/widgets/learn_presentation.dart';
import 'package:mobile_app_new/routing/learn.dart';
import 'package:mobile_app_new/services/auth_service.dart';

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

/// Dialogue watches and numbered tasks have separate completion states.
class DialogueBlockCard extends ConsumerWidget {
  const DialogueBlockCard({super.key, required this.block});

  final Block block;

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
  });

  final Block block;
  final _Dialogue section;
  final Set<String> completed;
  final bool initiallyExpanded;

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
                    watched: widget.completed.contains(header.id),
                  ),
                  if (tasks.isNotEmpty) ...[
                    const SizedBox(height: 12),
                    _TaskGrid(
                      block: widget.block,
                      tasks: tasks,
                      completed: widget.completed,
                      showAll: _showAll,
                    ),
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

class _WatchDialogue extends ConsumerWidget {
  const _WatchDialogue({
    required this.block,
    required this.challenge,
    required this.watched,
  });

  final Block block;
  final ChallengeOrder challenge;
  final bool watched;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = Theme.of(context).colorScheme;
    // Only expanded dialogues fetch their scene metadata; failures must not
    // prevent opening the watch screen, which has its own retry handling.
    final data = ref.watch(
      challengeScreenProvider(block.superBlock, block.dashedName, challenge.id),
    );
    final lines = data.value?.challenge.scene?.commands
        .where((command) => command.dialogue?.text.trim().isNotEmpty ?? false)
        .length;

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
                        const SizedBox(height: 2),
                        Text(
                          lines != null && lines > 0
                              ? '${countLabel(lines, 'line')}, with captions'
                              : 'Watch and listen',
                          style: TextStyle(
                            fontSize: 12,
                            height: 1.2,
                            color: colors.onSurfaceVariant,
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

class _TaskGrid extends StatelessWidget {
  const _TaskGrid({
    required this.block,
    required this.tasks,
    required this.completed,
    required this.showAll,
  });

  final Block block;
  final List<ChallengeOrder> tasks;
  final Set<String> completed;
  final bool showAll;

  String _number(int index) =>
      RegExp(r'\d+').firstMatch(tasks[index].title)?.group(0) ?? '${index + 1}';

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final design = FccDesignColors.of(context);
    final current = tasks
        .where((task) => !completed.contains(task.id))
        .firstOrNull;
    const style = TextStyle(fontSize: 14, fontWeight: FontWeight.w700);
    return LayoutBuilder(
      builder: (context, constraints) {
        final digits = List.generate(
          tasks.length,
          _number,
        ).fold(1, (length, number) => math.max(length, number.length));
        final numeral = TextPainter(
          text: TextSpan(
            text: '8' * digits,
            style: style.copyWith(fontFamily: 'Lato'),
          ),
          textScaler: MediaQuery.textScalerOf(context),
          textDirection: Directionality.of(context),
        )..layout();
        final minSide = math.max(
          44.0,
          math.max(numeral.width, numeral.height) + 16,
        );
        numeral.dispose();
        final columns = math.max(
          1,
          ((constraints.maxWidth + 6) / (minSide + 6)).floor(),
        );
        return GridView.builder(
          shrinkWrap: true,
          primary: false,
          padding: EdgeInsets.zero,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: columns,
            childAspectRatio: 1,
            mainAxisSpacing: 6,
            crossAxisSpacing: 6,
          ),
          itemCount: showAll ? tasks.length : math.min(12, tasks.length),
          itemBuilder: (context, index) {
            final task = tasks[index];
            final done = completed.contains(task.id);
            final active = task == current;
            return Semantics(
              label:
                  '${task.title}${done
                      ? ', completed'
                      : active
                      ? ', current'
                      : ''}',
              button: true,
              excludeSemantics: true,
              onTap: () => _open(context, block, task),
              child: TextButton(
                style: TextButton.styleFrom(
                  padding: EdgeInsets.zero,
                  minimumSize: Size.zero,
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  foregroundColor: done ? design.success : colors.onSurface,
                  backgroundColor: done
                      ? design.successContainer
                      : colors.surface,
                  textStyle: style.copyWith(fontFamily: 'Lato'),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(9),
                    side: BorderSide(
                      color: done
                          ? design.successContainer
                          : active
                          ? colors.primary
                          : colors.outlineVariant,
                      width: active ? 2 : 1,
                    ),
                  ),
                ),
                onPressed: () => _open(context, block, task),
                child: Text(_number(index)),
              ),
            );
          },
        );
      },
    );
  }
}
