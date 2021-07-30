import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';

Future<Article> fetchArticle() async {
  final response = await http.get(Uri.parse(
      "https://demo.ghost.io/ghost/api/v3/content/posts/?key=22444f78447824223cefc48062&include=tags,authors"));
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
                  final children = <Widget>[];
                  for (int i = 0; i < articels.length; i++) {
                    children.add(Column(
                      children: [
                        Row(
                          children: [
                            Expanded(
                                child: Container(
                              decoration: BoxDecoration(
                                  border: Border.all(
                                      width: 2, color: Colors.white)),
                              child:
                                  Image.network(articels[i]["feature_image"]),
                            ))
                          ],
                        ),
                        Row(
                          children: [
                            Expanded(
                              child: Container(
                                height: 100,
                                color: Color.fromRGBO(0x0A, 0x0A, 0x23, 1),
                                child: Padding(
                                  padding: const EdgeInsets.all(16.0),
                                  child: new InkWell(
                                      child: new Text(articels[i]["title"],
                                          style: TextStyle(
                                              fontSize: 24,
                                              color: Colors.white)),
                                      onTap: () => launch(articels[i]["url"])),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ));
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
