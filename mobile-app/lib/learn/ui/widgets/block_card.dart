import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:freecodecamp/fcc_theme.dart';
import 'package:freecodecamp/learn/models/curriculum_model.dart';
import 'package:freecodecamp/routing/learn.dart';
import 'package:freecodecamp/services/auth_service.dart';
import 'package:freecodecamp/widgets/drawer/scroll_shadow.dart';
import 'package:freecodecamp/widgets/html_handler/html_handler.dart';

const _cardColor = FccColors.gray85;
const _borderColor = FccColors.gray75;
const _tileColor = FccColors.gray80;
const _completedTileColor = FccColors.blue90Translucent;
const _completedBorderColor = FccColors.blue10;

(IconData?, Color) _labelStyle(BlockLabel label) => switch (label) {
  BlockLabel.lecture => (Icons.menu_book_outlined, FccColors.blue30),
  BlockLabel.quiz => (Icons.help_outline, FccColors.orange30),
  BlockLabel.lab => (Icons.science_outlined, FccColors.green40),
  BlockLabel.workshop => (Icons.build_outlined, FccColors.purple10),
  BlockLabel.exam => (Icons.school, FccColors.red15),
  BlockLabel.review => (Icons.edit_document, FccColors.yellow10),
  BlockLabel.warmup => (Icons.fitbit_outlined, FccColors.blue30),
  BlockLabel.learn => (Icons.school_outlined, FccColors.green40),
  BlockLabel.practice => (Icons.edit_outlined, FccColors.purple10),
  BlockLabel.legacy => (null, FccColors.blue05),
};

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
      const SnackBar(
        content: Text('Temporarily unavailable, come back soon.'),
        duration: Duration(milliseconds: 2500),
      ),
    );
}

class BlockList extends StatefulWidget {
  const BlockList({super.key, required this.blocks, required this.padding});

  final List<Block> blocks;
  final EdgeInsets padding;

  @override
  State<BlockList> createState() => _BlockListState();
}

class _BlockListState extends State<BlockList> {
  final _toggled = <String>{};

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: widget.padding,
      itemCount: widget.blocks.length,
      itemBuilder: (context, index) {
        final block = widget.blocks[index];

        return BlockCard(
          key: ValueKey(block.dashedName),
          block: block,
          isOpen: (index == 0) != _toggled.contains(block.dashedName),
          onToggle: () => setState(() {
            if (!_toggled.remove(block.dashedName)) {
              _toggled.add(block.dashedName);
            }
          }),
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
    final completedChallenges = ref.watch(
      authProvider.select((s) => s.value?.completedChallenges),
    );
    final completed = {...?completedChallenges?.map((c) => c.id)};

    final (icon, color) = _labelStyle(block.label);
    final isDisabled = block.isDisabledByOverride;
    final isOpen = this.isOpen && !isDisabled;
    final onToggle = isDisabled
        ? () => _showUnavailable(context)
        : this.onToggle;

    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Opacity(
        opacity: isDisabled ? 0.7 : 1,
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: _borderColor),
            color: _cardColor,
          ),
          padding: const EdgeInsets.all(8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (icon != null)
                    Padding(
                      padding: const EdgeInsets.all(8),
                      child: Icon(icon, color: color, size: 30),
                    ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(8),
                      child: Text(
                        block.name,
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: color,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              ...switch (block.layout) {
                BlockLayout.challengeGrid => [
                  _Progress(block: block, completed: completed, color: color),
                  _Description(block: block),
                  _ToggleButton(
                    isOpen: isOpen,
                    noun: 'Steps',
                    onPressed: onToggle,
                  ),
                  if (isOpen) _StepGrid(block: block, completed: completed),
                ],
                BlockLayout.challengeList => [
                  _Progress(
                    block: block,
                    completed: completed,
                    color: FccColors.blue30,
                  ),
                  _Description(block: block),
                  _ToggleButton(
                    isOpen: isOpen,
                    noun: 'Steps',
                    onPressed: onToggle,
                  ),
                  if (isOpen)
                    for (final challenge in block.challenges)
                      _ChallengeCard(
                        title: challenge.title,
                        isCompleted: completed.contains(challenge.id),
                        onTap: () =>
                            _openChallenge(context, block, challenge.id),
                      ),
                ],
                BlockLayout.challengeDialogue => [
                  _Description(block: block),
                  _ToggleButton(
                    isOpen: isOpen,
                    noun: 'Tasks',
                    onPressed: onToggle,
                  ),
                  if (isOpen) _Dialogues(block: block, completed: completed),
                ],
                BlockLayout.challengeLink => [
                  if (block.challenges.every((c) => completed.contains(c.id)))
                    _CompletedLabel(color: color),
                  _Description(block: block),
                  Padding(
                    padding: const EdgeInsets.all(8),
                    child: SizedBox(
                      width: double.infinity,
                      child: TextButton(
                        onPressed: isDisabled || block.challenges.isEmpty
                            ? () => _showUnavailable(context)
                            : () => _openChallenge(
                                context,
                                block,
                                block.challenges.first.id,
                              ),
                        style: TextButton.styleFrom(
                          backgroundColor: color,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5),
                          ),
                        ),
                        child: const Text(
                          'Start',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: FccColors.gray90,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              },
            ],
          ),
        ),
      ),
    );
  }
}

class _CompletedLabel extends StatelessWidget {
  const _CompletedLabel({required this.color});

