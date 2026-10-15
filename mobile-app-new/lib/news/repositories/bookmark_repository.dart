import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'bookmark_repository.g.dart';

typedef BookmarkEntry = Map<String, String>;

const _fileName = 'bookmarked-articles.json';
const _storeVersion = 1;

@riverpod
NewsBookmarkRepository newsBookmarkRepository(Ref ref) {
  return NewsBookmarkRepository();
}

class NewsBookmarkRepository {
  File? _file;

  Future<File> _resolveFile() async {
    final baseDir = await getApplicationDocumentsDirectory();
    return _file ??= File(path.join(baseDir.path, 'storage', _fileName));
  }

  Future<List<BookmarkEntry>> readBookmarks() => _serialized(_read);

  Future<void> updateBookmarks(
    List<BookmarkEntry> Function(List<BookmarkEntry> current) updater,
  ) {
    return _serialized(() async => _write(updater(await _read())));
  }

  Future<List<BookmarkEntry>> _read() async {
    final file = await _resolveFile();
    if (!await file.exists()) return [];

    try {
      final decoded = jsonDecode(await file.readAsString());
      if (decoded is Map && decoded['bookmarks'] is List) {
        return [
          for (final entry in decoded['bookmarks'] as List)
            if (entry is Map) BookmarkEntry.from(entry),
        ];
      }
      log('Bookmarks: unexpected shape in ${file.path}');
    } catch (e) {
      log('Bookmarks: cannot read ${file.path} ($e)');
    }

    return [];
  }

  Future<void> _write(List<BookmarkEntry> bookmarks) async {
    final file = await _resolveFile();
    await file.parent.create(recursive: true);

    final temp = File('${file.path}.tmp');
    await temp.writeAsString(
      jsonEncode({'version': _storeVersion, 'bookmarks': bookmarks}),
      flush: true,
    );
    await temp.rename(file.path);
  }

  Future<void> _tail = Future<void>.value();

  Future<R> _serialized<R>(Future<R> Function() action) {
    final next = _tail.then((_) => action());
    _tail = next.then((_) {}, onError: (_) {});
    return next;
  }
}
