import 'package:freezed_annotation/freezed_annotation.dart';

part 'scene_assets_model.freezed.dart';
part 'scene_assets_model.g.dart';

@freezed
abstract class SceneAssets with _$SceneAssets {
  const factory SceneAssets({
    required String backgrounds,
    required Map<String, CharacterAssets> characterAssets,
  }) = _SceneAssets;

  factory SceneAssets.fromJson(Map<String, dynamic> json) =>
      _$SceneAssetsFromJson(json);
}

@freezed
abstract class CharacterAssets with _$CharacterAssets {
  const factory CharacterAssets({
    required String base,
    required String brows,
    required String eyesClosed,
    required String eyesOpen,
    String? glasses,
    required String mouthClosed,
    required String mouthOpen,
  }) = _CharacterAssets;

  factory CharacterAssets.fromJson(Map<String, dynamic> json) =>
      _$CharacterAssetsFromJson(json);
}
