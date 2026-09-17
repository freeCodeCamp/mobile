// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'podcast_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Podcast _$PodcastFromJson(Map<String, dynamic> json) => _Podcast(
  id: json['_id'] as String,
  feedUrl: json['feedUrl'] as String,
  podcastLink: json['podcastLink'] as String,
  title: json['title'] as String,
  description: json['description'] as String? ?? '',
  imageLink: json['imageLink'] as String,
  copyright: json['copyright'] as String? ?? '',
  numOfEps: (json['numOfEps'] as num?)?.toInt() ?? 0,
);

Map<String, dynamic> _$PodcastToJson(_Podcast instance) => <String, dynamic>{
  '_id': instance.id,
  'feedUrl': instance.feedUrl,
  'podcastLink': instance.podcastLink,
  'title': instance.title,
  'description': instance.description,
  'imageLink': instance.imageLink,
  'copyright': instance.copyright,
  'numOfEps': instance.numOfEps,
};
