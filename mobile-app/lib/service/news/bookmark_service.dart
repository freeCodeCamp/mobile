import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:flutter/services.dart';
import 'package:freecodecamp/models/news/bookmarked_tutorial_model.dart';
import 'package:freecodecamp/models/news/tutorial_model.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

const String bookmarksTableName = 'bookmarks';
const String articlesFileName = 'articles.json';

class BookmarksDatabaseService {
  List<BookmarkedTutorial> _bookmarks = [];
  File? _articlesFile;
  int _nextBookmarkId = 1;

  Future initialise() async {
    try {
      final directory = await getApplicationDocumentsDirectory();
      _articlesFile = File(path.join(directory.path, articlesFileName));
      
      // Try to migrate from old SQLite database first
      await _migrateFromSqliteIfExists();
      
      // Load existing bookmarks from JSON file
      await _loadBookmarksFromFile();
      
      log('Bookmark service initialized with ${_bookmarks.length} bookmarks');
    } catch (e) {
      log('Error initializing bookmark service: $e');
      _bookmarks = [];
    }
  }

  Future _migrateFromSqliteIfExists() async {
    try {
      String dbPath = await getDatabasesPath();
      String dbPathTutorials = path.join(dbPath, 'bookmarked-article.db');
      bool dbExists = await databaseExists(dbPathTutorials);
      
      if (dbExists && _bookmarks.isEmpty) {
        log('Migrating bookmarks from SQLite database');
        Database db = await openDatabase(dbPathTutorials, version: 1);
        
        List<Map<String, dynamic>> results = await db.query(bookmarksTableName);
        
        for (Map<String, dynamic> row in results) {
          BookmarkedTutorial bookmark = BookmarkedTutorial.fromMap(row);
          _bookmarks.add(bookmark);
          if (bookmark.bookmarkId >= _nextBookmarkId) {
            _nextBookmarkId = bookmark.bookmarkId + 1;
          }
        }
        
        await db.close();
        
        // Save migrated data to JSON file
        await _saveBookmarksToFile();
        
        log('Successfully migrated ${_bookmarks.length} bookmarks from SQLite');
      }
    } catch (e) {
      log('Error during SQLite migration: $e');
    }
  }

  Future _loadBookmarksFromFile() async {
    try {
      if (_articlesFile == null || !await _articlesFile!.exists()) {
        log('Articles file does not exist, starting with empty bookmarks');
        _bookmarks = [];
        return;
      }

      String contents = await _articlesFile!.readAsString();
      if (contents.trim().isEmpty) {
        log('Articles file is empty, starting with empty bookmarks');
        _bookmarks = [];
        return;
      }

      List<dynamic> jsonList = json.decode(contents);
      _bookmarks = jsonList.map((json) => BookmarkedTutorial.fromJson(json)).toList();
      
      // Update next bookmark ID
      if (_bookmarks.isNotEmpty) {
        int maxId = _bookmarks.map((b) => b.bookmarkId).reduce((a, b) => a > b ? a : b);
        _nextBookmarkId = maxId + 1;
      }
      
      log('Loaded ${_bookmarks.length} bookmarks from file');
    } catch (e) {
      log('Error loading bookmarks from file: $e');
      _bookmarks = [];
    }
  }

  Future _saveBookmarksToFile() async {
    try {
      if (_articlesFile == null) {
        log('Articles file not initialized');
        return;
      }

      // Ensure the directory exists
      await _articlesFile!.parent.create(recursive: true);
      
      List<Map<String, dynamic>> jsonList = _bookmarks.map((b) => b.toJson()).toList();
      String jsonString = json.encode(jsonList);
      
      await _articlesFile!.writeAsString(jsonString);
      log('Saved ${_bookmarks.length} bookmarks to file');
    } catch (e) {
      log('Error saving bookmarks to file: $e');
    }
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
    return List.from(_bookmarks.reversed);
  }

  Future<bool> isBookmarked(dynamic tutorial) async {
    return _bookmarks.any((bookmark) => bookmark.id == tutorial.id);
  }

  Future addBookmark(dynamic tutorial) async {
    try {
      // Check if already bookmarked
      if (await isBookmarked(tutorial)) {
        log('Bookmark already exists: ${tutorial.id}');
        return;
      }

      Map<String, dynamic> tutorialMap = tutorialToMap(tutorial);
      
      BookmarkedTutorial bookmark = BookmarkedTutorial(
        bookmarkId: _nextBookmarkId++,
        tutorialTitle: tutorialMap['articleTitle'],
        id: tutorialMap['articleId'],
        tutorialText: tutorialMap['articleText'] ?? '',
        authorName: tutorialMap['authorName'],
      );

      _bookmarks.add(bookmark);
      await _saveBookmarksToFile();
      
      log('Added bookmark: ${tutorial.id}');
    } catch (e) {
      log('Could not insert the bookmark: $e');
    }
  }

  Future removeBookmark(dynamic tutorial) async {
    try {
      int initialLength = _bookmarks.length;
      _bookmarks.removeWhere((bookmark) => bookmark.id == tutorial.id);
      
      if (_bookmarks.length < initialLength) {
        await _saveBookmarksToFile();
        log('Removed bookmark: ${tutorial.id}');
      } else {
        log('Bookmark not found for removal: ${tutorial.id}');
      }
    } catch (e) {
      log('Could not remove the bookmark: $e');
    }
  }
}
