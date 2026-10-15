import 'package:mobile_app_new/learn/models/curriculum_model.dart';
import 'package:mobile_app_new/learn/services/curriculum_service.dart';
import 'package:mobile_app_new/services/remote_config_service.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'curriculum_controller.g.dart';

// NOTE: Shared by the landing list and the superblock screen, which takes its title from here.
@riverpod
Future<List<CurriculumStage>> curriculumStages(Ref ref) async {
  final remoteConfig = await ref.watch(remoteConfigProvider.future);
  return ref.watch(learnCurriculumServiceProvider).getStages(remoteConfig);
}

// NOTE: Shared by the superblock screen and the module screen beneath it.
@riverpod
Future<SuperBlock> superBlock(Ref ref, String dashedName) async {
  final remoteConfig = await ref.watch(remoteConfigProvider.future);
  return ref
      .watch(learnCurriculumServiceProvider)
      .getSuperBlock(dashedName, remoteConfig);
}
