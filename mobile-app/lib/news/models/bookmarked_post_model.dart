import 'package:freecodecamp/news/models/post_model.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'bookmarked_post_model.freezed.dart';
part 'bookmarked_post_model.g.dart';

@freezed
abstract class BookmarkedPost with _$BookmarkedPost {
  const factory BookmarkedPost({
    required String id,
    required String title,
    required String authorName,
    required String text,
    String? coverImageUrl,
    DateTime? savedAt,
  }) = _BookmarkedPost;

  static BookmarkedPost fromPost(Post post) => BookmarkedPost(
    id: post.id,
    title: post.title,
    authorName: post.author.name,
    text: post.content.html,
    coverImageUrl: post.coverImage?.url,
  );

  factory BookmarkedPost.fromJson(Map<String, Object?> json) =>
      _$BookmarkedPostFromJson(json);
}
