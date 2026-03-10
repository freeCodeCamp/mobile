import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:freecodecamp/models/learn/challenge_model.dart';
import 'package:freecodecamp/ui/theme/fcc_theme.dart';
import 'package:freecodecamp/ui/views/learn/widgets/challenge_card.dart';
import 'package:freecodecamp/ui/views/learn/widgets/quiz_audio_player.dart';
import 'package:freecodecamp/ui/views/news/html_handler/html_handler.dart';

// Model that extends Question with selectedAnswer and validation status
class QuizWidgetQuestion {
  final String text;
  final List<Answer> answers;
  final int solution;
  final QuizAudioData? audioData;
  int selectedAnswer;
  bool? isCorrect;

  QuizWidgetQuestion({
    required this.text,
    required this.answers,
    required this.solution,
    this.audioData,
    this.selectedAnswer = -1,
    this.isCorrect,
  });
}

class QuizWidget extends StatefulWidget {
  final List<QuizWidgetQuestion> questions;
  final Function(int, int) onChanged;
  final bool? isValidated;

  const QuizWidget({
    super.key,
    required this.questions,
    required this.onChanged,
    this.isValidated,
  });

  @override
  State<QuizWidget> createState() => _QuizWidgetState();
}

class _QuizWidgetState extends State<QuizWidget> {
  late final HTMLParser parser;
  late List<List<Widget>> parsedQuestions;
  late List<List<List<Widget>>> parsedOptions;

  @override
  void initState() {
    super.initState();
    parser = HTMLParser(context: context);
    _parseAll();
  }

  @override
  void didUpdateWidget(covariant QuizWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (_areQuestionsChanged(oldWidget.questions, widget.questions)) {
      _parseAll();
    }
  }

  bool _areQuestionsChanged(List<QuizWidgetQuestion> oldQuestions,
      List<QuizWidgetQuestion> newQuestions) {
    if (oldQuestions.length != newQuestions.length) {
      return true;
    }

    for (int i = 0; i < oldQuestions.length; i++) {
      // Only check for selectedAnswer changes as the other information is not changed between updates
      if (oldQuestions[i].selectedAnswer != newQuestions[i].selectedAnswer) {
        return true;
      }
    }

    return false;
  }

  void _parseAll() {
    parsedQuestions =
        widget.questions.map((q) => parser.parse(q.text)).toList();
    parsedOptions = widget.questions
        .map((q) => q.answers
            .map((a) => parser.parse(
                  a.answer,
                  isSelectable: false,
                  customStyles: {
                    'p': Style(margin: Margins.zero),
                  },
                ))
            .toList())
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: widget.questions.length,
      itemBuilder: (context, index) {
        return quizQuestion(
          context: context,
          questionNumber: widget.questions.length > 1 ? index + 1 : null,
          questionIndex: index,
        );
      },
    );
  }

  ChallengeCard quizQuestion({
    required BuildContext context,
    required int questionIndex,
    int? questionNumber,
  }) {
    final question = widget.questions[questionIndex];
    final selectedAnswer = question.selectedAnswer;
    return ChallengeCard(
      title: questionNumber != null ? 'Question $questionNumber' : 'Question',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ...parsedQuestions[questionIndex],
          if (question.audioData != null) ...[
            const SizedBox(height: 16),
            QuizAudioPlayer(audioData: question.audioData!),
          ],
          const SizedBox(height: 8),
          RadioGroup<int>(
            groupValue: selectedAnswer,
            onChanged: (value) {
              widget.onChanged(questionIndex, value ?? -1);
            },
            child: Column(
              children: [
                for (final answerObj in question.answers.asMap().entries) ...[
                  option(
                    context: context,
                    answerObj: answerObj,
                    questionIndex: questionIndex,
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  Container option({
    required BuildContext context,
    required MapEntry<int, Answer> answerObj,
    required int questionIndex,
  }) {
    final question = widget.questions[questionIndex];
    final selectedAnswer = question.selectedAnswer;
    final isCorrect = question.isCorrect;
    final isSelected = answerObj.key == selectedAnswer;
    final optionWidgets = parsedOptions[questionIndex][answerObj.key];

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: Material(
        child: RadioListTile<int>(
          key: ValueKey(answerObj.key),
          selected: isSelected,
          tileColor: const Color(0xFF0a0a23),
          selectedTileColor: const Color(0xFF0a0a23),
          value: answerObj.key,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(0),
            side: BorderSide(
              color: const Color(0xFFAAAAAA),
              width: 2,
            ),
          ),
          title: Align(
            alignment: Alignment.centerLeft,
            child: ConstrainedBox(
              constraints: const BoxConstraints(
                minHeight: 100,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: optionWidgets,
              ),
            ),
          ),
          subtitle: isSelected && widget.isValidated == true
              ? validationStatusAndFeedback(
                  context: context,
                  isCorrect: isCorrect,
                  feedback: answerObj.value.feedback,
                )
              : null,
        ),
      ),
    );
  }

  Widget validationStatusAndFeedback({
    required BuildContext context,
    bool? isCorrect,
    String? feedback,
  }) {
    HTMLParser parser = HTMLParser(context: context);
    final List<Widget> feedbackWidgets = [];

    if (isCorrect == null) {
      return const SizedBox.shrink();
    }

    feedbackWidgets.add(
      Padding(
        padding: EdgeInsets.only(left: 12, bottom: feedback == null ? 24 : 0),
        child: Text(
          isCorrect && isCorrect == true ? 'Correct!' : 'Incorrect!',
          style: TextStyle(
            color: isCorrect && isCorrect == true
                ? FccColors.green40
                : FccColors.red15,
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
      ),
    );

    if (feedback != null && feedback.isNotEmpty) {
      feedbackWidgets.addAll(
        parser.parse(
          feedback,
          customStyles: {
            '*:not(pre):not(code)': Style(
              color: isCorrect == true ? FccColors.green40 : FccColors.red15,
            ),
          },
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: feedbackWidgets,
    );
  }
}
