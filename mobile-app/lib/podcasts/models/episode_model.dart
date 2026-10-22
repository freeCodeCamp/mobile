import 'package:freezed_annotation/freezed_annotation.dart';

part 'episode_model.freezed.dart';
part 'episode_model.g.dart';

@freezed
abstract class Episode with _$Episode {
  const factory Episode({
    @JsonKey(name: '_id') required String id,
    required String podcastId,
    required String title,
    @Default('') String description,
    DateTime? publicationDate,
    required String audioUrl,
    @DurationConverter() Duration? duration,
  }) = _Episode;

  factory Episode.fromJson(Map<String, dynamic> json) =>
      _$EpisodeFromJson(json);
}

// The API sends duration in whichever shape the source feed used: bare seconds
// ('3390'), 'MM:SS' or 'HH:MM:SS'. On disk it is Duration.toString()
// ('0:56:30.000000').
class DurationConverter implements JsonConverter<Duration?, String?> {
  const DurationConverter();

  @override
  Duration? fromJson(String? json) =>
      json == null || json.isEmpty || json == 'null'
      ? null
      : _parseDuration(json);

  @override
  String? toJson(Duration? object) => object?.toString();
}

Duration _parseDuration(String value) {
  final parts = value.split(':');
  final secondsParts = parts.last.split('.');

  return Duration(
    hours: parts.length > 2 ? int.tryParse(parts[parts.length - 3]) ?? 0 : 0,
    minutes: parts.length > 1 ? int.tryParse(parts[parts.length - 2]) ?? 0 : 0,
    seconds: int.tryParse(secondsParts.first) ?? 0,
    microseconds: secondsParts.length > 1
        ? int.tryParse(secondsParts[1]) ?? 0
        : 0,
  );
}
