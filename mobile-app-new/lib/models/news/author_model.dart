import 'package:freezed_annotation/freezed_annotation.dart';

part 'author_model.freezed.dart';
part 'author_model.g.dart';

@freezed
abstract class Bio with _$Bio {
  const factory Bio({required String text}) = _Bio;

  factory Bio.fromJson(Map<String, Object?> json) => _$BioFromJson(json);
}

@freezed
abstract class SocialMediaLinks with _$SocialMediaLinks {
  const factory SocialMediaLinks({
    String? website,
    String? twitter,
    String? facebook,
  }) = _SocialMediaLinks;

  factory SocialMediaLinks.fromJson(Map<String, Object?> json) =>
      _$SocialMediaLinksFromJson(json);
}

@freezed
abstract class Author with _$Author {
  const factory Author({
    required String username,
    required String id,
    required String name,
    String? profilePicture,
    Bio? bio,
    // TODO: Below items are not displayed in the UI. To be added
    String? location,
    SocialMediaLinks? socialMediaLinks,
  }) = _Author;

  factory Author.fromJson(Map<String, Object?> json) => _$AuthorFromJson(json);
}
