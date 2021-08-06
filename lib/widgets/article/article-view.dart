import 'dart:convert';
import 'dart:developer' as dev;

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:html/dom.dart' as dom;

import 'article-feed.dart' as border;
import 'article-bookmark.dart';

Future<Article> fetchArticle(articleId) async {
  await dotenv.load(fileName: ".env");

  final response = await http.get(Uri.parse(
      'https://www.freecodecamp.org/news/ghost/api/v3/content/posts/$articleId/?key=${dotenv.env['NEWSKEY']}&include=authors'));

  dev.log(response.toString());

  if (response.statusCode == 200) {
    return Article.fromJson(jsonDecode(response.body));
  } else {
    throw Exception('Failed to load article');
  }
}

class Article {
  final String author;
  final String authorImage;
  final String articleId;
  final String aritcleTitle;
  final String articleText;
  final String articleImage;

  Article(
      {required this.author,
      required this.authorImage,
      required this.articleId,
      required this.aritcleTitle,
      required this.articleText,
      required this.articleImage});

  factory Article.fromJson(Map<String, dynamic> json) {
    return Article(
        author: json['posts'][0]['primary_author']['name'],
        authorImage: json['posts'][0]['primary_author']['profile_image'],
        articleId: json['posts'][0]['id'],
        aritcleTitle: json['posts'][0]['title'],
        articleText: json['posts'][0]['html'],
        articleImage: json['posts'][0]['feature_image']);
  }
}

class ArticleViewTemplate extends StatefulWidget {
  ArticleViewTemplate({Key? key, required this.articleId}) : super(key: key);

  final String articleId;

  _ArticleAppState createState() => _ArticleAppState();
}

class _ArticleAppState extends State<ArticleViewTemplate> {
  late Future<Article> futureArticle;
  @override
  void initState() {
    super.initState();
    futureArticle = fetchArticle(widget.articleId);
  }

  Widget build(BuildContext context) {
    return Scaffold(
        appBar:
            AppBar(title: Text('NEWSFEED'), backgroundColor: Color(0xFF0a0a23)),
        backgroundColor: Color(0xFF0a0a23),
        body: SingleChildScrollView(
            child: Column(children: [
          FutureBuilder<Article>(
              future: futureArticle,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return Column(
                    children: [
                      Row(
                        children: [
                          Expanded(
                              child: Image.network(
                            snapshot.data!.articleImage,
                            height: 250,
                            fit: BoxFit.fitHeight,
                          )),
                        ],
                      ),
                      Row(
                        children: [
                          Container(
                            color: Color.fromRGBO(0x2A, 0x2A, 0x40, 1),
                            width: MediaQuery.of(context).size.width,
                            child: Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Text(snapshot.data!.aritcleTitle,
                                  style: TextStyle(
                                      fontSize: 24, color: Colors.white)),
                            ),
                          )
                        ],
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: Container(
                              color: Color.fromRGBO(0x2A, 0x2A, 0x40, 1),
                              child: Row(
                                children: [
                                  Padding(
                                    padding: EdgeInsets.all(16),
                                    child: Container(
                                      decoration: BoxDecoration(
                                          border: Border.all(
                                              width: 4,
                                              color:
                                                  border.randomBorderColor())),
                                      child: Image.network(
                                        snapshot.data!.authorImage,
                                        width: 50,
                                        height: 50,
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                      child: Container(
                                    color: Color.fromRGBO(0x2A, 0x2A, 0x40, 1),
                                    child: Padding(
                                      padding: EdgeInsets.only(top: 8),
                                      child: Text(
                                        'Written by ' + snapshot.data!.author,
                                        style: TextStyle(
                                            fontSize: 16, color: Colors.white),
                                      ),
                                    ),
                                  ))
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                      Bookmark(article: snapshot.data),
                      htmlView(snapshot)
                    ],
                  );
                } else if (snapshot.hasError) {
                  return Text('${snapshot.error}');
                }
                return const CircularProgressIndicator();
              })
        ])));
  }

  Row htmlView(AsyncSnapshot<Article> snapshot) {
    return Row(
      children: [
        Expanded(
          child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Html(
                  shrinkWrap: true,
                  data: snapshot.data!.articleText,
                  style: {
                    "body": Style(color: Colors.white),
                    "p": Style(
                        fontSize: FontSize.large, textAlign: TextAlign.justify),
                    "ul": Style(fontSize: FontSize.xLarge),
                    "li": Style(margin: EdgeInsets.only(top: 8)),
                    "pre": Style(
                        color: Colors.white,
                        width: MediaQuery.of(context).size.width,
                        backgroundColor: Color.fromRGBO(0x2A, 0x2A, 0x40, 1),
                        padding: EdgeInsets.all(25),
                        textOverflow: TextOverflow.clip),
                    "table": Style(
                      backgroundColor: Color.fromARGB(0x50, 0xee, 0xee, 0xee),
                    ),
                    // some other granular customizations are also possible
                    "tr": Style(
                      border: Border(bottom: BorderSide(color: Colors.grey)),
                    ),
                    "th": Style(
                      padding: EdgeInsets.all(6),
                    ),
                    "td": Style(
                      padding: EdgeInsets.all(6),
                      alignment: Alignment.topLeft,
                    )
                  },
                  onLinkTap: (String? url, RenderContext context,
                      Map<String, String> attributes, dom.Element? element) {
                    launch(url!);
                  },
                  onImageTap: (String? url, RenderContext context,
                      Map<String, String> attributes, dom.Element? element) {
                    launch(url!);
                  })),
        )
      ],
    );
  }
}
