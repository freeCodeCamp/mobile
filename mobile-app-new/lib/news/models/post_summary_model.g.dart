// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'post_summary_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_PostSummary _$PostSummaryFromJson(Map<String, dynamic> json) => _PostSummary(
  id: json['id'] as String,
  slug: json['slug'] as String,
  title: json['title'] as String,
  author: Author.fromJson(json['author'] as Map<String, dynamic>),
  tags:
      (json['tags'] as List<dynamic>?)
          ?.map((e) => Tag.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const [],
  coverImage: json['coverImage'] == null
      ? null
      : CoverImage.fromJson(json['coverImage'] as Map<String, dynamic>),
  readTimeInMinutes: (json['readTimeInMinutes'] as num).toInt(),
  publishedAt: json['publishedAt'] as String,
);

Map<String, dynamic> _$PostSummaryToJson(_PostSummary instance) =>
    <String, dynamic>{
      'id': instance.id,
      'slug': instance.slug,
      'title': instance.title,
      'author': instance.author,
      'tags': instance.tags,
      'coverImage': instance.coverImage,
      'readTimeInMinutes': instance.readTimeInMinutes,
      'publishedAt': instance.publishedAt,
    };
