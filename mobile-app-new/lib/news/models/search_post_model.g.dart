// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'search_post_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_SearchAuthor _$SearchAuthorFromJson(Map<String, dynamic> json) =>
    _SearchAuthor(
      name: json['name'] as String,
      profileImage: json['profileImage'] as String?,
    );

Map<String, dynamic> _$SearchAuthorToJson(_SearchAuthor instance) =>
    <String, dynamic>{
      'name': instance.name,
      'profileImage': instance.profileImage,
    };

_SearchPost _$SearchPostFromJson(Map<String, dynamic> json) => _SearchPost(
  objectID: json['objectID'] as String,
  title: json['title'] as String,
  url: json['url'] as String,
  author: SearchAuthor.fromJson(json['author'] as Map<String, dynamic>),
  featureImage: json['featureImage'] as String?,
  publishedAt: json['publishedAt'] as String?,
);

Map<String, dynamic> _$SearchPostToJson(_SearchPost instance) =>
    <String, dynamic>{
      'objectID': instance.objectID,
      'title': instance.title,
      'url': instance.url,
      'author': instance.author,
      'featureImage': instance.featureImage,
      'publishedAt': instance.publishedAt,
    };
