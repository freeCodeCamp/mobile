import 'package:freecodecamp/learn/models/challenge_model.dart';
import 'package:freecodecamp/learn/models/question_model.dart';
import 'package:freecodecamp/learn/services/assessment_service.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'lesson_viewmodel.freezed.dart';
part 'lesson_viewmodel.g.dart';

@freezed
abstract class LessonChallengeState with _$LessonChallengeState {
  const factory LessonChallengeState({
    required List<QuestionItem> questions,
    required List<int?> selected,
    required List<bool> checked,
    required List<bool> results,
    required List<bool> assignments,
    required bool assignmentsDone,
    required bool passed,
    required bool canCompleteReading,
    @Default(0) int firstPendingQuestion,
    @Default(false) bool reviewed,
    int? current,
  }) = _LessonChallengeState;
}

@riverpod
class LessonChallengeNotifier extends _$LessonChallengeNotifier {
  @override
  LessonChallengeState build(Challenge challenge) {
    final service = ref.watch(learnAssessmentServiceProvider);
    final questions = service.lessonQuestions(challenge);
    final results = List.filled(questions.length, false);
    final assignments = List.filled(challenge.assignments.length, false);
    return LessonChallengeState(
      questions: questions,
      selected: List.filled(questions.length, null),
      checked: List.filled(questions.length, false),
      results: results,
      assignments: assignments,
      assignmentsDone: service.assignmentsComplete(assignments),
      passed: service.lessonPassed(results),
      canCompleteReading: service.canCompleteReading(
        challenge,
        assignments,
        false,
      ),
    );
  }

  LearnAssessmentService get _service =>
      ref.read(learnAssessmentServiceProvider);

  void selectAnswer(int question, int answer) {
    final selected = [...state.selected]..[question] = answer;
    final checked = [...state.checked]..[question] = false;
    _updateAnswers(selected, checked);
  }

  void checkAnswer(int question) {
    if (state.selected[question] == null || state.checked[question]) return;
    _updateAnswers(state.selected, [...state.checked]..[question] = true);
  }

  void _updateAnswers(List<int?> selected, List<bool> checked) {
    final results = _service.checkLessonAnswers(
      state.questions,
      selected,
      checked,
    );
    state = state.copyWith(
      selected: selected,
      checked: checked,
      results: results,
      passed: _service.lessonPassed(results),
      firstPendingQuestion: _service.firstPendingQuestion(results),
    );
  }

  void toggleAssignment(int index) {
    final assignments = [...state.assignments]
      ..[index] = !state.assignments[index];
    state = state.copyWith(
      assignments: assignments,
      assignmentsDone: _service.assignmentsComplete(assignments),
      canCompleteReading: _service.canCompleteReading(
        challenge,
        assignments,
        state.reviewed,
      ),
    );
  }

  void setReviewed(bool value) {
    state = state.copyWith(
      reviewed: value,
      canCompleteReading: _service.canCompleteReading(
        challenge,
        state.assignments,
        value,
      ),
    );
  }

  void showQuestion(int? index) => state = state.copyWith(current: index);
}
