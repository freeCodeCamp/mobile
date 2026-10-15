import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mobile_app_new/learn/models/challenge_model.dart';
import 'package:mobile_app_new/learn/ui/challenge/challenge_placeholder_view.dart';
import 'package:mobile_app_new/learn/ui/challenge/challenge_viewmodel.dart';
import 'package:mobile_app_new/learn/ui/challenge/english_view.dart';
import 'package:mobile_app_new/learn/ui/challenge/lesson_view.dart';
import 'package:mobile_app_new/learn/ui/challenge/python_project_view.dart';
import 'package:mobile_app_new/learn/ui/challenge/quiz_view.dart';
import 'package:mobile_app_new/widgets/error_retry.dart';

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
          8 => QuizView(challenge: challenge, block: block),
          // pythonProject
          10 => PythonProjectView(challenge: challenge, block: block),
          // video
          11 => LessonView(challenge: challenge, block: block),
          // theOdinProject
          15 => LessonView(challenge: challenge, block: block),
          // multipleChoice
          19 => LessonView(challenge: challenge, block: block),
          // generic
          24 => LessonView(challenge: challenge, block: block),
          // review
          31 => LessonView(challenge: challenge, block: block),
          // dialogue
          21 => EnglishView(challenge: challenge, block: block),
          // fillInTheBlank
          22 => EnglishView(challenge: challenge, block: block),
          // NOTE: The editor challenge types arrive in Learn iteration 4.
          // html
          0 => _editorPlaceholder(challenge),
          // js
          1 => _editorPlaceholder(challenge),
          // multifileCertProject
          14 => _editorPlaceholder(challenge),
          // python
          20 => _editorPlaceholder(challenge),
          // multifilePythonCertProject
          23 => _editorPlaceholder(challenge),
          // lab
          25 => _editorPlaceholder(challenge),
          // jsLab
          26 => _editorPlaceholder(challenge),
          // pyLab
          27 => _editorPlaceholder(challenge),
          // dailyChallengeJs
          28 => _editorPlaceholder(challenge),
          // dailyChallengePy
          29 => _editorPlaceholder(challenge),
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

Widget _editorPlaceholder(Challenge challenge) => ChallengePlaceholderView(
  details: '${challenge.title} (type ${challenge.challengeType})',
);

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
