import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart' as path;

import 'dart:io';
import 'dart:developer' as dev;

class BookmarkedArticle {
  late int bookmarkId;
  late String articleTitle;
  late String articleText;
  late String authorName;

  BookmarkedArticle.fromMap(Map<String, dynamic> map) {
    bookmarkId = map['bookmark_id'];
    articleTitle = map['articleTitle'];
    articleText = map['articleText'];
    authorName = map['authorName'];
  }

  BookmarkedArticle(
      {required this.bookmarkId,
      required this.articleTitle,
      required this.articleText,
      required this.authorName});
}

class BookmarkViewTemplate extends StatefulWidget {
  BookmarkViewTemplate({Key? key}) : super(key: key);

  _BookmarkViewTemplateState createState() => _BookmarkViewTemplateState();
}

class _BookmarkViewTemplateState extends State<BookmarkViewTemplate> {
  List<BookmarkedArticle> _articles = [];
  int count = 0;

  void initState() {
    super.initState();
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
    } else {
      dev.log("opening existing database");
    }
    dev.log(dbPathArticles);
    return openDatabase(dbPathArticles, version: 1);
  }

  Future<List<Map<String, dynamic>>> getArticles() async {
    final db = await openDbConnection();
    dev.log('getting the articles from the table');
    return db.query('bookmarks');
  }

  Future<List<BookmarkedArticle>> getModelsFromMapList() async {
    List<Map<String, dynamic>> mapList = await getArticles();
    List<BookmarkedArticle> articleModel = [];

    for (int i = 0; i < mapList.length; i++) {
      articleModel.add(BookmarkedArticle.fromMap(mapList[i]));
    }
    dev.log('this is the list of articles' + articleModel.toString());
    return articleModel;
  }

  updateListView() async {
    _articles = await getModelsFromMapList();

    setState(() {
      _articles = _articles;
      count = _articles.length;
    });
  }

  ListView populateListViewModel() {
    return ListView.builder(
        itemCount: count,
        itemBuilder: (context, index) {
          dev.log(this._articles[index].articleTitle);
          return Card(
              child: ListTile(
            title: Text(this._articles[index].articleTitle),
          ));
        });
  }

  @override
  Widget build(BuildContext context) {
    if (_articles.length == 0) {
      _articles = [];
      updateListView();
    }
    return Scaffold(
      appBar: AppBar(
          title: Text('BOOKMARKED ARTICLES'),
          backgroundColor: Color(0xFF0a0a23)),
      backgroundColor: Color(0xFF0a0a23),
      body: populateListViewModel(),
    );
  }
}
