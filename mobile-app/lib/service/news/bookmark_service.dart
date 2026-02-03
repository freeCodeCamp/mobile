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

  JsonFileStore<
      ({
        int version,
        bool migratedFromSqlite,
        List<BookmarkedTutorial> bookmarks,
      })>? _store;
  Future<void>? _initFuture;

  static const int _storeVersion = 1;

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
    final store = JsonFileStore<
        ({
          int version,
          bool migratedFromSqlite,
          List<BookmarkedTutorial> bookmarks,
        })>(
      file: file,
      defaultValue: (
        version: _storeVersion,
        migratedFromSqlite: false,
        bookmarks: <BookmarkedTutorial>[],
      ),
      fromJson: _fromStoreJson,
      toJson: _toStoreJson,
    );
    await store.ensureExists();
    _store = store;

    await _migrateFromSqliteIfNeeded();
  }

  Future<void> _migrateFromSqliteIfNeeded() async {
    final store = _store;
    if (store == null) return;

    await store.updateAndWrite((current) async {
      if (current.migratedFromSqlite) return current;

      // If the JSON store already has data, don't overwrite it.
      if (current.bookmarks.isNotEmpty) {
        return (
          version: current.version,
          migratedFromSqlite: true,
          bookmarks: current.bookmarks,
        );
      }

      final legacy = await _legacyMigrator.readBookmarks();
      if (legacy.isEmpty) {
        return (
          version: current.version,
          migratedFromSqlite: true,
          bookmarks: current.bookmarks,
        );
      }

      final normalized = legacy.map((row) {
        return BookmarkedTutorial.fromMap(<String, dynamic>{
          'articleId': row['articleId'],
          'articleTitle': row['articleTitle'],
          'authorName': row['authorName'],
          'articleText': row['articleText'],
        });
      }).toList();

      log('Migrated ${normalized.length} bookmarks from SQLite to JSON');
      return (
        version: _storeVersion,
        migratedFromSqlite: true,
        bookmarks: normalized,
      );
    });
  }

  static ({
    int version,
    bool migratedFromSqlite,
    List<BookmarkedTutorial> bookmarks,
  }) _fromStoreJson(JsonMap json) {
    final version = json['version'];
    final migratedFromSqlite = json['migratedFromSqlite'] == true;

    final raw = json['bookmarks'];
    final bookmarks = <BookmarkedTutorial>[];
    if (raw is List) {
      for (final entry in raw) {
        if (entry is Map) {
          final m = Map<String, dynamic>.from(entry);
          bookmarks.add(
            BookmarkedTutorial(
              id: m['articleId'],
              tutorialTitle: m['articleTitle'],
              authorName: m['authorName'],
              tutorialText: m['articleText'],
            ),
          );
        }
      }
    }

    return (
      version: version,
      migratedFromSqlite: migratedFromSqlite,
      bookmarks: bookmarks,
    );
  }

  static JsonMap _toStoreJson(
    ({
      int version,
      bool migratedFromSqlite,
      List<BookmarkedTutorial> bookmarks,
    }) value,
  ) {
    return <String, dynamic>{
      'version': value.version,
      'migratedFromSqlite': value.migratedFromSqlite,
      'bookmarks': value.bookmarks.map((b) {
        return {
          'articleId': b.id,
          'articleTitle': b.tutorialTitle,
          'authorName': b.authorName,
          'articleText': b.tutorialText,
        };
      }).toList(),
    };
  }

  BookmarkedTutorial _toBookmarkedTutorial(Object tutorial) {
    if (tutorial is Tutorial) {
      return BookmarkedTutorial(
        id: tutorial.id,
        tutorialTitle: tutorial.title,
        authorName: tutorial.authorName,
        tutorialText: tutorial.text ?? '',
      );
    } else if (tutorial is BookmarkedTutorial) {
      return tutorial;
    } else {
      throw Exception(
        'unable to convert tutorial to map type: ${tutorial.runtimeType}',
      );
    }
  }

  String _idFor(Object tutorial) {
    if (tutorial is Tutorial) return tutorial.id;
    if (tutorial is BookmarkedTutorial) return tutorial.id;
    throw Exception('unsupported tutorial type: ${tutorial.runtimeType}');
  }

  Future<List<BookmarkedTutorial>> getBookmarks() async {
    await initialise();
    final store = _store!;

    final data = await store.read();
    return List<BookmarkedTutorial>.from(data.bookmarks.reversed);
  }

  Future<bool> isBookmarked(Object tutorial) async {
    await initialise();
    final store = _store!;
    final data = await store.read();
    final id = _idFor(tutorial);
    return data.bookmarks.any((b) => b.id == id);
  }

  Future addBookmark(Object tutorial) async {
    await initialise();
    final store = _store!;
    await store.updateAndWrite((current) async {
      final list = List<BookmarkedTutorial>.from(current.bookmarks);
      final id = _idFor(tutorial);
      list.removeWhere((b) => b.id == id);
      list.add(_toBookmarkedTutorial(tutorial));

      log('Added bookmark: $id');
      return (
        version: current.version,
        migratedFromSqlite: current.migratedFromSqlite,
        bookmarks: list,
      );
    });
  }

  Future removeBookmark(Object tutorial) async {
    await initialise();
    final store = _store!;
    await store.updateAndWrite((current) async {
      final list = List<BookmarkedTutorial>.from(current.bookmarks);
      final id = _idFor(tutorial);
      list.removeWhere((b) => b.id == id);
      log('Removed bookmark: $id');
      return (
        version: current.version,
        migratedFromSqlite: current.migratedFromSqlite,
        bookmarks: list,
      );
    });
  }
}
