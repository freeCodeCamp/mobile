import 'package:flutter/material.dart';
import 'package:mobile_app_new/learn/models/challenge_model.dart';
import 'package:mobile_app_new/learn/models/curriculum_model.dart';
import 'package:mobile_app_new/learn/ui/challenge/widgets/challenge_card.dart';
import 'package:mobile_app_new/learn/ui/challenge/widgets/html_card.dart';
import 'package:mobile_app_new/learn/ui/challenge/widgets/challenge_button.dart';
import 'package:mobile_app_new/learn/ui/challenge/widgets/complete_button.dart';
import 'package:mobile_app_new/learn/ui/challenge/widgets/assignment_tile.dart';
import 'package:mobile_app_new/learn/ui/challenge/widgets/example_editor.dart';
import 'package:mobile_app_new/learn/ui/challenge/widgets/challenge_video.dart';
import 'package:mobile_app_new/learn/ui/challenge/challenge_viewmodel.dart';
import 'package:mobile_app_new/learn/ui/challenge/widgets/help_dialog.dart';
import 'package:mobile_app_new/learn/ui/challenge/widgets/questions.dart';
import 'package:mobile_app_new/learn/ui/challenge/widgets/scene/scene_view.dart';

class LessonView extends StatefulWidget {
  const LessonView({super.key, required this.challenge, required this.block});

  final Challenge challenge;
  final Block block;

  @override
  State<LessonView> createState() => _LessonViewState();
}

class _LessonViewState extends State<LessonView> {
  late final _questions = widget.challenge.questions.map(questionItem).toList();
  late final _selected = List<int?>.filled(_questions.length, null);
  late final _assignments = List.filled(
    widget.challenge.assignments.length,
    false,
  );
  bool _validated = false;

  bool get _passed => [
    for (final (i, q) in _questions.indexed) _selected[i] == q.solution,
  ].every((correct) => correct);

  bool get _canCheck =>
      _assignments.every((done) => done) && !_selected.contains(null);

  @override
  Widget build(BuildContext context) {
    final challenge = widget.challenge;
    final hasQuestions = _questions.isNotEmpty;
    final showHelp = ![24, 31].contains(challenge.challengeType);

    return Scaffold(
      appBar: AppBar(title: Text(challengeTitle(challenge, widget.block))),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.only(bottom: 50),
          children: [
            if (challenge.description.isNotEmpty)
              HtmlCard(title: 'Description', html: challenge.description),
            if (challenge.nodules.isNotEmpty)
              ExampleEditor(nodules: challenge.nodules),
            if (challenge.videoId case final videoId?)
              ChallengeCard(
                title: 'Watch the Video',
                child: ChallengeVideo(videoId: videoId),
              ),
            if (challenge.transcript.isNotEmpty)
              HtmlCard(
                title: 'Transcript',
                html: challenge.transcript,
                collapsible: challenge.videoId != null,
              ),
            if (challenge.scene case final scene?)
              ChallengeCard(
                title: 'Scene',
                child: SceneView(scene: scene, title: challenge.title),
              ),
            if (challenge.instructions.isNotEmpty)
              HtmlCard(title: 'Instructions', html: challenge.instructions),
            if (challenge.assignments.isNotEmpty)
              ChallengeCard(
                title: 'Assignments',
                child: Column(
                  children: [
                    for (final (i, assignment) in challenge.assignments.indexed)
                      AssignmentTile(
                        label: assignment,
                        value: _assignments[i],
                        onToggle: () =>
                            setState(() => _assignments[i] = !_assignments[i]),
                      ),
                  ],
                ),
              ),
            Questions(
              questions: _questions,
              selected: _selected,
              validated: _validated,
              onChanged: (question, answer) => setState(() {
                _selected[question] = answer;
                _validated = false;
              }),
            ),
            if (challenge.explanation.isNotEmpty)
              HtmlCard(
                title: 'Explanation',
                html: challenge.explanation,
                collapsible: true,
              ),
            if (_validated && !_passed && _questions.length > 1)
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Text(
                  'Some answers are incorrect.',
                  style: TextStyle(fontSize: 18),
                ),
              ),
            if (!hasQuestions || (_validated && _passed))
              CompleteButton(
                challenge: challenge,
                block: widget.block,
                label: hasQuestions ? 'Next Challenge' : 'Next',
                enabled: _canCheck,
              )
            else
              ChallengeButton(
                label: _validated ? 'Try Again' : 'Check your Answer',
                onPressed: _canCheck
                    ? () => setState(() => _validated = true)
                    : null,
              ),
            if (showHelp)
              ChallengeButton(
                label: 'Ask for Help',
                onPressed: () =>
                    showHelpDialog(context, challenge, widget.block),
              ),
          ],
        ),
      ),
    );
  }
}
