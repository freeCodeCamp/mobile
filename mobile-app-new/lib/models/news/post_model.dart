import 'package:freezed_annotation/freezed_annotation.dart';
import 'author_model.dart';

part 'post_model.freezed.dart';
part 'post_model.g.dart';

// class Tutorial {
//   final String id;
//   final String slug;
//   final String title;
//   final String? featureImage;
//   final String? profileImage;
//   final String authorId;
//   final String authorName;
//   final String authorSlug;
//   final String? createdAt;
//   final String? url;
//   final String? text;

//   Tutorial({
//     required this.id,
//     required this.slug,
//     required this.featureImage,
//     required this.title,
//     required this.profileImage,
//     required this.authorId,
//     required this.authorName,
//     required this.authorSlug,
//     this.createdAt,
//     this.url,
//     this.text,
//   });

//   // static List<Widget> returnTags(
//   //   list, {
//   //   bool compact = false,
//   // }) {
//   //   List<Widget> tags = [];

//   //   for (int i = 0; i < list.length; i++) {
//   //     tags.add(TagButton(
//   //       tagName: list[i]['name'],
//   //       tagSlug: list[i]['slug'] ?? list[i]['id'],
//   //       key: UniqueKey(),
//   //       compact: compact,
//   //     ));
//   //   }
//   //   return tags;
//   // }

//   // this factory is for the endpoint where all tutorial thumbnails are received

//   // factory Tutorial.fromJson(dynamic data) {
//   //   return Tutorial(
//   //     createdAt: data['publishedAt'],
//   //     featureImage: data['coverImage']['url'],
//   //     title: data['title'],
//   //     profileImage: data['author']['profilePicture'],
//   //     authorId: data['author']['id'],
//   //     authorName: data['author']['name'],
//   //     authorSlug: data['author']['username'],
//   //     tagNames: returnTags(data['tags']),
//   //     rawTags: data['tags'] ?? [],
//   //     id: data['id'],
//   //     slug: data['slug'],
//   //   );
//   // }

//   // factory Tutorial.fromSearch(Map<String, dynamic> data) {
//   //   return Tutorial(
//   //     createdAt: data['publishedAt'],
//   //     featureImage: data['featureImage'],
//   //     title: data['title'],
//   //     profileImage: data['author']['profileImage'],
//   //     authorId: data['author']['id'],
//   //     authorName: data['author']['name'],
//   //     authorSlug: returnSlug(data['author']['url']),
//   //     tagNames: returnTags(data['tags']),
//   //     rawTags: data['tags'] ?? [],
//   //     id: data['objectID'],
//   //     slug: data['slug'],
//   //   );
//   // }

//   // static String returnSlug(String url) {
//   //   List splitUrl = url.split('/');

//   //   return splitUrl[splitUrl.length - 2];
//   // }

//   // this is factory is for the post view

//   // factory Tutorial.toPostFromJson(Map<String, dynamic> json) {
//   //   return Tutorial(
//   //     authorId: json['author']['id'],
//   //     authorName: json['author']['name'],
//   //     authorSlug: json['author']['username'],
//   //     profileImage: json['author']['profilePicture'],
//   //     tagNames: returnTags(json['tags']),
//   //     rawTags: json['tags'] ?? [],
//   //     id: json['id'],
//   //     title: json['title'],
//   //     url: json['url'],
//   //     text: json['content']['html'],
//   //     featureImage: json['coverImage']['url'],
//   //     slug: json['slug'],
//   //   );
//   // }
// }

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
  const factory CoverImage({required String url}) = _CoverImage;

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
    String? url,
    required Author author,
    @Default([]) List<Tag> tags,
    CoverImage? coverImage,
    required int readTimeInMinutes,
    Content? content,
    String? publishedAt,
  }) = _Post;

  factory Post.fromJson(Map<String, Object?> json) => _$PostFromJson(json);
}
