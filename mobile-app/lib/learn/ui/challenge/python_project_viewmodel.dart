import 'package:freecodecamp/learn/models/challenge_model.dart';
import 'package:freecodecamp/learn/services/assessment_service.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'python_project_viewmodel.freezed.dart';
part 'python_project_viewmodel.g.dart';

@freezed
abstract class PythonProjectState with _$PythonProjectState {
  const factory PythonProjectState({
    @Default('') String link,
    @Default(false) bool valid,
    @Default(false) bool canCheck,
    String? error,
  }) = _PythonProjectState;
}

@riverpod
class PythonProjectNotifier extends _$PythonProjectNotifier {
  @override
  PythonProjectState build(Challenge challenge) => const PythonProjectState();

  void updateLink(String value) {
    final link = value.trim();
    state = PythonProjectState(link: link, canCheck: link.isNotEmpty);
  }

  void checkLink() {
    if (!state.canCheck) return;
    final error = ref
        .read(learnAssessmentServiceProvider)
        .projectLinkError(state.link);
    state = state.copyWith(error: error, valid: error == null);
  }
}
