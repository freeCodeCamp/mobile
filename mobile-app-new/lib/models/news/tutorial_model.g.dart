// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'tutorial_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Author _$AuthorFromJson(Map<String, dynamic> json) => _Author(
  slug: json['slug'] as String,
  id: json['id'] as String,
  name: json['name'] as String?,
  profileImage: json['profileImage'] as String?,
  bio: json['bio'] as String?,
  website: json['website'] as String?,
  location: json['location'] as String?,
  facebook: json['facebook'] as String?,
  twitter: json['twitter'] as String?,
);

Map<String, dynamic> _$AuthorToJson(_Author instance) => <String, dynamic>{
  'slug': instance.slug,
  'id': instance.id,
  'name': instance.name,
  'profileImage': instance.profileImage,
  'bio': instance.bio,
  'website': instance.website,
  'location': instance.location,
  'facebook': instance.facebook,
  'twitter': instance.twitter,
};
