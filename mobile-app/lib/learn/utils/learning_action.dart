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
    if (next == null) return chapter ? 'Review' : 'Review steps';
    final verb = hasProgress ? 'Continue' : 'Start';
    return chapter ? verb : '$verb step ${block.challenges.indexOf(next!) + 1}';
  }
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
