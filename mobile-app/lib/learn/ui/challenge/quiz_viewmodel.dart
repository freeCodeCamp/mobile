import 'package:freecodecamp/learn/models/challenge_model.dart';
import 'package:freecodecamp/learn/models/question_model.dart';
import 'package:freecodecamp/learn/services/quiz_service.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'quiz_viewmodel.freezed.dart';
part 'quiz_viewmodel.g.dart';

@freezed
abstract class QuizState with _$QuizState {
  const QuizState._();

  const factory QuizState({
    required List<QuestionItem> questions,
    required List<int?> selected,
    required int requiredCorrect,
    @Default(0) int current,
    @Default(false) bool validated,
    @Default([]) List<bool> results,
    @Default(0) int correct,
    @Default(false) bool passed,
  }) = _QuizState;

  int get answered => selected.whereType<int>().length;
}

@riverpod
class QuizNotifier extends _$QuizNotifier {
  @override
  QuizState build(Challenge challenge) {
    final service = ref.watch(learnQuizServiceProvider);
    final questions = service.pickQuestions(challenge.quizzes);
    return QuizState(
      questions: questions,
      selected: List.filled(questions.length, null),
      requiredCorrect: service.requiredCorrect(questions.length),
    );
  }

  void select(int question, int answer) {
    if (state.validated) return;
    final selected = [...state.selected];
    selected[question] = answer;
    state = state.copyWith(selected: selected);
  }

  void show(int index) => state = state.copyWith(current: index);

  bool submit() {
    final service = ref.read(learnQuizServiceProvider);
    final unanswered = service.firstUnanswered(state.selected);
    if (unanswered != null) {
      state = state.copyWith(current: unanswered);
      return false;
    }

    final results = service.grade(state.questions, state.selected);
    state = state.copyWith(
      validated: true,
      results: results,
      correct: service.correctCount(results),
      passed: service.passes(results),
    );
    return true;
  }

  void reset() {
    state = QuizState(
      questions: state.questions,
      selected: List.filled(state.questions.length, null),
      requiredCorrect: state.requiredCorrect,
    );
  }
}
