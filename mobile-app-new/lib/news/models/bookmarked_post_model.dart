import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:mobile_app_new/news/models/post_model.dart';

part 'bookmarked_post_model.freezed.dart';
part 'bookmarked_post_model.g.dart';

@freezed
abstract class BookmarkedPost with _$BookmarkedPost {
  const factory BookmarkedPost({
    required String id,
    required String title,
    required String authorName,
    required String text,
  }) = _BookmarkedPost;

  static BookmarkedPost fromPost(Post post) => BookmarkedPost(
    id: post.id,
    title: post.title,
    authorName: post.author.name,
    text: post.content.html,
  );

  factory BookmarkedPost.fromJson(Map<String, Object?> json) =>
      _$BookmarkedPostFromJson(json);
}
