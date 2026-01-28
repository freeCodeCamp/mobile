import 'dart:developer';

import 'package:path/path.dart' as path;
import 'package:sqflite/sqflite.dart';

const String _bookmarksTableName = 'bookmarks';

class BookmarkSqliteMigrator {
  const BookmarkSqliteMigrator();

  Future<List<Map<String, dynamic>>> readBookmarks() async {
    String dbFilePath;
    try {
      final dbPath = await getDatabasesPath();
      dbFilePath = path.join(dbPath, 'bookmarked-article.db');

      final exists = await databaseExists(dbFilePath);
      if (!exists) return [];
    } catch (e) {
      // In some environments (e.g., unit tests without sqflite factory init),
      // any sqflite call can throw. Treat that as "no legacy DB".
      log('BookmarkSqliteMigrator unavailable: $e');
      return [];
    }

    Database? db;
    try {
      db = await openDatabase(dbFilePath, version: 1);
      final results = await db.query(_bookmarksTableName);
      return results;
    } catch (e) {
      log('BookmarkSqliteMigrator failed: $e');
      return [];
    } finally {
      try {
        await db?.close();
      } catch (_) {}
    }
  }
}
