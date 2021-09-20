import 'package:flutter/material.dart';
import 'package:freecodecamp/ui/views/news/news-article-post/news_article_post_model.dart';
import 'package:stacked/stacked.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart' as path;
import 'package:flutter/services.dart';
import 'dart:developer' as dev;
import 'dart:io';

class NewsBookmarkModel extends BaseViewModel {
  void initState(article) {
    articleInDb(article);
    notifyListeners();
  }

  bool _isBookmarked = false;
  bool get bookmarked => _isBookmarked;

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

  Map<String, dynamic> articleToMap(article) {
    return {
      "articleTitle": article!.articleTitle,
      "articleId": article!.articleId,
      "articleText": article!.articleText,
      "authorName": article!.author
    };
  }

  Future<void> insertArticle(Article? article) async {
    final db = await openDbConnection();

    // Test if article is already in database

    List<Map> isInDatabase = await db.rawQuery(
        'SELECT * FROM bookmarks WHERE articleId=?', [article!.articleId]);

    if (isInDatabase.isEmpty) {
      await db.insert('bookmarks', articleToMap(article),
          conflictAlgorithm: ConflictAlgorithm.replace);
    }
  }

  Future<void> articleInDb(Article? article) async {
    final db = await openDbConnection();

    List<Map> isInDatabase = await db.rawQuery(
        'SELECT * FROM bookmarks WHERE articleId=?', [article!.articleId]);

    if (isInDatabase.isNotEmpty) {
      _isBookmarked = true;
    }
  }

  Future<void> bookmarkAndUnbookmark(Article? article) async {
    final db = await openDbConnection();

    if (_isBookmarked) {
      _isBookmarked = false;
      await db.rawQuery(
          'DELETE FROM bookmarks WHERE articleId=?', [article!.articleId]);
    } else {
      _isBookmarked = true;
      insertArticle(article);
    }
  }
}
