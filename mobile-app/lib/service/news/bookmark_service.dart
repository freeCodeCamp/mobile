import 'dart:async';
import 'dart:developer';
import 'dart:io';

import 'package:flutter/services.dart';
import 'package:freecodecamp/models/news/bookmarked_tutorial_model.dart';
import 'package:freecodecamp/models/news/tutorial_model.dart';
import 'package:path/path.dart' as path;
import 'package:sqflite/sqflite.dart';

const String bookmarksTableName = 'bookmarks';

class BookmarksDatabaseService {
  late Database _db;

  Future initialise() async {
    String dbPath = await getDatabasesPath();
    String dbPathTutorials = path.join(dbPath, 'bookmarked-article.db');
    bool dbExists = await databaseExists(dbPathTutorials);

    if (!dbExists) {
      // Making new copy from assets
      log('copying database from assets');
      try {
        await Directory(
          path.dirname(dbPathTutorials),
        ).create(recursive: true);
      } catch (error) {
        log(error.toString());
      }

      ByteData data = await rootBundle.load(
        path.join(
          'assets',
          'database',
          'bookmarked-article.db',
        ),
      );
      List<int> bytes = data.buffer.asUint8List(
        data.offsetInBytes,
        data.lengthInBytes,
      );

      await File(dbPathTutorials).writeAsBytes(bytes, flush: true);
    }

    _db = await openDatabase(dbPathTutorials, version: 1);
  }

  Map<String, dynamic> tutorialToMap(dynamic tutorial) {
    if (tutorial is Tutorial) {
      return {
        'articleTitle': tutorial.title,
        'articleId': tutorial.id,
        'articleText': tutorial.text,
        'authorName': tutorial.authorName
      };
    } else if (tutorial is BookmarkedTutorial) {
      return {
        'articleTitle': tutorial.tutorialTitle,
        'articleId': tutorial.id,
        'articleText': tutorial.tutorialText,
        'authorName': tutorial.authorName
      };
    } else {
      throw Exception(
        'unable to convert tutorial to map type: ${tutorial.runtimeType}',
      );
    }
  }

  Future<List<BookmarkedTutorial>> getBookmarks() async {
    List<Map<String, dynamic>> bookmarksResults =
        await _db.query(bookmarksTableName);

    List bookmarks = bookmarksResults
        .map(
          (tutorial) => BookmarkedTutorial.fromMap(tutorial),
        )
        .toList();

    return List.from(bookmarks.reversed);
  }

  Future<bool> isBookmarked(dynamic tutorial) async {
    List<Map<String, dynamic>> bookmarksResults = await _db.query(
      bookmarksTableName,
      where: 'articleId = ?',
      whereArgs: [tutorial.id],
    );
    return bookmarksResults.isNotEmpty;
  }

  Future addBookmark(dynamic tutorial) async {
    try {
      await _db.insert(
        bookmarksTableName,
        tutorialToMap(tutorial),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
      log('Added bookmark: ${tutorial.id}');
    } catch (e) {
      log('Could not insert the bookmark: $e');
    }
  }

  Future removeBookmark(BookmarkedTutorial tutorial) async {
    try {
      await _db.delete(
        bookmarksTableName,
        where: 'articleId = ?',
        whereArgs: [tutorial.id],
      );
      log('Removed bookmark: ${tutorial.id}');
    } catch (e) {
      log('Could not remove the bookmark: $e');
    }
  }
}
