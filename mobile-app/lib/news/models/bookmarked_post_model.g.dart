// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'bookmarked_post_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_BookmarkedPost _$BookmarkedPostFromJson(Map<String, dynamic> json) =>
    _BookmarkedPost(
      id: json['id'] as String,
      title: json['title'] as String,
      authorName: json['authorName'] as String,
      text: json['text'] as String,
    );

Map<String, dynamic> _$BookmarkedPostToJson(_BookmarkedPost instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'authorName': instance.authorName,
      'text': instance.text,
    };
