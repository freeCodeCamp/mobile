import 'dart:async';

import 'package:freecodecamp/learn/controllers/curriculum_controller.dart';
import 'package:freecodecamp/learn/controllers/location_controller.dart';
import 'package:freecodecamp/learn/models/location_model.dart';
import 'package:freecodecamp/learn/models/resume_model.dart';
import 'package:freecodecamp/learn/services/curriculum_service.dart';
import 'package:freecodecamp/learn/services/resume_service.dart';
import 'package:freecodecamp/services/auth_service.dart';
import 'package:freecodecamp/utils/riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'resume_viewmodel.g.dart';

@Riverpod(retry: noRetry)
class LearningResumeNotifier extends _$LearningResumeNotifier {
  @override
  Future<LearningResume?> build() async {
    final userFuture = ref.watch(authProvider.future);
    final stagesFuture = ref.watch(curriculumStagesProvider.future);
    final service = ref.watch(learnResumeServiceProvider);
    final user = await userFuture;
    final stages = await stagesFuture;
    if (!ref.mounted) return null;
    final userId = user?.id;
    final locationProvider = userId == null || userId.isEmpty
        ? null
        : learningLocationProvider(userId);
    final savedLocation = locationProvider == null
        ? null
        : await ref.watch(locationProvider.future);
    if (!ref.mounted) return null;
    final result = await service.load(
      stages.expand((stage) => stage.superBlocks),
      user,
      savedLocation: savedLocation,
      loadCurriculum: (name) => ref.watch(superBlockProvider(name).future),
      isActive: () => ref.mounted,
    );
    if (ref.mounted &&
        locationProvider != null &&
        result != null &&
        (result.isReturning || savedLocation != null)) {
      unawaited(
        ref
            .read(locationProvider.notifier)
            .rememberIfUnchanged(
              LearnLocation(
                superBlock: result.course.dashedName,
                block: result.block.dashedName,
                challengeId: result.challenge.id,
              ),
              savedLocation,
            ),
      );
    }
    return result;
  }

  // Retrying must refresh the source futures as well as the derived selection.
  void retry() {
    final stages = ref.read(curriculumStagesProvider).value;
    for (final stage in stages ?? const <CurriculumStage>[]) {
      for (final course in stage.superBlocks) {
        if (course.isPublic && !course.isDisabledByOverride) {
          ref.invalidate(superBlockProvider(course.dashedName));
        }
      }
    }
    ref.invalidateSelf();
  }
}
