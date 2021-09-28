import 'dart:convert';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:freecodecamp/models/article_model.dart';
import 'package:stacked/stacked.dart';
import 'package:http/http.dart' as http;

// TODO: make this usable with news_feed_model

class NewsArticlePostViewModel extends BaseViewModel {
  late Future<Article> _articleFuture;

  Future<Article> get articleFuture => _articleFuture;

  void initState(id) {
    _articleFuture = fetchArticle(id);
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
