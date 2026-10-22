// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'episode_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Episode _$EpisodeFromJson(Map<String, dynamic> json) => _Episode(
  id: json['_id'] as String,
  podcastId: json['podcastId'] as String,
  title: json['title'] as String,
  description: json['description'] as String? ?? '',
  publicationDate: json['publicationDate'] == null
      ? null
      : DateTime.parse(json['publicationDate'] as String),
  audioUrl: json['audioUrl'] as String,
  duration: const DurationConverter().fromJson(json['duration'] as String?),
);

Map<String, dynamic> _$EpisodeToJson(_Episode instance) => <String, dynamic>{
  '_id': instance.id,
  'podcastId': instance.podcastId,
  'title': instance.title,
  'description': instance.description,
  'publicationDate': instance.publicationDate?.toIso8601String(),
  'audioUrl': instance.audioUrl,
  'duration': const DurationConverter().toJson(instance.duration),
};
