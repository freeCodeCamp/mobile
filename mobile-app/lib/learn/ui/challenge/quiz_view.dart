import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:freecodecamp/fcc_theme.dart';
import 'package:freecodecamp/learn/models/challenge_model.dart';
import 'package:freecodecamp/learn/models/curriculum_model.dart';
import 'package:freecodecamp/learn/ui/challenge/widgets/challenge_button.dart';
import 'package:freecodecamp/learn/ui/challenge/widgets/challenge_card.dart';
import 'package:freecodecamp/learn/ui/challenge/widgets/complete_button.dart';
import 'package:freecodecamp/learn/ui/challenge/widgets/parsed_html.dart';
import 'package:freecodecamp/learn/ui/challenge/widgets/questions.dart';
import 'package:freecodecamp/widgets/dialog/confirm_dialog.dart';

// NOTE: The quiz picks one of its question sets at random and shuffles each question's answers.
List<QuestionItem> _pickQuestions(List<Quiz> quizzes) {
  if (quizzes.isEmpty) return const [];

  final random = Random();
  final quiz = quizzes[random.nextInt(quizzes.length)];

  return [
    for (final q in quiz.questions)
      () {
        final answers = [
          for (final text in [...q.distractors, q.answer]) Answer(answer: text),
        ]..shuffle(random);

        return (
          text: q.text,
          answers: answers,
          solution: answers.indexWhere((a) => a.answer == q.answer),
          audioData: q.audioData,
        );
      }(),
  ];
}

class QuizView extends StatefulWidget {
  const QuizView({super.key, required this.challenge, required this.block});

  final Challenge challenge;
  final Block block;

  @override
  State<QuizView> createState() => _QuizViewState();
}

class _QuizViewState extends State<QuizView> {
  static const _passRate = 0.9;

  late final _questions = _pickQuestions(widget.challenge.quizzes);
  late List<int?> _selected = List.filled(_questions.length, null);
  bool _validated = false;
  String _message = '';

  int get _correct => [
    for (final (i, q) in _questions.indexed)
      if (_selected[i] == q.solution) q,
  ].length;

  bool get _passed =>
      _validated && _correct >= (_questions.length * _passRate).ceil();

  void _check() {
    final unanswered = [
      for (final (i, answer) in _selected.indexed)
        if (answer == null) i + 1,
    ];

    setState(() {
      if (unanswered.isNotEmpty) {
        _message =
            'The following questions are unanswered: ${unanswered.join(', ')}. You must answer all questions.';
        return;
      }

      _validated = true;
      final total = _questions.length;
      _message = _passed
          ? '✅ You have $_correct out of $total questions correct. You have passed.'
          : '❌ You have $_correct out of $total questions correct. You did not pass.';
    });
  }

  void _reset() => setState(() {
    _selected = List.filled(_questions.length, null);
    _validated = false;
    _message = '';
  });

  @override
  Widget build(BuildContext context) {
    final challenge = widget.challenge;
    final gray = {
      '*:not(h1):not(h2):not(h3):not(h4):not(h5):not(h6)': Style(
        color: FccColors.gray05,
      ),
    };

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, _) async {
        if (didPop) return;

        final leave = await showConfirmDialog(
          context,
          title: 'Are you sure?',
          description:
              'Do you want to leave this quiz? Your progress will be lost.',
          confirmLabel: 'Leave',
          destructive: true,
        );
        if (leave && context.mounted) Navigator.of(context).pop();
      },
      child: Scaffold(
        backgroundColor: FccColors.gray90,
        appBar: AppBar(backgroundColor: FccColors.gray90),
        body: SafeArea(
          bottom: false,
          child: ListView(
            padding: const EdgeInsets.only(bottom: 16),
            children: [
              ChallengeCard(
                title: challenge.title,
                child: Column(
                  children: [
                    ParsedHtml(challenge.description, customStyles: gray),
                    ParsedHtml(challenge.instructions, customStyles: gray),
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
                  _message = '';
                }),
              ),
            ],
          ),
        ),
        bottomNavigationBar: Container(
          decoration: BoxDecoration(
            color: FccColors.gray80,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.3),
                blurRadius: 4,
                offset: const Offset(0, -2),
              ),
            ],
          ),
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(4),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  if (_message.isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.fromLTRB(8, 8, 8, 4),
                      child: Text(
                        _message,
                        style: const TextStyle(fontSize: 18),
                      ),
                    ),
                  if (_passed)
                    CompleteButton(
                      challenge: challenge,
                      block: widget.block,
                      label: 'Next Challenge',
                    )
                  else
                    ChallengeButton(
                      label: _validated ? 'Try Again' : 'Check your Answer',
                      onPressed: _validated ? _reset : _check,
                    ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
