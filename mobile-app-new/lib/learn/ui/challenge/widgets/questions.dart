import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:mobile_app_new/fcc_theme.dart';
import 'package:mobile_app_new/learn/models/challenge_model.dart';
import 'package:mobile_app_new/learn/ui/challenge/widgets/challenge_card.dart';
import 'package:mobile_app_new/learn/ui/challenge/widgets/quiz_audio_player.dart';
import 'package:mobile_app_new/widgets/html_handler/html_handler.dart';

typedef QuestionItem = ({
  String text,
  List<Answer> answers,
  // NOTE: 0-based index into answers.
  int solution,
  QuizAudioData? audioData,
});

QuestionItem questionItem(Question q) => (
  text: q.text,
  answers: q.answers,
  solution: q.solution - 1,
  audioData: null,
);

class Questions extends StatefulWidget {
  const Questions({
    super.key,
    required this.questions,
    required this.selected,
    required this.validated,
    required this.onChanged,
  });

  final List<QuestionItem> questions;
  final List<int?> selected;
  final bool validated;
  final void Function(int question, int answer) onChanged;

  @override
  State<Questions> createState() => _QuestionsState();
}

class _QuestionsState extends State<Questions> {
  late List<List<Widget>> _texts;
  late List<List<List<Widget>>> _answers;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _parse();
  }

  @override
  void didUpdateWidget(Questions oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (!identical(oldWidget.questions, widget.questions)) _parse();
  }

  void _parse() {
    final parser = HTMLParser(context: context);
    _texts = [for (final q in widget.questions) parser.parse(q.text)];
    _answers = [
      for (final q in widget.questions)
        [
          for (final a in q.answers)
            parser.parse(
              a.answer,
              isSelectable: false,
              customStyles: {'p': Style(margin: Margins.zero)},
            ),
        ],
    ];
  }

  @override
  Widget build(BuildContext context) {
    final multiple = widget.questions.length > 1;

    return Column(
      children: [
        for (final (i, question) in widget.questions.indexed)
          ChallengeCard(
            title: multiple ? 'Question ${i + 1}' : 'Question',
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ..._texts[i],
                if (question.audioData case final audio?) ...[
                  const SizedBox(height: 16),
                  QuizAudioPlayer(audioData: audio),
                ],
                const SizedBox(height: 8),
                RadioGroup<int>(
                  groupValue: widget.selected[i],
                  onChanged: (answer) {
                    if (answer != null) widget.onChanged(i, answer);
                  },
                  child: Column(
                    children: [
                      for (final (j, answer) in question.answers.indexed)
                        _option(i, j, answer),
                    ],
                  ),
                ),
              ],
            ),
          ),
      ],
    );
  }

  Widget _option(int question, int index, Answer answer) {
    final isSelected = widget.selected[question] == index;
    final isCorrect = widget.questions[question].solution == index;

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: Material(
        child: RadioListTile<int>(
          value: index,
          selected: isSelected,
          tileColor: FccColors.gray90,
          selectedTileColor: FccColors.gray90,
          shape: const RoundedRectangleBorder(
            side: BorderSide(color: Color(0xFFAAAAAA), width: 2),
          ),
          title: ConstrainedBox(
            constraints: const BoxConstraints(minHeight: 100),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: _answers[question][index],
            ),
          ),
          subtitle: isSelected && widget.validated
              ? _Feedback(isCorrect: isCorrect, feedback: answer.feedback)
              : null,
        ),
      ),
    );
  }
}

class _Feedback extends StatelessWidget {
  const _Feedback({required this.isCorrect, required this.feedback});

  final bool isCorrect;
  final String? feedback;

  @override
  Widget build(BuildContext context) {
    final color = isCorrect ? FccColors.green40 : FccColors.red15;
    final feedback = this.feedback ?? '';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.only(left: 12, bottom: feedback.isEmpty ? 24 : 0),
          child: Text(
            isCorrect ? 'Correct!' : 'Incorrect!',
            style: TextStyle(
              color: color,
              fontWeight: FontWeight.bold,
              fontSize: 18,
            ),
          ),
        ),
        if (feedback.isNotEmpty)
          ...HTMLParser(context: context).parse(
            feedback,
            customStyles: {'*:not(pre):not(code)': Style(color: color)},
          ),
      ],
    );
  }
}
