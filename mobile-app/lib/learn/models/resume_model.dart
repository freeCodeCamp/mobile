import 'package:freecodecamp/learn/models/curriculum_model.dart';
import 'package:freecodecamp/learn/utils/learning_action.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'resume_model.freezed.dart';

@freezed
abstract class LearningResume with _$LearningResume {
  const LearningResume._();

  const factory LearningResume({
    required SuperBlockSummary course,
    required Block block,
    required ChallengeOrder challenge,
    required int completed,
    required bool isReturning,
  }) = _LearningResume;

  LearningAction get action => LearningAction(
    block: block,
    next: challenge,
    hasProgress: completed > 0 || isReturning,
  );
}
