import 'package:flutter/material.dart';
import 'package:freecodecamp/models/learn/challenge_model.dart';
import 'package:freecodecamp/ui/views/learn/challenge/quiz/quiz_question_widget.dart';
import 'package:freecodecamp/ui/views/learn/challenge/quiz/quiz_viewmodel.dart';
import 'package:stacked/stacked.dart';

class Quiz extends StatelessWidget {
  final List<Question> questions;

  const Quiz({super.key, required this.questions});

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<QuizViewModel>.reactive(
      viewModelBuilder: () => QuizViewModel(questions: questions),
      builder: (context, model, child) => Column(
        children: List.generate(
          model.quizQuestions.length,
          (index) {
            final quizQuestion = model.quizQuestions[index];
            return QuizQuestionWidget(
              question: quizQuestion.question,
              selectedAnswer: quizQuestion.selectedAnswer,
              isCorrect: quizQuestion.isCorrect,
              onChanged: (answerIndex) =>
                  model.selectAnswer(index, answerIndex),
            );
          },
        ),
      ),
    );
  }
}
