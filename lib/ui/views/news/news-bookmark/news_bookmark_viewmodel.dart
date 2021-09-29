import 'package:flutter/material.dart';
import 'package:freecodecamp/models/article_model.dart';
import 'package:freecodecamp/models/bookmarked_article_model.dart';
import 'package:stacked/stacked.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart' as path;
import 'package:flutter/services.dart';
import 'dart:developer' as dev;
import 'dart:io';

class NewsBookmarkModel extends BaseViewModel {
  bool _isBookmarked = false;
  bool get bookmarked => _isBookmarked;

  bool _userHasBookmarkedArticles = false;
  bool get userHasBookmarkedArticles => _userHasBookmarkedArticles;

  late List<BookmarkedArticle> _articles;
  List<BookmarkedArticle> get bookMarkedArticles => _articles;

  int _count = 0;
  int get count => _count;

  Future<Database> openDbConnection() async {
    WidgetsFlutterBinding.ensureInitialized();

    String dbPath = await getDatabasesPath();
    String dbPathArticles = path.join(dbPath, "bookmarked-article.db");
    bool dbExists = await databaseExists(dbPathArticles);

    if (!dbExists) {
      // Making new copy from assets
      dev.log("copying database from assets");
      try {
        await Directory(path.dirname(dbPathArticles)).create(recursive: true);
      } catch (error) {
        dev.log(error.toString());
      }

      ByteData data = await rootBundle
          .load(path.join("assets", "database", "bookmarked-article.db"));
      List<int> bytes =
          data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);

      await File(dbPathArticles).writeAsBytes(bytes, flush: true);
    }

    return openDatabase(dbPathArticles, version: 1);
  }

  Map<String, dynamic> articleToMap(Article article) {
    return {
      "articleTitle": article.title,
      "articleId": article.id,
      "articleText": article.text,
      "authorName": article.authorName
    };
  }

  Future<List<Map<String, dynamic>>> getArticles() async {
    final db = await openDbConnection();
    return db.query('bookmarks');
  }

  Future<List<BookmarkedArticle>> getModelsFromMapList() async {
    List<Map<String, dynamic>> mapList = await getArticles();
    List<BookmarkedArticle> articleModel = [];

    for (int i = 0; i < mapList.length; i++) {
      articleModel.add(BookmarkedArticle.fromMap(mapList[i]));
    }
    return articleModel;
  }

  Future<void> bookmarkAndUnbookmark(dynamic article) async {
    final db = await openDbConnection();

    if (_isBookmarked) {
      _isBookmarked = false;
      await db
          .rawQuery('DELETE FROM bookmarks WHERE articleId=?', [article!.id]);
      notifyListeners();
    } else {
      _isBookmarked = true;
      insertArticle(article);
      notifyListeners();
    }
  }

  void updateListView() async {
    dev.log("I got called by you?");
    _articles = [];
    _articles = await getModelsFromMapList();
    _articles = _articles;
    _count = _articles.length;
    notifyListeners();
  }

  Future<void> insertArticle(Article? article) async {
    final db = await openDbConnection();

    // Test if article is already in database

    List<Map> isInDatabase = await db
        .rawQuery('SELECT * FROM bookmarks WHERE articleId=?', [article!.id]);

    if (isInDatabase.isEmpty) {
      await db.insert('bookmarks', articleToMap(article),
          conflictAlgorithm: ConflictAlgorithm.replace);
    }
  }

  Future<void> isArticleBookmarked(dynamic article) async {
    final db = await openDbConnection();

    List<Map> isInDatabase = await db
        .rawQuery('SELECT * FROM bookmarks WHERE articleId=?', [article!.id]);

    if (isInDatabase.isNotEmpty) {
      _isBookmarked = true;
      notifyListeners();
    }
  }

  Future<void> hasBookmarkedArticles() async {
    final db = await openDbConnection();

    List<Map> isInDatabase = await db.rawQuery('SELECT * FROM bookmarks');

    if (isInDatabase.isNotEmpty) {
      _userHasBookmarkedArticles = true;
      updateListView();
      notifyListeners();
    }
  }
}
