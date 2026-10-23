import 'package:freezed_annotation/freezed_annotation.dart';

part 'challenge_file_model.freezed.dart';
part 'challenge_file_model.g.dart';

enum Ext { js, html, css, jsx, py }

Object? _readFileKey(Map<dynamic, dynamic> json, String key) =>
    json[key] ?? '${json['name']}${json['ext']}';

@freezed
abstract class ChallengeFile with _$ChallengeFile {
  const factory ChallengeFile({
    @JsonKey(unknownEnumValue: Ext.html) required Ext ext,
    required String name,
    String? head,
    String? tail,
    required String contents,
    @Default([]) List<String> history,
    @Default([]) List<int> editableRegionBoundaries,
    @JsonKey(readValue: _readFileKey) required String fileKey,
  }) = _ChallengeFile;

  const ChallengeFile._();

  String get fileName => '$name.${ext.name}';

  factory ChallengeFile.fromJson(Map<String, Object?> json) =>
      _$ChallengeFileFromJson(json);
}
