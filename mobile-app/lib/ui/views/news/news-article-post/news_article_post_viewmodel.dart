import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:freecodecamp/models/article_model.dart';
import 'package:freecodecamp/ui/views/news/html_handler/html_handler.dart';
import 'package:stacked/stacked.dart';
import 'package:http/http.dart' as http;

class NewsArticlePostViewModel extends BaseViewModel {
  late Future<Article> _articleFuture;

  Future<Article> get articleFuture => _articleFuture;

  void initState(id) {
    _articleFuture = fetchArticle(id);
  }

  List<Widget> initLazyLoading(html, context, article) {
    List<Widget> elements = HtmlHandler.htmlHandler(html, context, article);
    return elements;
  }

  Future<Article> fetchArticle(articleId) async {
    await dotenv.load(fileName: ".env");

    final response = await http.get(Uri.parse(
        'https://www.freecodecamp.org/news/ghost/api/v3/content/posts/$articleId/?key=${dotenv.env['NEWSKEY']}&include=authors'));

    if (response.statusCode == 200) {
      return Article.toPostFromJson(jsonDecode(response.body));
    } else {
      throw Exception(response.body);
    }
  }
}
