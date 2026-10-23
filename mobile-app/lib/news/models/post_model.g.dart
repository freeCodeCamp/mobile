// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'post_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Tag _$TagFromJson(Map<String, dynamic> json) => _Tag(
  id: json['id'] as String,
  name: json['name'] as String,
  slug: json['slug'] as String,
);

Map<String, dynamic> _$TagToJson(_Tag instance) => <String, dynamic>{
  'id': instance.id,
  'name': instance.name,
  'slug': instance.slug,
};

_CoverImage _$CoverImageFromJson(Map<String, dynamic> json) =>
    _CoverImage(url: json['url'] as String?);

Map<String, dynamic> _$CoverImageToJson(_CoverImage instance) =>
    <String, dynamic>{'url': instance.url};

_Content _$ContentFromJson(Map<String, dynamic> json) =>
    _Content(html: json['html'] as String);

Map<String, dynamic> _$ContentToJson(_Content instance) => <String, dynamic>{
  'html': instance.html,
};

_Post _$PostFromJson(Map<String, dynamic> json) => _Post(
  id: json['id'] as String,
  slug: json['slug'] as String,
  title: json['title'] as String,
  url: json['url'] as String,
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
  content: Content.fromJson(json['content'] as Map<String, dynamic>),
  publishedAt: json['publishedAt'] as String,
);

Map<String, dynamic> _$PostToJson(_Post instance) => <String, dynamic>{
  'id': instance.id,
  'slug': instance.slug,
  'title': instance.title,
  'url': instance.url,
  'author': instance.author,
  'tags': instance.tags,
  'coverImage': instance.coverImage,
  'readTimeInMinutes': instance.readTimeInMinutes,
  'content': instance.content,
  'publishedAt': instance.publishedAt,
};
