import 'package:freezed_annotation/freezed_annotation.dart';
import 'author_model.dart';

part 'post_model.freezed.dart';
part 'post_model.g.dart';

@freezed
abstract class Tag with _$Tag {
  const factory Tag({
    required String id,
    required String name,
    required String slug,
  }) = _Tag;

  factory Tag.fromJson(Map<String, Object?> json) => _$TagFromJson(json);
}

@freezed
abstract class CoverImage with _$CoverImage {
  const factory CoverImage({String? url}) = _CoverImage;

  factory CoverImage.fromJson(Map<String, Object?> json) =>
      _$CoverImageFromJson(json);
}

@freezed
abstract class Content with _$Content {
  const factory Content({required String html}) = _Content;

  factory Content.fromJson(Map<String, Object?> json) =>
      _$ContentFromJson(json);
}

@freezed
abstract class Post with _$Post {
  const factory Post({
    required String id,
    required String slug,
    required String title,
    required String url,
    required Author author,
    @Default([]) List<Tag> tags,
    CoverImage? coverImage,
    required int readTimeInMinutes,
    required Content content,
    required String publishedAt,
  }) = _Post;

  factory Post.fromJson(Map<String, Object?> json) => _$PostFromJson(json);
}
