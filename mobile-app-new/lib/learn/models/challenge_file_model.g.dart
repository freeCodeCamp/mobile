// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'challenge_file_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_ChallengeFile _$ChallengeFileFromJson(Map<String, dynamic> json) =>
    _ChallengeFile(
      ext: $enumDecode(_$ExtEnumMap, json['ext'], unknownValue: Ext.html),
      name: json['name'] as String,
      head: json['head'] as String?,
      tail: json['tail'] as String?,
      contents: json['contents'] as String,
      history:
          (json['history'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      editableRegionBoundaries:
          (json['editableRegionBoundaries'] as List<dynamic>?)
              ?.map((e) => (e as num).toInt())
              .toList() ??
          const [],
      fileKey: _readFileKey(json, 'fileKey') as String,
    );

Map<String, dynamic> _$ChallengeFileToJson(_ChallengeFile instance) =>
    <String, dynamic>{
      'ext': _$ExtEnumMap[instance.ext]!,
      'name': instance.name,
      'head': instance.head,
      'tail': instance.tail,
      'contents': instance.contents,
      'history': instance.history,
      'editableRegionBoundaries': instance.editableRegionBoundaries,
      'fileKey': instance.fileKey,
    };

const _$ExtEnumMap = {
  Ext.js: 'js',
  Ext.html: 'html',
  Ext.css: 'css',
  Ext.jsx: 'jsx',
  Ext.py: 'py',
};
