import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:freecodecamp/models/news/article_model.dart';

import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';

import 'dart:developer' as dev;

class ArticleList extends StatefulWidget {
  const ArticleList(
      {Key? key, required this.listSize, required this.authorName})
      : super(key: key);

  final int listSize;
  final String authorName;

  Future<List<Article>> fetchList() async {
    List<Article> articles = [];

    await dotenv.load();

    String par =
        "&fields=title,url,feature_image,slug,published_at,id&include=tags,authors";
    String url =
        "${dotenv.env['NEWSURL']}posts/?key=${dotenv.env['NEWSKEY']}&page=1$par&filter=author:$authorName";

    final http.Response response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      var articleJson = json.decode(response.body)['posts'];
      for (int i = 0; i < articleJson?.length; i++) {
        articles.add(Article.fromJson(articleJson[i]));
      }
      return articles;
    } else {
      throw Exception('Something when wrong when fetching $url');
    }
  }

  @override
  State<StatefulWidget> createState() => ArticleListState();
}

class ArticleListState extends State<ArticleList> {
  @override
  void initState() {
    super.initState();
    widget.fetchList();
  }

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
