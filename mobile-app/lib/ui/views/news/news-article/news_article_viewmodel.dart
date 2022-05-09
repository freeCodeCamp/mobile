import 'dart:async';
import 'dart:convert';
import 'package:freecodecamp/app/app.locator.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:freecodecamp/app/app.router.dart';
import 'package:freecodecamp/models/news/article_model.dart';
import 'package:freecodecamp/service/test_service.dart';
import 'package:freecodecamp/ui/views/news/html_handler/html_handler.dart';
import 'package:stacked/stacked.dart';
import 'package:http/http.dart' as http;
import 'package:stacked_services/stacked_services.dart';
import 'dart:developer' as dev;

class NewsArticleViewModel extends BaseViewModel {
  late Future<Article> _articleFuture;
  static final NavigationService _navigationService =
      locator<NavigationService>();

  final _testservice = locator<TestService>();

  Future<Article>? get articleFuture => _articleFuture;

  final ScrollController _scrollController = ScrollController();
  ScrollController get scrollController => _scrollController;

  final ScrollController _bottomButtonController = ScrollController();
  ScrollController get bottomButtonController => _bottomButtonController;

  Future<Article> readFromFiles() async {
    String json =
        await rootBundle.loadString('assets/test_data/news_post.json');

    var decodedJson = jsonDecode(json);

    return Article.toPostFromJson(decodedJson);
  }

  Future<Article> initState(id) async {
    _scrollController.addListener(() {
      if (_scrollController.offset > 425) {
        _bottomButtonController.animateTo(_scrollController.offset,
            duration: const Duration(milliseconds: 2500),
            curve: Curves.easeInOut);
      } else {
        _bottomButtonController.animateTo(0,
            duration: const Duration(milliseconds: 500),
            curve: Curves.easeInOut);
      }
    });

    if (await _testservice.developmentMode()) {
      return readFromFiles();
    } else {
      return fetchArticle(id);
    }
  }

  static void goToAuthorProfile(String slug) {
    _navigationService.navigateTo(Routes.newsAuthorView,
        arguments: NewsAuthorViewArguments(authorSlug: slug));
  }

  List<Widget> initLazyLoading(html, context, article) {
    List<Widget> elements = HtmlHandler.htmlHandler(html, context, article);
    return elements;
  }

  Future<Article> fetchArticle(articleId) async {
    await dotenv.load(fileName: '.env');

    final response = await http.get(Uri.parse(
        'https://www.freecodecamp.org/news/ghost/api/v3/content/posts/$articleId/?key=${dotenv.env['NEWSKEY']}&include=tags,authors'));
    if (response.statusCode == 200) {
      return Article.toPostFromJson(jsonDecode(response.body));
    } else {
      throw Exception(response.body);
    }
  }
}
