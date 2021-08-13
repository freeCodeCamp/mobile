import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart' as path;
import 'package:flutter/services.dart';
import 'dart:developer' as dev;
import 'dart:io';
import 'article-view.dart';

class Bookmark extends StatefulWidget {
  const Bookmark({Key? key, required this.article}) : super(key: key);

  final Article? article;

  @override
  _BookmarkState createState() => _BookmarkState();
}

class _BookmarkState extends State<Bookmark> {
  bool isBookmarked = false;

  void initState() {
    super.initState();
    articleInDb(widget.article);
  }

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

    if (isInDatabase.length == 0) {
      await db.insert('bookmarks', articleToMap(article),
          conflictAlgorithm: ConflictAlgorithm.replace);
    }
  }

  Future<void> articleInDb(Article? article) async {
    final db = await openDbConnection();

    List<Map> isInDatabase = await db.rawQuery(
        'SELECT * FROM bookmarks WHERE articleId=?', [article!.articleId]);

    if (isInDatabase.length > 0) {
      setState(() {
        isBookmarked = true;
      });
    }
  }

  Future<void> bookmarkAndUnbookmark(Article? article) async {
    final db = await openDbConnection();

    if (isBookmarked) {
      setState(() {
        isBookmarked = false;
      });
      await db.rawQuery(
          'DELETE FROM bookmarks WHERE articleId=?', [article!.articleId]);
    } else {
      setState(() {
        isBookmarked = true;
      });
      insertArticle(article);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8),
      child: TextButton.icon(
        onPressed: () {
          bookmarkAndUnbookmark(widget.article);
        },
        style: TextButton.styleFrom(
            primary: Color.fromRGBO(0x2A, 0x2A, 0x40, 1),
            alignment: Alignment.centerLeft),
        icon: Icon(
            isBookmarked ? Icons.bookmark_sharp : Icons.bookmark_border_sharp,
            color: Colors.white),
        label: Text(
          isBookmarked ? 'Article is bookmarked' : 'Bookmark for offline usage',
          style: TextStyle(fontSize: 20, color: Colors.white),
        ),
      ),
    );
  }
}
