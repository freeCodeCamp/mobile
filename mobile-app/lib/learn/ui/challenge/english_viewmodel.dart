import 'package:freecodecamp/learn/models/challenge_model.dart';
import 'package:freecodecamp/learn/services/assessment_service.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'english_viewmodel.freezed.dart';
part 'english_viewmodel.g.dart';

@freezed
abstract class EnglishChallengeState with _$EnglishChallengeState {
  const factory EnglishChallengeState({
    required List<String> answers,
    required List<bool> assignments,
    List<bool>? results,
    @Default(false) bool allCorrect,
    @Default(false) bool canCheck,
    required bool assignmentsDone,
    @Default('') String feedback,
    @Default(false) bool exercise,
  }) = _EnglishChallengeState;
}

@riverpod
class EnglishChallengeNotifier extends _$EnglishChallengeNotifier {
  @override
  EnglishChallengeState build(Challenge challenge) {
    final service = ref.watch(learnAssessmentServiceProvider);
    final assignments = List.filled(challenge.assignments.length, false);
    return EnglishChallengeState(
      answers: List.filled(challenge.fillInTheBlank?.blanks.length ?? 0, ''),
      assignments: assignments,
      assignmentsDone: service.assignmentsComplete(assignments),
    );
  }

  LearnAssessmentService get _service =>
      ref.read(learnAssessmentServiceProvider);

  void updateAnswer(int index, String answer) {
    final answers = [...state.answers]..[index] = answer;
    state = state.copyWith(
      answers: answers,
      results: null,
      allCorrect: false,
      canCheck: _service.hasAnswers(answers),
      feedback: '',
    );
  }

  void toggleAssignment(int index) {
    final assignments = [...state.assignments]
      ..[index] = !state.assignments[index];
    state = state.copyWith(
      assignments: assignments,
      assignmentsDone: _service.assignmentsComplete(assignments),
    );
  }

  void checkAnswers() {
    if (!state.canCheck) return;
    final result = _service.checkBlanks(
      challenge.fillInTheBlank?.blanks ?? const [],
      state.answers,
    );
    state = state.copyWith(
      results: result.results,
      allCorrect: result.passed,
      feedback: result.feedback,
    );
  }

  void showExercise(bool value) => state = state.copyWith(exercise: value);
}
