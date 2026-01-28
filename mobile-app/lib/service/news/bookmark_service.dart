import 'dart:developer';
import 'dart:io';

import 'package:freecodecamp/models/news/bookmarked_tutorial_model.dart';
import 'package:freecodecamp/models/news/tutorial_model.dart';
import 'package:freecodecamp/service/news/legacy/bookmark_sqlite_migrator.dart';
import 'package:freecodecamp/service/storage/json_file_store.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';

class BookmarksDatabaseService {
  BookmarksDatabaseService({Directory? storageDirectoryOverride})
      : _storageDirectoryOverride = storageDirectoryOverride;

  final Directory? _storageDirectoryOverride;
  final _legacyMigrator = const BookmarkSqliteMigrator();

  JsonFileStore? _store;
  Future<void>? _initFuture;

  Future<void> initialise() {
    _initFuture ??= _initialiseInternal();
    return _initFuture!;
  }

  Future<void> _initialiseInternal() async {
    final baseDir =
        _storageDirectoryOverride ?? await getApplicationDocumentsDirectory();

    final file = File(
      path.join(baseDir.path, 'storage', 'bookmarked-articles.json'),
    );
    final store = JsonFileStore(
      file: file,
      defaultValue: {
        'version': 1,
        'migratedFromSqlite': false,
        'bookmarks': [],
      },
    );
    await store.ensureExists();
    _store = store;

    await _migrateFromSqliteIfNeeded();
  }

  Future<void> _migrateFromSqliteIfNeeded() async {
    final store = _store;
    if (store == null) return;

    await store.updateAndWrite((current) async {
      final migrated = current['migratedFromSqlite'] == true;
      final existing = current['bookmarks'] ?? [];
      if (migrated) return current;

      // If the JSON store already has data, don't overwrite it.
      if (existing.isNotEmpty) {
        return {
          ...current,
          'migratedFromSqlite': true,
        };
      }

      final legacy = await _legacyMigrator.readBookmarks();
      if (legacy.isEmpty) {
        return {
          ...current,
          'migratedFromSqlite': true,
        };
      }

      final normalized = legacy.map((row) {
        return {
          'articleTitle': row['articleTitle'],
          'articleId': row['articleId'],
          'articleText': row['articleText'],
          'authorName': row['authorName'],
        };
      }).toList();

      log('Migrated ${normalized.length} bookmarks from SQLite to JSON');
      return {
        ...current,
        'migratedFromSqlite': true,
        'bookmarks': normalized,
      };
    });
  }

  Map<String, dynamic> tutorialToMap(dynamic tutorial) {
    if (tutorial is Tutorial) {
      return {
        'articleId': tutorial.id,
        'articleTitle': tutorial.title,
        'authorName': tutorial.authorName,
        'articleText': tutorial.text,
      };
    } else if (tutorial is BookmarkedTutorial) {
      return {
        'articleId': tutorial.id,
        'articleTitle': tutorial.tutorialTitle,
        'authorName': tutorial.authorName,
        'articleText': tutorial.tutorialText,
      };
    } else {
      throw Exception(
        'unable to convert tutorial to map type: ${tutorial.runtimeType}',
      );
    }
  }

  Future<List<BookmarkedTutorial>> getBookmarks() async {
    await initialise();
    final store = _store!;

    final data = await store.read();
    final raw = (data['bookmarks'] as List?) ?? <dynamic>[];

    final normalized = <Map<String, dynamic>>[];
    for (var i = 0; i < raw.length; i++) {
      final entry = raw[i];
      if (entry is Map) {
        normalized.add(Map<String, dynamic>.from(entry));
      }
    }

    final bookmarks = normalized
        .map((tutorial) => BookmarkedTutorial.fromMap(tutorial))
        .toList();

    return List<BookmarkedTutorial>.from(bookmarks.reversed);
  }

  Future<bool> isBookmarked(dynamic tutorial) async {
    await initialise();
    final store = _store!;
    final data = await store.read();
    final raw = (data['bookmarks'] as List?) ?? <dynamic>[];
    return raw.any((e) => e is Map && e['articleId'] == tutorial.id);
  }

  Future addBookmark(dynamic tutorial) async {
    await initialise();
    final store = _store!;
    await store.updateAndWrite((current) async {
      final raw = (current['bookmarks'] as List?) ?? <dynamic>[];
      final list = raw
          .whereType<Map>()
          .map((e) => Map<String, dynamic>.from(e))
          .toList();

      list.removeWhere((e) => e['articleId'] == tutorial.id);
      list.add(tutorialToMap(tutorial));

      log('Added bookmark: ${tutorial.id}');
      return {
        ...current,
        'bookmarks': list,
      };
    });
  }

  Future removeBookmark(dynamic tutorial) async {
    await initialise();
    final store = _store!;
    await store.updateAndWrite((current) async {
      final raw = (current['bookmarks'] as List?) ?? <dynamic>[];
      final list = raw
          .whereType<Map>()
          .map((e) => Map<String, dynamic>.from(e))
          .toList();

      list.removeWhere((e) => e['articleId'] == tutorial.id);
      log('Removed bookmark: ${tutorial.id}');
      return {
        ...current,
        'bookmarks': list,
      };
    });
  }
}