  final Color color;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8),
      child: Row(
        children: [
          Padding(
            padding: const EdgeInsets.only(right: 8),
            child: Icon(Icons.check_circle, color: color),
          ),
          Text(
            'Completed',
            style: TextStyle(color: color, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}

class _Progress extends StatelessWidget {
  const _Progress({
    required this.block,
    required this.completed,
    required this.color,
  });

  final Block block;
  final Set<String> completed;
  final Color color;

  @override
  Widget build(BuildContext context) {
    final total = block.challenges.length;
    final done = block.challenges.where((c) => completed.contains(c.id)).length;
    if (done == total) return _CompletedLabel(color: color);

    return Padding(
      padding: const EdgeInsets.all(10),
      child: LinearProgressIndicator(
        minHeight: 12,
        value: done == 0 ? 0.01 : done / total,
        valueColor: AlwaysStoppedAnimation<Color>(color),
        backgroundColor: _tileColor,
        borderRadius: BorderRadius.circular(10),
      ),
    );
  }
}

class _Description extends StatelessWidget {
  const _Description({required this.block});

  final Block block;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: HTMLParser(context: context).parse(
        '<p>${block.description.join(' ')}</p>',
        isSelectable: false,
        customStyles: {
          '*:not(h1):not(h2):not(h3):not(h4):not(h5):not(h6)': Style(
            color: FccColors.gray05,
          ),
          'p': Style(margin: Margins.zero),
        },
      ),
    );
  }
}

class _ToggleButton extends StatelessWidget {
  const _ToggleButton({
    required this.isOpen,
    required this.noun,
    required this.onPressed,
  });

  final bool isOpen;
  final String noun;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8),
      child: TextButton(
        onPressed: onPressed,
        style: TextButton.styleFrom(
          backgroundColor: _cardColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(5),
            side: const BorderSide(color: _borderColor),
          ),
        ),
        child: Text(isOpen ? 'Hide $noun' : 'Show $noun'),
      ),
    );
  }
}

class _ChallengeCard extends StatelessWidget {
  const _ChallengeCard({
    required this.title,
    required this.isCompleted,
    required this.onTap,
    this.isHeader = false,
  });

  final String title;
  final bool isCompleted;
  final VoidCallback onTap;
  final bool isHeader;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      clipBehavior: Clip.antiAlias,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(5),
        side: BorderSide(
          color: isCompleted ? _completedBorderColor : _borderColor,
        ),
      ),
      color: isCompleted ? _completedTileColor : _tileColor,
      child: InkWell(
        onTap: onTap,
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.all(16),
          child: Text(
            title,
            style: TextStyle(
              fontSize: 18,
              fontWeight: isHeader ? FontWeight.bold : null,
            ),
          ),
        ),
      ),
    );
  }
}

class _TileGrid extends StatelessWidget {
  const _TileGrid({
    required this.block,
    required this.challenges,
    required this.completed,
    this.scrollable = false,
  });

  final Block block;
  final List<ChallengeOrder> challenges;
  final Set<String> completed;
  final bool scrollable;

  int _stepNumber(ChallengeOrder challenge, int index) {
    final match = RegExp(r'\d+').firstMatch(challenge.title);
    return match != null ? int.parse(match.group(0)!) : index + 1;
  }

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      shrinkWrap: true,
      padding: EdgeInsets.zero,
      physics: scrollable
          ? const AlwaysScrollableScrollPhysics()
          : const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 6,
        mainAxisSpacing: 3,
        crossAxisSpacing: 3,
      ),
      itemCount: challenges.length,
      itemBuilder: (context, index) {
        final challenge = challenges[index];
        final isCompleted = completed.contains(challenge.id);

        return TextButton(
          onPressed: () => _openChallenge(context, block, challenge.id),
          style: TextButton.styleFrom(
            backgroundColor: isCompleted ? _completedTileColor : _tileColor,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(5),
              side: BorderSide(
                color: isCompleted ? _completedBorderColor : _borderColor,
              ),
            ),
          ),
          child: Text(
            '${_stepNumber(challenge, index)}',
            semanticsLabel:
                '${challenge.title}${isCompleted ? ', completed' : ''}',
          ),
        );
      },
    );
  }
}

class _StepGrid extends StatelessWidget {
  const _StepGrid({required this.block, required this.completed});

  final Block block;
  final Set<String> completed;

  @override
  Widget build(BuildContext context) {
    // NOTE: Past four rows the grid scrolls inside a fixed height.
    final scrollable = block.challenges.length > 24;

    return Container(
      padding: const EdgeInsets.all(8),
      constraints: const BoxConstraints(maxHeight: 300),
      child: ScrollShadow(
        child: _TileGrid(
          block: block,
          challenges: block.challenges,
          completed: completed,
          scrollable: scrollable,
        ),
      ),
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
        for (final (:header, :tasks) in sections) ...[
          _ChallengeCard(
            title: header.title,
            isHeader: true,
            isCompleted: completed.contains(header.id),
            onTap: () => _openChallenge(context, block, header.id),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(8, 4, 8, 12),
            child: _TileGrid(
              block: block,
              challenges: tasks,
              completed: completed,
            ),
          ),
        ],
      ],
    );
  }
}
