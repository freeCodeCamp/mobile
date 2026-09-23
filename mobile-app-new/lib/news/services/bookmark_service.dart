import 'package:mobile_app_new/news/models/bookmarked_post_model.dart';
import 'package:mobile_app_new/news/repositories/bookmark_repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'bookmark_service.g.dart';

// v7's on-disk key names.
const _idKey = 'articleId';
const _titleKey = 'articleTitle';
const _authorKey = 'authorName';
const _textKey = 'articleText';

@riverpod
NewsBookmarkService newsBookmarkService(Ref ref) {
  final repo = ref.watch(newsBookmarkRepositoryProvider);
  return NewsBookmarkService(repo);
}

class NewsBookmarkService {
  final NewsBookmarkRepository _repo;

  NewsBookmarkService(this._repo);

  Future<List<BookmarkedPost>> getBookmarks() async {
    final raw = await _repo.readBookmarks();
    return raw.reversed.map(_fromEntry).toList();
  }

  Future<bool> isBookmarked(String id) async {
    final raw = await _repo.readBookmarks();
    return raw.any((entry) => entry[_idKey] == id);
  }

  Future<void> addBookmark(BookmarkedPost post) {
    return _repo.updateBookmarks(
      (current) => List<BookmarkEntry>.from(current)
        ..removeWhere((entry) => entry[_idKey] == post.id)
        ..add(_toEntry(post)),
    );
  }

  Future<void> removeBookmark(String id) {
    return _repo.updateBookmarks(
      (current) =>
          List<BookmarkEntry>.from(current)
            ..removeWhere((entry) => entry[_idKey] == id),
    );
  }

  BookmarkEntry _toEntry(BookmarkedPost post) => {
    _idKey: post.id,
    _titleKey: post.title,
    _authorKey: post.authorName,
    _textKey: post.text,
  };

  BookmarkedPost _fromEntry(BookmarkEntry entry) => switch (entry) {
    {
      _idKey: final String id,
      _titleKey: final String title,
      _authorKey: final String authorName,
      _textKey: final String text,
    } =>
      BookmarkedPost(id: id, title: title, authorName: authorName, text: text),
    _ => throw FormatException('Malformed bookmark entry: $entry'),
  };
}
