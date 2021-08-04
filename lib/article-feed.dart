import 'dart:convert';
import 'dart:math';
import 'dart:developer' as dev;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'article-view.dart';

int page = 0;

class ArticleApp extends StatefulWidget {
  const ArticleApp({Key? key}) : super(key: key);

  @override
  _ArticleAppState createState() => _ArticleAppState();
}

truncateStr(str) {
  if (str.length < 55) {
    return str;
  } else {
    return str.toString().substring(0, 55) + '...';
  }
}

randomBorderColor() {
  final random = new Random();

  List borderColor = [
    Color.fromRGBO(0x99, 0xC9, 0xFF, 1),
    Color.fromRGBO(0xAC, 0xD1, 0x57, 1),
    Color.fromRGBO(0xFF, 0xFF, 0x00, 1),
    Color.fromRGBO(0x80, 0x00, 0x80, 1),
  ];

  int index = random.nextInt(borderColor.length);

  return borderColor[index];
}

class Article {
  final List<dynamic> post;

  Article({required this.post});

  factory Article.fromJson(Map<String, dynamic> json) {
    return Article(post: json["posts"]);
  }
}

class _ArticleAppState extends State<ArticleApp> {
  List articles = [];

  late Future<Article> futureArticle;
  ScrollController _scrollController = new ScrollController();

  @override
  void initState() {
    super.initState();
    futureArticle = fetchArticle();
    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        fetchArticle();
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
    page = 0;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: const Text(
            'NEWSFEED',
            textAlign: TextAlign.center,
          ),
          backgroundColor: Color(0xFF0a0a23)),
      backgroundColor: Color.fromRGBO(0x2A, 0x2A, 0x40, 1),
      body: FutureBuilder<Article>(
          future: futureArticle,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              dev.log(articles.length.toString());
              return ListView.builder(
                controller: _scrollController,
                itemCount: articles.length,
                itemBuilder: (BuildContext context, int index) {
                  return ArticleTemplate(articels: articles, i: index);
                },
              );
            } else if (snapshot.hasError) {
              return Text('${snapshot.error}');
            }
            return const CircularProgressIndicator();
          }),
    );
  }

  Future<Article> fetchArticle() async {
    page++;

    await dotenv.load(fileName: ".env");

    String feedUrl =
        "https://www.freecodecamp.org/news/ghost/api/v3/content/posts/?key=${dotenv.env['NEWSKEY']}&include=tags,authors&page=" +
            page.toString() +
            "&fields=title,url,feature_image,id";
    dev.log(feedUrl);
    final response = await http.get(Uri.parse(feedUrl));
    if (response.statusCode == 200) {
      var newArticles = json.decode(response.body)['posts'];
      setState(() {
        articles.addAll(newArticles);
      });
      return Article.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to load articles');
    }
  }
}

class ArticleTemplate extends StatelessWidget {
  const ArticleTemplate({
    Key? key,
    required this.articels,
    required this.i,
  }) : super(key: key);

  final List articels;
  final int i;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ArticleBanner(articels: articels, i: i),
        Row(
          children: [
            Expanded(
              child: Container(
                color: Color(0xFF0a0a23),
                height: 100,
                child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: new InkWell(
                        child: new Text(truncateStr(articels[i]["title"]),
                            style:
                                TextStyle(fontSize: 24, color: Colors.white)),
                        onTap: () => {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => ArticleViewTemplate(
                                          articleId: articels[i]["id"])))
                            })),
              ),
            ),
          ],
        ),
        Row(
          children: [
            Expanded(
              child: Container(
                  height: 55,
                  color: Color(0xFF0a0a23),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: new Text(
                      "#${articels[i]['tags'][0]['name']}",
                      style: TextStyle(fontSize: 18, color: Colors.white),
                    ),
                  )),
            ),
            Expanded(
                child: Container(
              height: 55,
              color: Color(0xFF0a0a23),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: new Text("by ${articels[i]['authors'][0]['name']}",
                    style: TextStyle(fontSize: 18, color: Colors.white)),
              ),
            ))
          ],
        )
      ],
    );
  }
}

class ArticleBanner extends StatelessWidget {
  const ArticleBanner({
    Key? key,
    required this.articels,
    required this.i,
  }) : super(key: key);

  final List articels;
  final int i;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Container(
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
                border: Border.all(width: 2, color: Colors.white)),
            child: GestureDetector(
                onTap: () => {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => ArticleViewTemplate(
                                  articleId: articels[i]["id"])))
                    },
                child: Image.network(
                  articels[i]["feature_image"],
                  height: 210,
                  fit: BoxFit.fill,
                ))),
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Align(
              alignment: Alignment.topRight,
              child: Container(
                decoration: BoxDecoration(
                    border: Border.all(width: 4, color: randomBorderColor())),
                child: Image.network(
                  articels[i]['authors'][0]['profile_image'],
                  height: 50,
                  width: 50,
                  fit: BoxFit.fill,
                ),
              )),
        )
      ],
    );
  }
}
