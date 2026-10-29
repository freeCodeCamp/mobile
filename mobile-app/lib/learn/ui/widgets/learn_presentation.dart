import 'package:flutter/material.dart';
import 'package:freecodecamp/fcc_theme.dart';
import 'package:freecodecamp/learn/models/curriculum_model.dart';

Color blockLabelColor(BuildContext context, BlockLabel label) {
  final design = FccDesignColors.of(context);
  return switch (label) {
    BlockLabel.workshop || BlockLabel.practice => design.workshop,
    BlockLabel.lab || BlockLabel.learn => design.lab,
    BlockLabel.quiz || BlockLabel.review || BlockLabel.exam => design.quiz,
    _ => design.lecture,
  };
}

String blockUnit(Block block) => switch (block.label) {
  BlockLabel.lecture => 'lecture',
  BlockLabel.lab => 'lab',
  BlockLabel.quiz => 'quiz',
  BlockLabel.exam => 'exam',
  _ => block.layout == BlockLayout.challengeDialogue ? 'task' : 'step',
};

String countLabel(int count, String unit) =>
    '$count ${count == 1
        ? unit
        : unit == 'quiz'
        ? 'quizzes'
        : '${unit}s'}';

class LearnEyebrow extends StatelessWidget {
  const LearnEyebrow(this.text, {super.key, this.color});
  final String text;
  final Color? color;

  @override
  Widget build(BuildContext context) => Text(
    text.isEmpty ? text : '${text[0].toUpperCase()}${text.substring(1)}',
    style: TextStyle(
      fontFamily: 'Lato',
      fontSize: 13,
      height: 1.4,
      letterSpacing: 0,
      fontWeight: FontWeight.w700,
      color: color ?? Theme.of(context).colorScheme.onSurfaceVariant,
    ),
  );
}

class LearnProgress extends StatelessWidget {
  const LearnProgress({
    super.key,
    required this.done,
    required this.total,
    this.color,
    this.backgroundColor,
  });
  final int done;
  final int total;
  final Color? color;
  final Color? backgroundColor;

  @override
  Widget build(BuildContext context) => LinearProgressIndicator(
    value: total == 0 ? 0 : done / total,
    minHeight: 6,
    borderRadius: BorderRadius.circular(8),
    color: color ?? Theme.of(context).colorScheme.primary,
    backgroundColor:
        backgroundColor ?? Theme.of(context).colorScheme.outlineVariant,
    semanticsLabel: '$done of $total complete',
  );
}

class LearnStatus extends StatelessWidget {
  const LearnStatus({
    super.key,
    required this.complete,
    this.active = false,
    this.module = false,
    this.icon,
  });
  final bool complete;
  final bool active;
  final bool module;
  final IconData? icon;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final success = FccDesignColors.of(context).success;
    return Container(
      width: 26,
      height: 26,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: complete ? success : colors.surface,
        border: Border.all(
          color: complete
              ? success
              : active
              ? colors.primary
              : colors.outline,
          width: module ? 3 : 2,
        ),
      ),
      child: complete
          ? Icon(Icons.check, size: 18, color: colors.surface)
          : active
          ? Icon(Icons.circle, size: 8, color: colors.primary)
          : icon == null
          ? null
          : Icon(icon, size: 16, color: colors.onSurfaceVariant),
    );
  }
}
