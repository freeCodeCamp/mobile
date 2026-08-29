import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:mobile_app_new/models/news/post_model.dart';

part 'bookmarked_post_model.freezed.dart';

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
}
