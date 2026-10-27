import 'package:flutter/material.dart';
import 'package:freecodecamp/fcc_theme.dart';
import 'package:freecodecamp/learn/models/curriculum_model.dart';

Color blockLabelColor(BuildContext context, BlockLabel label) {
  final dark = Theme.of(context).brightness == Brightness.dark;
  return switch (label) {
    BlockLabel.workshop ||
    BlockLabel.practice => Color(dark ? 0xFFC8B0FF : 0xFF8B3FD9),
    BlockLabel.lab || BlockLabel.learn => Color(dark ? 0xFF5FD3D6 : 0xFF1E7F46),
    BlockLabel.quiz ||
    BlockLabel.review ||
    BlockLabel.exam => Color(dark ? 0xFFFFAF85 : 0xFFB93D0A),
    _ => Color(dark ? 0xFF8EC5FF : 0xFF1F6FD1),
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
      fontSize: 11,
      height: 1.4,
      letterSpacing: 0,
      fontWeight: FontWeight.w600,
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
    minHeight: 5,
    borderRadius: BorderRadius.circular(8),
    color: color ?? Theme.of(context).colorScheme.primary,
    backgroundColor:
        backgroundColor ?? Theme.of(context).colorScheme.outlineVariant,
    semanticsLabel: '$done of $total complete',
  );
}

class LearnStatus extends StatelessWidget {
  const LearnStatus({super.key, required this.complete, this.active = false});
  final bool complete;
  final bool active;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final success = FccDesignColors.of(context).success;
    return Container(
      width: 28,
      height: 28,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: complete ? success : colors.surface,
        border: Border.all(
          color: complete
              ? success
              : active
              ? colors.primary
              : colors.outlineVariant,
          width: active ? 2 : 1.5,
        ),
      ),
      child: complete
          ? Icon(Icons.check, size: 18, color: colors.surface)
          : active
          ? Icon(Icons.circle, size: 11, color: colors.primary)
          : null,
    );
  }
}
