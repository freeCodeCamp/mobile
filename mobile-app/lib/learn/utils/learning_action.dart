import 'package:freecodecamp/learn/models/curriculum_model.dart';

class LearningAction {
  const LearningAction({
    required this.block,
    required this.next,
    required this.hasProgress,
  });

  final Block block;
  final ChallengeOrder? next;
  final bool hasProgress;

  String label({bool chapter = false}) {
    final single = _singleUnit(block);
    if (next == null) {
      if (chapter || single == 'review') return 'Review';
      return single == null
          ? 'Review ${pluralUnit(_numberedUnit(block))}'
          : 'Review $single';
    }
    final verb = hasProgress ? 'Continue' : 'Start';
    if (chapter) return verb;
    if (single != null) return '$verb $single';
    return '$verb ${_numberedUnit(block)} ${block.challenges.indexOf(next!) + 1}';
  }
}

// Labs, quizzes, reviews and exams are one unit each, so labels never number them.
String? _singleUnit(Block block) => switch (block.label) {
  BlockLabel.lab => 'lab',
  BlockLabel.quiz => 'quiz',
  BlockLabel.review => 'review',
  BlockLabel.exam => 'exam',
  _ => null,
};

String _numberedUnit(Block block) => switch (block.label) {
  BlockLabel.lecture => 'theory',
  _ => block.layout == BlockLayout.challengeDialogue ? 'task' : 'step',
};

String pluralUnit(String unit) => switch (unit) {
  'quiz' => 'quizzes',
  'theory' => 'theories',
  _ => '${unit}s',
};

// Progress counts say lessons for lecture blocks; CTA labels keep the theory wording.
String _countUnit(Block block) => switch (block.label) {
  BlockLabel.lecture => 'lesson',
  _ => _numberedUnit(block),
};

// '11 steps', '2 lessons'; null for single-unit blocks, which show no count.
String? blockUnitCount(Block block, {int? done}) {
  if (_singleUnit(block) != null) return null;
  final total = block.challenges.length;
  final unit = _countUnit(block);
  final units = '$total ${total == 1 ? unit : pluralUnit(unit)}';
  return done == null ? units : '$done of $units';
}

LearningAction? resolveLearningAction(
  Iterable<Block> blocks,
  Set<String> completed, {
  String? currentChallengeId,
}) {
  final available = blocks
      .where(
        (block) =>
            !block.isDisabledByOverride &&
            block.label != BlockLabel.exam &&
            block.challenges.isNotEmpty,
      )
      .toList();
  if (available.isEmpty) return null;
  final hasProgress = completed.isNotEmpty;
  if (hasProgress && currentChallengeId != null) {
    final index = available.indexWhere(
      (block) => block.challenges.any((c) => c.id == currentChallengeId),
    );
    if (index >= 0) {
      for (final block in available.skip(index)) {
        final remaining = block.challenges.where(
          (challenge) => !completed.contains(challenge.id),
        );
        final next =
            remaining.where((c) => c.id == currentChallengeId).firstOrNull ??
            remaining.firstOrNull;
        if (next != null) {
          return LearningAction(block: block, next: next, hasProgress: true);
        }
      }
    }
  }
  for (final block in available) {
    final next = block.challenges
        .where((challenge) => !completed.contains(challenge.id))
        .firstOrNull;
    if (next != null) {
      return LearningAction(block: block, next: next, hasProgress: hasProgress);
    }
  }
  return LearningAction(block: available.first, next: null, hasProgress: true);
}
