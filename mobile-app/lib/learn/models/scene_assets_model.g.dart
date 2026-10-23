// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'scene_assets_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_SceneAssets _$SceneAssetsFromJson(Map<String, dynamic> json) => _SceneAssets(
  backgrounds: json['backgrounds'] as String,
  characterAssets: (json['characterAssets'] as Map<String, dynamic>).map(
    (k, e) => MapEntry(k, CharacterAssets.fromJson(e as Map<String, dynamic>)),
  ),
);

Map<String, dynamic> _$SceneAssetsToJson(_SceneAssets instance) =>
    <String, dynamic>{
      'backgrounds': instance.backgrounds,
      'characterAssets': instance.characterAssets,
    };

_CharacterAssets _$CharacterAssetsFromJson(Map<String, dynamic> json) =>
    _CharacterAssets(
      base: json['base'] as String,
      brows: json['brows'] as String,
      eyesClosed: json['eyesClosed'] as String,
      eyesOpen: json['eyesOpen'] as String,
      glasses: json['glasses'] as String?,
      mouthClosed: json['mouthClosed'] as String,
      mouthOpen: json['mouthOpen'] as String,
    );

Map<String, dynamic> _$CharacterAssetsToJson(_CharacterAssets instance) =>
    <String, dynamic>{
      'base': instance.base,
      'brows': instance.brows,
      'eyesClosed': instance.eyesClosed,
      'eyesOpen': instance.eyesOpen,
      'glasses': instance.glasses,
      'mouthClosed': instance.mouthClosed,
      'mouthOpen': instance.mouthOpen,
    };
