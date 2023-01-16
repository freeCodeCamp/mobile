import 'package:flutter/material.dart';
import 'package:freecodecamp/app/app.locator.dart';
import 'package:freecodecamp/app/app.router.dart';
import 'package:freecodecamp/models/news/tutorial_model.dart';
import 'package:freecodecamp/models/news/bookmarked_tutorial_model.dart';
import 'package:stacked/stacked.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart' as path;
import 'package:flutter/services.dart';
import 'dart:developer' as dev;
import 'dart:io';

import 'package:stacked_services/stacked_services.dart';

class NewsBookmarkViewModel extends BaseViewModel {
  bool _isBookmarked = false;
  bool get bookmarked => _isBookmarked;

  bool _userHasBookmarkedTutorials = false;
  bool get userHasBookmarkedTutorials => _userHasBookmarkedTutorials;

  late List<BookmarkedTutorial> _tutorials;
  List<BookmarkedTutorial> get bookMarkedTutorials => _tutorials;

  int _count = 0;
  int get count => _count;

  final NavigationService _navigationService = locator<NavigationService>();

  Future<Database> openDbConnection() async {
    WidgetsFlutterBinding.ensureInitialized();

    String dbPath = await getDatabasesPath();
    String dbPathTutorials = path.join(dbPath, 'bookmarked-article.db');
    bool dbExists = await databaseExists(dbPathTutorials);

    if (!dbExists) {
      // Making new copy from assets
      dev.log('copying database from assets');
      try {
        await Directory(
          path.dirname(dbPathTutorials),
        ).create(recursive: true);
      } catch (error) {
        dev.log(error.toString());
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

    return openDatabase(dbPathTutorials, version: 1);
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

  Future<List<Map<String, dynamic>>> getTutorials() async {
    final db = await openDbConnection();
    return db.query('bookmarks');
  }

  Future<List<BookmarkedTutorial>> getModelsFromMapList() async {
    List<Map<String, dynamic>> mapList = await getTutorials();
    List<BookmarkedTutorial> tutorialModel = [];

    for (int i = 0; i < mapList.length; i++) {
      tutorialModel.add(
        BookmarkedTutorial.fromMap(mapList[i]),
      );
    }
    return tutorialModel;
  }

  Future<void> bookmarkAndUnbookmark(dynamic tutorial) async {
    final db = await openDbConnection();

    if (_isBookmarked) {
      _isBookmarked = false;
      await db.rawQuery(
        'DELETE FROM bookmarks WHERE articleId=?',
        [tutorial!.id],
      );
      notifyListeners();
    } else {
      _isBookmarked = true;
      insertTutorial(tutorial);
      notifyListeners();
    }
  }

  Future<void> updateListView() async {
    _tutorials = [];
    _tutorials = await getModelsFromMapList();
    _tutorials = _tutorials;
    _count = _tutorials.length;
    notifyListeners();
  }

  Future<void> refresh() async {
    updateListView();
    hasBookmarkedTutorials();
  }

  Future<void> insertTutorial(dynamic tutorial) async {
    final db = await openDbConnection();

    // Test if tutorial is already in database

    List<Map> isInDatabase = await db.rawQuery(
      'SELECT * FROM bookmarks WHERE articleId=?',
      [tutorial!.id],
    );

    if (isInDatabase.isEmpty) {
      await db.insert(
        'bookmarks',
        tutorialToMap(tutorial),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    }
  }

  Future<void> isTutorialBookmarked(dynamic tutorial) async {
    final db = await openDbConnection();

    List<Map> isInDatabase = await db.rawQuery(
      'SELECT * FROM bookmarks WHERE articleId=?',
      [tutorial.id],
    );

    if (isInDatabase.isNotEmpty) {
      _isBookmarked = true;
      notifyListeners();
    }
  }

  Future<void> hasBookmarkedTutorials() async {
    final db = await openDbConnection();

    List<Map> isInDatabase = await db.rawQuery('SELECT * FROM bookmarks');

    if (isInDatabase.isNotEmpty) {
      _userHasBookmarkedTutorials = true;
      notifyListeners();
    } else {
      _userHasBookmarkedTutorials = false;
      notifyListeners();
    }
  }

  void routeToBookmarkedTutorial(BookmarkedTutorial tutorial) {
    _navigationService.navigateTo(
      Routes.newsBookmarkPostView,
      arguments: NewsBookmarkPostViewArguments(
        tutorial: tutorial,
      ),
    );
  }
}
