import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';

final children = <Widget>[];
Future<Article> fetchArticle({articleAmount = 10}) async {
  articleAmount = articleAmount.toString();
  final response = await http.get(Uri.parse(
      "https://www.freecodecamp.org/news/ghost/api/v3/content/posts/?key=&include=tags,authors&limit=" +
          articleAmount));
  if (response.statusCode == 200) {
    return Article.fromJson(jsonDecode(response.body));
  } else {
    throw Exception('Failed to load article');
  }
}

class Article {
  final List<dynamic> post;

  Article({required this.post});

  factory Article.fromJson(Map<String, dynamic> json) {
    return Article(post: json["posts"]);
  }
}

class ArticleApp extends StatefulWidget {
  const ArticleApp({Key? key}) : super(key: key);

  @override
  _ArticleAppState createState() => _ArticleAppState();
}

truncateStr(str) {
  if (str.length < 55) {
    return str + '...';
  } else {
    return str.toString().substring(0, 55) + '...';
  }
}

class _ArticleAppState extends State<ArticleApp> {
  late Future<Article> futureArticle;

  @override
  void initState() {
    super.initState();
    futureArticle = fetchArticle();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            title: const Text(
              'NEWS FEED',
              textAlign: TextAlign.center,
            ),
            backgroundColor: Color(0xFF0a0a23)),
        backgroundColor: Color.fromRGBO(0x2A, 0x2A, 0x40, 1),
        body: Center(
          child: FutureBuilder<Article>(
              future: futureArticle,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  List<dynamic> articels = snapshot.data!.post;
                  for (int i = 0; i < articels.length; i++) {
                    children.add(ArticleTemplate(articels: articels, i: i));
                  }
                  return new ListView(
                    children: children,
                  );
                } else if (snapshot.hasError) {
                  return Text('${snapshot.error}');
                }
                return const CircularProgressIndicator();
              }),
        ));
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
        Row(
          children: [
            Expanded(
                child: Container(
                    decoration: BoxDecoration(
                        border: Border.all(width: 2, color: Colors.white)),
                    child: GestureDetector(
                        onTap: () => launch(articels[i]["url"]),
                        child: Image.network(
                          articels[i]["feature_image"],
                          height: 210,
                          fit: BoxFit.fill,
                        ))))
          ],
        ),
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
                          style: TextStyle(fontSize: 24, color: Colors.white)),
                      onTap: () => launch(articels[i]["url"])),
                ),
              ),
            ),
          ],
        ),
        Row(
          children: [
            Expanded(
              child: Container(
                  color: Color(0xFF0a0a23),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: new Text(
                      "#${articels[i]['tags'][0]['name']}",
                      style: TextStyle(fontSize: 18, color: Colors.white),
                    ),
                  )),
            ),
            Column(
              children: [
                Container(
                  color: Color(0xFF0a0a23),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: new Text(
                        "Written by ${articels[i]['primary_author']['name']}",
                        style: TextStyle(fontSize: 18, color: Colors.white)),
                  ),
                )
              ],
            )
          ],
        )
      ],
    );
  }
}
