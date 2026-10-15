import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mobile_app_new/auth/models/user_model.dart';
import 'package:mobile_app_new/learn/constants/curriculum.dart';
import 'package:mobile_app_new/learn/controllers/curriculum_controller.dart';
import 'package:mobile_app_new/learn/models/curriculum_model.dart';
import 'package:mobile_app_new/learn/services/curriculum_service.dart';
import 'package:mobile_app_new/services/auth_service.dart';

class LearningResume {
  const LearningResume({
    required this.course,
    required this.block,
    required this.challenge,
    required this.completed,
    required this.isReturning,
  });
  final SuperBlockSummary course;
  final Block block;
  final ChallengeOrder challenge;
  final int completed;
  int get step => block.challenges.indexOf(challenge) + 1;
  final bool isReturning;
}

Iterable<Block> availableLearningBlocks(SuperBlock curriculum) =>
    switch (curriculum) {
      BlockSuperBlock(:final blocks) => blocks.where(
        (b) => !b.isDisabledByOverride,
      ),
      ChapterSuperBlock(:final chapters) =>
        chapters
            .where(
              (c) =>
                  !c.comingSoon &&
                  !hiddenExamChapters.contains(c.dashedName) &&
                  (!devOnlyChapters.contains(c.dashedName) ||
                      (dotenv.isInitialized &&
                          dotenv.getBool('DEVELOPMENT_MODE', fallback: false))),
            )
            .expand(
              (c) => c.modules.where(
                (m) => !m.comingSoon && m.moduleType != ModuleType.exam,
              ),
            )
            .expand((m) => m.blocks.where((b) => !b.isDisabledByOverride)),
    };

LearningResume? resolveLearningResume(
  List<(SuperBlockSummary, SuperBlock)> courses,
  FccUserModel? user,
) {
  final completed = {
    for (final c in user?.completedChallenges ?? <CompletedChallenge>[])
      c.id: c.completedDate,
  };
  final entries = [
    for (final (course, curriculum) in courses)
      for (final block in availableLearningBlocks(curriculum)) (course, block),
  ];
  LearningResume? candidate(
    (SuperBlockSummary, Block) entry, {
    String? preferred,
  }) {
    final (course, block) = entry;
    final remaining = block.challenges.where(
      (c) => !completed.containsKey(c.id),
    );
    if (remaining.isEmpty) return null;
    final challenge =
        remaining.where((c) => c.id == preferred).firstOrNull ??
        remaining.first;
    return LearningResume(
      course: course,
      block: block,
      challenge: challenge,
      isReturning: user?.currentChallengeId != null || completed.isNotEmpty,
      completed: block.challenges
          .where((c) => completed.containsKey(c.id))
          .length,
    );
  }

  for (final entry in entries) {
    if (entry.$2.challenges.any((c) => c.id == user?.currentChallengeId)) {
      final result = candidate(entry, preferred: user?.currentChallengeId);
      if (result != null) return result;
      // A completed block continues into the next available block in its course.
      for (final next
          in entries
              .skip(entries.indexOf(entry) + 1)
              .where((e) => e.$1 == entry.$1)) {
        final result = candidate(next);
        if (result != null) return result;
      }
    }
  }
  final recent = completed.entries.toList()
    ..sort((a, b) => b.value.compareTo(a.value));
  for (final done in recent) {
    final index = entries.indexWhere(
      (e) => e.$2.challenges.any((c) => c.id == done.key),
    );
    if (index < 0) continue;
    final course = entries[index].$1;
    for (final entry in entries.skip(index).where((e) => e.$1 == course)) {
      final result = candidate(entry);
      if (result != null) return result;
    }
  }
  for (final entry in entries) {
    final result = candidate(entry);
    if (result != null) return result;
  }
  return null;
}

final learningResumeProvider = FutureProvider.autoDispose<LearningResume?>((
  ref,
) async {
  final userFuture = ref.watch(authProvider.future);
  final stagesFuture = ref.watch(curriculumStagesProvider.future);
  final user = await userFuture;
  final stages = await stagesFuture;
  if (!ref.mounted) return null;
  final courses = stages
      .expand((s) => s.superBlocks)
      .where((c) => c.isPublic && !c.isDisabledByOverride)
      .toList();
  if (courses.isEmpty) return null;
  final returning =
      user?.currentChallengeId != null ||
      (user?.completedChallenges.isNotEmpty ?? false);
  final toLoad = returning ? courses : courses.take(1);
  final results = await Future.wait([
    for (final course in toLoad)
      ref
          .watch(superBlockProvider(course.dashedName).future)
          .then<(SuperBlockSummary, SuperBlock)?>(
            (value) => (course, value),
            onError: (_) => null,
          ),
  ]);
  final loaded = results.whereType<(SuperBlockSummary, SuperBlock)>().toList();
  if (loaded.length != toLoad.length) {
    throw StateError('Could not load your next step');
  }
  return resolveLearningResume(loaded, user);
});

/// Retrying must refresh the source futures as well as the derived selection.
void retryLearningResume(WidgetRef ref) {
  final stages = ref.read(curriculumStagesProvider).value;
  for (final stage in stages ?? const <CurriculumStage>[]) {
    for (final course in stage.superBlocks) {
      if (course.isPublic && !course.isDisabledByOverride) {
        ref.invalidate(superBlockProvider(course.dashedName));
      }
    }
  }
  ref.invalidate(learningResumeProvider);
}
