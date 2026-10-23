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

    switch (ref.watch(provider)) {
      case AsyncData(value: (:final challenge, :final block)):
        switch (challenge.challengeType) {
          case 8: // quiz
            return QuizView(challenge: challenge, block: block);
          case 10: // pythonProject
            return PythonProjectView(challenge: challenge, block: block);
          case 11: // video
          case 15: // theOdinProject
          case 19: // multipleChoice
          case 24: // generic
          case 31: // review
            return LessonView(challenge: challenge, block: block);
          case 21: // dialogue
          case 22: // fillInTheBlank
            return EnglishView(challenge: challenge, block: block);
          case 0: // html
          case 1: // js
          case 14: // multifileCertProject
          case 20: // python
          case 23: // multifilePythonCertProject
          case 25: // lab
          case 26: // jsLab
          case 27: // pyLab
            return EditorChallengeView(challenge: challenge, block: block);
          default:
            return _Message(
              child: Text(
                'This challenge type (${challenge.challengeType}) is not available in the app yet.',
                textAlign: TextAlign.center,
              ),
            );
        }
      case AsyncError():
        return _Message(
          child: ErrorRetry(
            message: 'Something went wrong!',
            onRetry: () => ref.invalidate(provider),
          ),
        );
      default:
        return const _Message(child: CircularProgressIndicator());
    }
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
