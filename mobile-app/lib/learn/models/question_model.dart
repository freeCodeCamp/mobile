import 'package:freecodecamp/learn/models/challenge_model.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'question_model.freezed.dart';

@freezed
abstract class QuestionItem with _$QuestionItem {
  const factory QuestionItem({
    required String text,
    required List<Answer> answers,
    required int solution,
    QuizAudioData? audioData,
  }) = _QuestionItem;
}

QuestionItem questionItem(Question question) => QuestionItem(
  text: question.text,
  answers: question.answers,
  solution: question.solution - 1,
);
