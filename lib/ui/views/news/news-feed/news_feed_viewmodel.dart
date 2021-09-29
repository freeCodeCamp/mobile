import 'dart:convert';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:freecodecamp/app/app.locator.dart';
import 'package:freecodecamp/app/app.router.dart';
import 'package:freecodecamp/models/article_model.dart';
import 'package:http/http.dart' as http;
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

class NewsFeedModel extends BaseViewModel {
  int _pageNumber = 0;
  final List<Article> articles = [];
  static const int itemRequestThreshold = 14;
  final _navigationService = locator<NavigationService>();

  void initState() async {
    await fetchArticles(_pageNumber);
    notifyListeners();
  }

  void navigateTo(String id) {
    _navigationService.navigateTo(Routes.newsArticlePostView,
        arguments: NewsArticlePostViewArguments(refId: id));
  }

  Future<List<Article>> fetchArticles(pageNumber) async {
    await dotenv.load(fileName: ".env");
    String page = '&page=' + pageNumber.toString();
    String par = "&fields=title,url,feature_image,id&include=tags,authors";
    String url = "${dotenv.env['NEWSURL']}${dotenv.env['NEWSKEY']}$page$par";
    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      var articleJson = json.decode(response.body)['posts'];

      for (int i = 0; i < articleJson?.length; i++) {
        articles.add(Article.fromJson(articleJson[i]));
      }
      return articles;
    } else {
      throw Exception(response.body);
    }
  }

  Future handleArticleLazyLoading(int index) async {
    var itemPosition = index + 1;
    var request = itemPosition % itemRequestThreshold == 0;
    var pageToRequest = itemPosition ~/ itemRequestThreshold;

    if (request && pageToRequest > _pageNumber) {
      _pageNumber = pageToRequest;
      await fetchArticles(_pageNumber + 1);
      notifyListeners();
    }
  }
}
