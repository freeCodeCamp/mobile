import 'package:flutter/material.dart';
import 'package:freecodecamp/models/learn/challenge_model.dart';
import 'package:freecodecamp/ui/theme/fcc_theme.dart';
import 'package:freecodecamp/ui/views/learn/widgets/challenge_card.dart';
import 'package:freecodecamp/ui/views/news/html_handler/html_handler.dart';

// Model that extends Question with selectedAnswer and validation status
class QuizQuestion {
  final String text;
  final List<Answer> answers;
  final int solution;
  int selectedAnswer;
  bool? isCorrect;

  QuizQuestion({
    required this.text,
    required this.answers,
    required this.solution,
    this.selectedAnswer = -1,
    this.isCorrect,
  });
}

class Quiz extends StatelessWidget {
  final List<QuizQuestion> questions;
  final Function(int, int) onChanged;
  final bool? isValidated;

  const Quiz(
      {super.key,
      required this.questions,
      required this.onChanged,
      this.isValidated});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: List.generate(
        questions.length,
        (index) {
          return quizQuestion(
              context: context,
              questionNumber: questions.length > 1 ? index + 1 : null,
              question: questions[index],
              selectedAnswer: questions[index].selectedAnswer,
              isCorrect: questions[index].isCorrect,
              onChanged: (answerIndex) {
                onChanged(index, answerIndex);
              });
        },
      ),
    );
  }

  ChallengeCard quizQuestion(
      {required BuildContext context,
      required QuizQuestion question,
      required int selectedAnswer,
      required ValueChanged<int> onChanged,
      bool? isCorrect,
      int? questionNumber}) {
    HTMLParser parser = HTMLParser(context: context);

    return ChallengeCard(
      title: questionNumber != null ? 'Question $questionNumber' : 'Question',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ...parser.parse(
            question.text,
          ),
          const SizedBox(height: 8),
          for (var answerObj in question.answers.asMap().entries)
            option(
                context: context,
                answerObj: answerObj,
                selectedAnswer: selectedAnswer,
                isCorrect: isCorrect,
                onChanged: (value) {
                  onChanged(value);
                }),
        ],
      ),
    );
  }

  Container option({
    required BuildContext context,
    required MapEntry<int, Answer> answerObj,
    required int selectedAnswer,
    required bool? isCorrect,
    required ValueChanged<int> onChanged,
  }) {
    HTMLParser parser = HTMLParser(context: context);

    final isSelected = answerObj.key == selectedAnswer;

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: Material(
        child: RadioListTile<int>(
          key: ValueKey(selectedAnswer),
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
          groupValue: selectedAnswer,
          onChanged: (value) {
            onChanged(value ?? -1);
          },
          title: Align(
            alignment: Alignment.centerLeft,
            child: ConstrainedBox(
              constraints: const BoxConstraints(
                minHeight: 100,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: parser.parse(
                  answerObj.value.answer,
                  isSelectable: false,
                  removeParagraphMargin: true,
                ),
              ),
            ),
          ),
          subtitle: isSelected && isValidated == true
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

  Widget validationStatusAndFeedback(
      {required BuildContext context, bool? isCorrect, String? feedback}) {
    HTMLParser parser = HTMLParser(context: context);
    final List<Widget> feedbackWidgets = [];

    if (isCorrect == null) {
      return const SizedBox.shrink();
    }

    feedbackWidgets.add(
      Padding(
        padding: EdgeInsets.only(left: 12, bottom: isCorrect ? 32 : 0),
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
          fontColor: isCorrect == true ? FccColors.green40 : FccColors.red15,
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: feedbackWidgets,
    );
  }
}
