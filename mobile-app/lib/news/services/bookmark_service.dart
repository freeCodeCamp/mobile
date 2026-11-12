import 'dart:developer';

import 'package:freecodecamp/news/models/bookmarked_post_model.dart';
import 'package:freecodecamp/news/models/post_model.dart';
import 'package:freecodecamp/news/repositories/bookmark_repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'bookmark_service.g.dart';

// v7's on-disk key names.
const _idKey = 'articleId';
const _titleKey = 'articleTitle';
const _authorKey = 'authorName';
const _textKey = 'articleText';
const _coverKey = 'coverImageUrl';
const _savedAtKey = 'savedAt';

@riverpod
NewsBookmarkService newsBookmarkService(Ref ref) {
  final repo = ref.watch(newsBookmarkRepositoryProvider);
  return NewsBookmarkService(repo);
}

class NewsBookmarkService {
  final NewsBookmarkRepository _repo;

  NewsBookmarkService(this._repo);
  int get resetGeneration => _repo.resetGeneration;

  Future<void> clearForReset() => _repo.clearForReset();

  Future<List<BookmarkedPost>> getBookmarks() async {
    final raw = await _repo.readBookmarks();
    return [for (final entry in raw.reversed) ?_fromEntry(entry)];
  }

  Future<List<BookmarkedPost>?> toggle(BookmarkedPost post) =>
      toggleById(post.id, () async => post);

  Future<List<BookmarkedPost>?> togglePost(Post post) =>
      toggle(BookmarkedPost.fromPost(post));

  Future<List<BookmarkedPost>?> toggleSummary(
    String id,
    String slug,
    Future<Post> Function(String) loadPost,
  ) =>
      toggleById(id, () async => BookmarkedPost.fromPost(await loadPost(slug)));

  Future<List<BookmarkedPost>?> toggleById(
    String id,
    Future<BookmarkedPost> Function() loadPost,
  ) async {
    final generation = resetGeneration;
    final saved = await isBookmarked(id);
    if (generation != resetGeneration) return null;
    if (saved) {
      await removeBookmark(id);
    } else {
      final post = await loadPost();
      if (generation != resetGeneration) return null;
      await addBookmark(post);
    }

    final bookmarks = await getBookmarks();
    return generation == resetGeneration ? bookmarks : null;
  }

  Future<bool> isBookmarked(String id) async {
    final raw = await _repo.readBookmarks();
    return raw.any((entry) => entry[_idKey] == id && _fromEntry(entry) != null);
  }

  Future<void> addBookmark(BookmarkedPost post) {
    return _repo.updateBookmarks(
      (current) => List<BookmarkEntry>.from(current)
        ..removeWhere((entry) => entry[_idKey] == post.id)
        ..add(_toEntry(post.copyWith(savedAt: post.savedAt ?? DateTime.now()))),
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
    _coverKey: ?post.coverImageUrl,
    if (post.savedAt case final savedAt?)
      _savedAtKey: savedAt.toUtc().toIso8601String(),
  };

  BookmarkedPost? _fromEntry(BookmarkEntry entry) => switch (entry) {
    {
      _idKey: final String id,
      _titleKey: final String title,
      _authorKey: final String authorName,
      _textKey: final String text,
    } =>
      BookmarkedPost(
        id: id,
        title: title,
        authorName: authorName,
        text: text,
        coverImageUrl: switch (entry[_coverKey]) {
          final String cover => cover,
          _ => null,
        },
        savedAt: switch (entry[_savedAtKey]) {
          final String savedAt => DateTime.tryParse(savedAt),
          _ => null,
        },
      ),
    _ => _skipMalformedEntry(),
  };

  BookmarkedPost? _skipMalformedEntry() {
    log('Bookmarks: skipping unreadable bookmark row');
    return null;
  }
}
