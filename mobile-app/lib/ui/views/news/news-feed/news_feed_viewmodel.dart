import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:freecodecamp/app/app.locator.dart';
import 'package:freecodecamp/app/app.router.dart';
import 'package:freecodecamp/models/article_model.dart';
import 'package:http/http.dart' as http;
import 'package:jiffy/jiffy.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';
import 'dart:developer' as dev;

class NewsFeedModel extends BaseViewModel {
  int _pageNumber = 1;
  int get page => _pageNumber;
  final List<Article> articles = [];
  static const int itemRequestThreshold = 14;
  final _navigationService = locator<NavigationService>();

  void initState() async {
    await fetchArticles('');
    notifyListeners();
  }

  void navigateTo(String id) {
    _navigationService.navigateTo(Routes.newsArticlePostView,
        arguments: NewsArticlePostViewArguments(refId: id));
  }

  String parseDate(date) {
    return Jiffy(date).fromNow().toUpperCase();
  }

  Future<List<Article>> fetchArticles(String slug) async {
    await dotenv.load(fileName: ".env");

    String hasSlug = slug != '' ? '&filter=tag:$slug' : '';
    String page = '&page=' + _pageNumber.toString();
    String par =
        "&fields=title,url,feature_image,slug,published_at,id&include=tags,authors";
    String url =
        "${dotenv.env['NEWSURL']}posts/?key=${dotenv.env['NEWSKEY']}$page$par$hasSlug";
    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      var articleJson = json.decode(response.body)['posts'];
      dev.log(url);
      for (int i = 0; i < articleJson?.length; i++) {
        articles.add(Article.fromJson(articleJson[i]));
      }
      return articles;
    } else {
      dev.log(url);
      throw Exception(response.body);
    }
  }

  Future handleArticleLazyLoading(int index) async {
    var itemPosition = index + 1;
    var request = itemPosition % itemRequestThreshold == 0;
    var pageToRequest = itemPosition ~/ itemRequestThreshold + 1;
    if (request && pageToRequest > _pageNumber) {
      _pageNumber = pageToRequest;
      notifyListeners();
    }
  }
}
