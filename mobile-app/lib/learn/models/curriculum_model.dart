import 'package:collection/collection.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'curriculum_model.freezed.dart';
part 'curriculum_model.g.dart';

enum BlockLayout {
  challengeList,
  challengeGrid,
  challengeDialogue,
  challengeLink;

  static BlockLayout fromValue(Object? value) {
    switch (value) {
      case 'project-list':
      case 'challenge-list':
      case 'legacy-challenge-list':
        return challengeList;
      case 'dialogue-grid':
        return challengeDialogue;
      case 'link':
      case 'legacy-link':
        return challengeLink;
      default:
        return challengeGrid;
    }
  }
}

enum BlockLabel {
  lecture('lecture'),
  workshop('workshop'),
  lab('lab'),
  review('review'),
  quiz('quiz'),
  exam('exam'),
  warmup('warm-up'),
  learn('learn'),
  practice('practice'),
  legacy('legacy');

  const BlockLabel(this.value);

  final String value;

  static BlockLabel fromValue(Object? value) =>
      values.firstWhereOrNull((label) => label.value == value) ?? legacy;
}

enum ModuleType {
  review('review'),
  exam('exam'),
  certProject('cert-project');

  const ModuleType(this.value);

  final String value;

  static ModuleType? fromValue(Object? value) =>
      values.firstWhereOrNull((type) => type.value == value);
}

@freezed
abstract class SuperBlockSummary with _$SuperBlockSummary {
  const factory SuperBlockSummary({
    required String dashedName,
    required String title,
    required bool isPublic,
    @Default(false) bool isDisabledByOverride,
  }) = _SuperBlockSummary;
}

@freezed
abstract class ChallengeOrder with _$ChallengeOrder {
  const factory ChallengeOrder({required String id, required String title}) =
      _ChallengeOrder;

  factory ChallengeOrder.fromJson(Map<String, dynamic> json) =>
      _$ChallengeOrderFromJson(json);
}

@freezed
abstract class Block with _$Block {
  const factory Block({
    required String superBlock,
    required String dashedName,
    required String name,
    required BlockLayout layout,
    required BlockLabel label,
    required List<String> description,
    required List<ChallengeOrder> challenges,
    @Default(false) bool isDisabledByOverride,
  }) = _Block;
}

@freezed
abstract class Module with _$Module {
  const factory Module({
    required String dashedName,
    required String name,
    @Default(false) bool comingSoon,
    ModuleType? moduleType,
    required List<Block> blocks,
  }) = _Module;
}

@freezed
abstract class Chapter with _$Chapter {
  const factory Chapter({
    required String dashedName,
    required String name,
    @Default(false) bool comingSoon,
    required List<Module> modules,
  }) = _Chapter;
}

@freezed
sealed class SuperBlock with _$SuperBlock {
  const factory SuperBlock.blocks(List<Block> blocks) = BlockSuperBlock;
  const factory SuperBlock.chapters(List<Chapter> chapters) = ChapterSuperBlock;
}
