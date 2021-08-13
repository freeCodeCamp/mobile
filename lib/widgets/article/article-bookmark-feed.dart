import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart' as path;

import 'dart:io';
import 'dart:developer' as dev;

import 'article-bookmark-view.dart';
import 'article-feed.dart';

class BookmarkedArticle {
  late int bookmarkId;
  late String articleTitle;
  late String articleId;
  late String articleText;
  late String authorName;

  BookmarkedArticle.fromMap(Map<String, dynamic> map) {
    bookmarkId = map['bookmark_id'];
    articleTitle = map['articleTitle'];
    articleId = map['articleId'];
    articleText = map['articleText'];
    authorName = map['authorName'];
  }

  BookmarkedArticle(
      {required this.bookmarkId,
      required this.articleTitle,
      required this.articleId,
      required this.articleText,
      required this.authorName});
}

class BookmarkViewTemplate extends StatefulWidget {
  BookmarkViewTemplate({Key? key}) : super(key: key);

  _BookmarkViewTemplateState createState() => _BookmarkViewTemplateState();
}

class _BookmarkViewTemplateState extends State<BookmarkViewTemplate> {
  List<BookmarkedArticle> _articles = [];
  bool userHasBookMarkedArticles = false;
  int count = 0;

  void initState() {
    super.initState();
    hasBookMarkedArticles();
  }

  void dispose() {
    super.dispose();
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

  Future<void> hasBookMarkedArticles() async {
    final db = await openDbConnection();

    List<Map> isInDatabase = await db.rawQuery('SELECT * FROM bookmarks');

    if (isInDatabase.length > 0) {
      setState(() {
        userHasBookMarkedArticles = true;
      });
    }
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
          return ConstrainedBox(
              constraints: BoxConstraints(minHeight: 150),
              child: Container(
                  decoration: BoxDecoration(
                      border: Border(
                          bottom: BorderSide(width: 2, color: Colors.white))),
                  child: InkWell(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => ArticleBookmarkView(
                                  article: this._articles[index])));
                    },
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Expanded(
                              flex: 8,
                              child: Padding(
                                padding: const EdgeInsets.all(25.0),
                                child: Text(
                                  truncateStr(
                                      this._articles[index].articleTitle),
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 18),
                                ),
                              ),
                            ),
                            Expanded(
                                flex: 2,
                                child: IconButton(
                                    onPressed: () {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  ArticleBookmarkView(
                                                      article: this
                                                          ._articles[index])));
                                    },
                                    icon: Icon(
                                      Icons.arrow_forward_ios,
                                      color: Colors.white,
                                    )))
                          ],
                        ),
                        Row(
                          children: [
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.all(25.0),
                                child: Text(
                                  'Written by: ' +
                                      this._articles[index].authorName,
                                  style: TextStyle(color: Colors.white),
                                ),
                              ),
                            )
                          ],
                        )
                      ],
                    ),
                  )));
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
            centerTitle: true,
            backgroundColor: Color(0xFF0a0a23)),
        backgroundColor: Color.fromRGBO(0x2A, 0x2A, 0x40, 1),
        body: userHasBookMarkedArticles
            ? populateListViewModel()
            : Center(
                child: Text(
                'Bookmark articles to view them here',
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.white),
              )));
  }
}
