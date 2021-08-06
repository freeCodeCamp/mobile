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
    } else {
      dev.log("opening existing database");
    }
    dev.log(dbPathArticles);
    return openDatabase(dbPathArticles, version: 1);
  }

  Map<String, dynamic> articleToMap(article) {
    return {
      "articleTitle": article!.aritcleTitle,
      "articleId": article!.articleId,
      "articleText": article!.articleText,
      "authorName": article!.author
    };
  }

  Future<void> insertArticle(Article article) async {
    final db = await openDbConnection();

    await db.insert('bookmarks', articleToMap(article),
        conflictAlgorithm: ConflictAlgorithm.replace);
    dev.log('something was inserted in the database');
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SizedBox(
          width: MediaQuery.of(context).size.width,
          child: ElevatedButton(
            onPressed: () => {insertArticle(widget.article!)},
            child: Text(
              "BOOKMARK FOR LATER",
              style: TextStyle(color: Colors.white),
            ),
            style: ElevatedButton.styleFrom(primary: Colors.blue),
          ),
        )
      ],
    );
  }
}
