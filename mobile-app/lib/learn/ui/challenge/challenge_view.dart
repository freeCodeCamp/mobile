import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:freecodecamp/learn/ui/challenge/challenge_viewmodel.dart';
import 'package:freecodecamp/learn/ui/challenge/english_view.dart';
import 'package:freecodecamp/learn/ui/challenge/lesson_view.dart';
import 'package:freecodecamp/learn/ui/challenge/python_project_view.dart';
import 'package:freecodecamp/learn/ui/challenge/quiz_view.dart';
import 'package:freecodecamp/learn/ui/editor_challenge/editor_challenge_view.dart';
import 'package:freecodecamp/widgets/error_retry.dart';

class ChallengeView extends ConsumerWidget {
  const ChallengeView({
    super.key,
    required this.superBlock,
    required this.block,
    required this.challengeId,
  });

  final String superBlock;
  final String block;
  final String challengeId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final provider = challengeScreenProvider(superBlock, block, challengeId);

    return switch (ref.watch(provider)) {
      AsyncData(value: (:final challenge, :final block)) =>
        switch (challenge.challengeType) {
          // quiz
          8 => QuizView(
            key: ValueKey(challenge.id),
            challenge: challenge,
            block: block,
          ),
          // pythonProject
          10 => PythonProjectView(
            key: ValueKey(challenge.id),
            challenge: challenge,
            block: block,
          ),
          // video
          11 => LessonView(
            key: ValueKey(challenge.id),
            challenge: challenge,
            block: block,
          ),
          // theOdinProject
          15 => LessonView(
            key: ValueKey(challenge.id),
            challenge: challenge,
            block: block,
          ),
          // multipleChoice
          19 => LessonView(
            key: ValueKey(challenge.id),
            challenge: challenge,
            block: block,
          ),
          // generic
          24 => LessonView(
            key: ValueKey(challenge.id),
            challenge: challenge,
            block: block,
          ),
          // review
          31 => LessonView(
            key: ValueKey(challenge.id),
            challenge: challenge,
            block: block,
          ),
          // dialogue
          21 => EnglishView(
            key: ValueKey(challenge.id),
            challenge: challenge,
            block: block,
          ),
          // fillInTheBlank
          22 => EnglishView(
            key: ValueKey(challenge.id),
            challenge: challenge,
            block: block,
          ),
          // Editor challenges, including multi-file projects and labs.
          0 || 1 || 14 || 20 || 23 || 25 || 26 || 27 => EditorChallengeView(
            key: ValueKey(challenge.id),
            challenge: challenge,
            block: block,
          ),
          final type => _Message(
            child: Text(
              'This challenge type ($type) is not available in the app yet.',
              textAlign: TextAlign.center,
            ),
          ),
        },
      AsyncError() => _Message(
        child: ErrorRetry(
          message: 'Something went wrong!',
          onRetry: () => ref.invalidate(provider),
        ),
      ),
      _ => const _Message(child: CircularProgressIndicator()),
    };
  }
}

class _Message extends StatelessWidget {
  const _Message({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Center(
        child: Padding(padding: const EdgeInsets.all(16), child: child),
      ),
    );
  }
}
