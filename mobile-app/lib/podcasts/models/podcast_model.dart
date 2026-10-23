import 'package:freezed_annotation/freezed_annotation.dart';

part 'podcast_model.freezed.dart';
part 'podcast_model.g.dart';

@freezed
abstract class Podcast with _$Podcast {
  const factory Podcast({
    @JsonKey(name: '_id') required String id,
    required String feedUrl,
    required String podcastLink,
    required String title,
    @Default('') String description,
    required String imageLink,
    @Default('') String copyright,
    @Default(0) int numOfEps,
  }) = _Podcast;

  factory Podcast.fromJson(Map<String, dynamic> json) =>
      _$PodcastFromJson(json);
}
