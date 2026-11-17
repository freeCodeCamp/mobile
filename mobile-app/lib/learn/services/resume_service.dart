import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:freecodecamp/auth/models/user_model.dart';
import 'package:freecodecamp/learn/constants/curriculum.dart';
import 'package:freecodecamp/learn/models/curriculum_model.dart';
import 'package:freecodecamp/learn/models/location_model.dart';
import 'package:freecodecamp/learn/models/resume_model.dart';
import 'package:freecodecamp/learn/utils/learning_action.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'resume_service.g.dart';

@riverpod
LearnResumeService learnResumeService(Ref ref) => const LearnResumeService();

class LearnResumeService {
  const LearnResumeService();

  Future<LearningResume?> load(
    Iterable<SuperBlockSummary> summaries,
    FccUserModel? user, {
    LearnLocation? savedLocation,
    required Future<SuperBlock> Function(String) loadCurriculum,
    required bool Function() isActive,
  }) async {
    final courses = summaries
        .where((course) => course.isPublic && !course.isDisabledByOverride)
        .toList();
    if (courses.isEmpty) return null;
    final completed = user?.completedChallenges ?? const <CompletedChallenge>[];
    final cached = <String, SuperBlock>{};
    if (savedLocation != null) {
      final savedCourse = courses
          .where((course) => course.dashedName == savedLocation.superBlock)
          .firstOrNull;
      if (savedCourse != null) {
        if (!isActive()) return null;
        final curriculum = await loadCurriculum(savedCourse.dashedName);
        if (!isActive()) return null;
        cached[savedCourse.dashedName] = curriculum;
        final result = _ResumeSelection([
          (savedCourse, curriculum),
        ], user).fromSavedLocation(savedLocation);
        if (result != null) return result;
      }
    }
    if (!isActive()) return null;
    if (completed.isNotEmpty) {
      final loaded = await Future.wait(
        courses.map(
          (course) async => (
            course,
            cached[course.dashedName] ??
                await loadCurriculum(course.dashedName),
          ),
        ),
      );
      if (!isActive()) return null;
      return resolveLearningResume(loaded, user);
    }
    final loaded = <(SuperBlockSummary, SuperBlock)>[];
    for (final course in courses) {
      if (!isActive()) return null;
      final curriculum =
          cached[course.dashedName] ?? await loadCurriculum(course.dashedName);
      if (!isActive()) return null;
      loaded.add((course, curriculum));
      final result = resolveLearningResume(loaded, user);
      if (result != null) return result;
    }
    return resolveLearningResume(loaded, user);
  }
}

Iterable<Block> availableLearningBlocks(SuperBlock curriculum) =>
    switch (curriculum) {
      BlockSuperBlock(:final blocks) => blocks.where(
        (b) => !b.isDisabledByOverride && b.label != BlockLabel.exam,
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
  final selection = _ResumeSelection(courses, user);
  final current = selection.fromCurrentChallenge();
  if (current != null) return current;
  for (final id in selection.recentChallengeIds) {
    final result = selection.fromCompletedChallenge(id);
    if (result != null) return result;
  }
  return selection.firstAvailable();
}

class _ResumeSelection {
  _ResumeSelection(List<(SuperBlockSummary, SuperBlock)> courses, this.user)
    : completed = {
        for (final c in user?.completedChallenges ?? <CompletedChallenge>[])
          c.id: c.completedDate,
      },
      entries = [
        for (final (course, curriculum) in courses)
          for (final block in availableLearningBlocks(curriculum))
            (course, block),
      ];

  final FccUserModel? user;
  final Map<String, DateTime> completed;
  final List<(SuperBlockSummary, Block)> entries;

  bool get hasCurrentChallenge =>
      user?.currentChallengeId?.trim().isNotEmpty ?? false;

  Iterable<String> get recentChallengeIds {
    final recent = completed.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));
    return recent.map((entry) => entry.key);
  }

  LearningResume? fromSavedLocation(LearnLocation location) {
    final index = entries.indexWhere(
      (entry) =>
          entry.$1.dashedName == location.superBlock &&
          entry.$2.dashedName == location.block &&
          entry.$2.label != BlockLabel.exam &&
          entry.$2.challenges.any((c) => c.id == location.challengeId),
    );
    if (index < 0) return null;
    final entry = entries[index];
    if (!completed.containsKey(location.challengeId)) {
      return LearningResume(
        course: entry.$1,
        block: entry.$2,
        challenge: entry.$2.challenges.firstWhere(
          (c) => c.id == location.challengeId,
        ),
        isReturning: true,
        completed: entry.$2.challenges
            .where((c) => completed.containsKey(c.id))
            .length,
      );
    }
    for (final candidate
        in entries.skip(index).where((e) => e.$1 == entry.$1)) {
      final result = _candidate(candidate);
      if (result != null) return result.copyWith(isReturning: true);
    }
    return null;
  }

  LearningResume? fromCurrentChallenge() {
    if (completed.isEmpty || !hasCurrentChallenge) return null;
    for (final (index, entry) in entries.indexed) {
      if (!entry.$2.challenges.any((c) => c.id == user?.currentChallengeId)) {
        continue;
      }
      final result = _candidate(entry, preferred: user?.currentChallengeId);
      if (result != null) return result;
      for (final next
          in entries.skip(index + 1).where((e) => e.$1 == entry.$1)) {
        final result = _candidate(next);
        if (result != null) return result;
      }
    }
    return null;
  }

  LearningResume? fromCompletedChallenge(String id) {
    final index = entries.indexWhere(
      (entry) => entry.$2.challenges.any((c) => c.id == id),
    );
    if (index < 0) return null;
    final course = entries[index].$1;
    for (final entry in entries.skip(index).where((e) => e.$1 == course)) {
      final result = _candidate(entry);
      if (result != null) return result;
    }
    return null;
  }

  LearningResume? firstAvailable() {
    for (final entry in entries) {
      final result = _candidate(entry);
      if (result != null) return result;
    }
    return null;
  }

  LearningResume? _candidate(
    (SuperBlockSummary, Block) entry, {
    String? preferred,
  }) {
    final (course, block) = entry;
    final action = resolveLearningAction(
      [block],
      completed.keys.toSet(),
      currentChallengeId: preferred,
    );
    final challenge = action?.next;
    if (challenge == null) return null;
    return LearningResume(
      course: course,
      block: block,
      challenge: challenge,
      isReturning: completed.isNotEmpty,
      completed: block.challenges
          .where((c) => completed.containsKey(c.id))
          .length,
    );
  }
}
