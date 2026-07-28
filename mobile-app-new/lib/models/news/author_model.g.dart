// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'author_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Bio _$BioFromJson(Map<String, dynamic> json) =>
    _Bio(text: json['text'] as String?);

Map<String, dynamic> _$BioToJson(_Bio instance) => <String, dynamic>{
  'text': instance.text,
};

_SocialMediaLinks _$SocialMediaLinksFromJson(Map<String, dynamic> json) =>
    _SocialMediaLinks(
      website: json['website'] as String?,
      twitter: json['twitter'] as String?,
      facebook: json['facebook'] as String?,
    );

Map<String, dynamic> _$SocialMediaLinksToJson(_SocialMediaLinks instance) =>
    <String, dynamic>{
      'website': instance.website,
      'twitter': instance.twitter,
      'facebook': instance.facebook,
    };

_Author _$AuthorFromJson(Map<String, dynamic> json) => _Author(
  username: json['username'] as String,
  id: json['id'] as String,
  name: json['name'] as String,
  profilePicture: json['profilePicture'] as String?,
  bio: json['bio'] == null
      ? null
      : Bio.fromJson(json['bio'] as Map<String, dynamic>),
  location: json['location'] as String?,
  socialMediaLinks: json['socialMediaLinks'] == null
      ? null
      : SocialMediaLinks.fromJson(
          json['socialMediaLinks'] as Map<String, dynamic>,
        ),
);

Map<String, dynamic> _$AuthorToJson(_Author instance) => <String, dynamic>{
  'username': instance.username,
  'id': instance.id,
  'name': instance.name,
  'profilePicture': instance.profilePicture,
  'bio': instance.bio,
  'location': instance.location,
  'socialMediaLinks': instance.socialMediaLinks,
};
