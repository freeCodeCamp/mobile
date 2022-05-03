import 'dart:convert';
import 'dart:math';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:freecodecamp/app/app.locator.dart';
import 'package:freecodecamp/app/app.router.dart';
import 'package:freecodecamp/models/news/article_model.dart';
import 'package:freecodecamp/service/test_service.dart';
import 'package:http/http.dart' as http;
import 'package:jiffy/jiffy.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

class NewsFeedModel extends BaseViewModel {
  int _pageNumber = 1;
  int get page => _pageNumber;
  final List<Article> articles = [];
  static const int itemRequestThreshold = 14;
  final _navigationService = locator<NavigationService>();
  static final _testService = locator<TestService>();

  bool _devMode = false;
  bool get devmode => _devMode;

  // of 100% the recommendation percetage = 100% - 90% = 10%;
  int _recommendationPercentage = 90;

  devMode() async {
    if (await _testService.developmentMode()) {
      _devMode = true;
      notifyListeners();
    }
  }

  void navigateTo(String id) {
    _navigationService.navigateTo(Routes.newsArticleView,
        arguments: NewsArticleViewArguments(refId: id));
  }

  void navigateToAuthor(String authorSlug) {
    _navigationService.navigateTo(Routes.newsAuthorView,
        arguments: NewsAuthorViewArguments(authorSlug: authorSlug));
  }

  static String parseDate(date) {
    return Jiffy(date).fromNow().toUpperCase();
  }

  Future<List<Article>> readFromFiles() async {
    String json =
        await rootBundle.loadString('assets/test_data/news_feed.json');

    var decodedJson = jsonDecode(json)['posts'];

    for (int i = 0; i < decodedJson.length; i++) {
      articles.add(Article.fromJson(decodedJson[i]));
    }

    return articles;
  }

  Future<void> setRecentlyVisitedSubjects(String subject) async {
    if (subject.isNotEmpty) {
      SharedPreferences prefs = await SharedPreferences.getInstance();

      List<String>? subjects = prefs.getStringList('subjects_clicked');

      if (subjects == null) {
        prefs.setStringList('subjects_clicked', [subject]);
      }

      if (subjects != null) {
        if (subjects.contains(subject)) return;

        if (subjects.length == 10) {
          subjects.removeLast();
        }
        subjects.add(subject);
        subjects.shuffle();
        prefs.setStringList('subjects_clicked', subjects);
      }
    }
  }

  Future<List<Article>> fetchArticles(String slug, String author) async {
    await dotenv.load(fileName: '.env');

    String hasSlug = slug != '' ? '&filter=tag:$slug' : '';
    String fromAuthor = author != '' ? '&filter=author:$author' : '';
    String page = '&page=' + _pageNumber.toString();
    String par =
        '&fields=title,url,feature_image,slug,published_at,id&include=tags,authors';
    String concact = page + par + hasSlug + fromAuthor;

    String url =
        "${dotenv.env['NEWSURL']}posts/?key=${dotenv.env['NEWSKEY']}$concact";

    setRecentlyVisitedSubjects(slug);

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

  Future<void> refresh() {
    articles.clear();
    _pageNumber = 1;
    notifyListeners();
    return Future.delayed(const Duration(seconds: 0));
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

  shouldRecommend() {
    Random random = Random();
    int randomNum = random.nextInt(100);
    return randomNum > _recommendationPercentage;
  }

  Future<List<Article>> recommendationWidgetFuture() async {
    List<Article> articles = [];

    Random random = Random();

    SharedPreferences prefs = await SharedPreferences.getInstance();

    if (prefs.getStringList('subjects_clicked') != null) {
      List<String> subjects = prefs.getStringList('subjects_clicked')!;

      int randomNum = random.nextInt(subjects.length - 1);

      articles.addAll(await fetchArticles(subjects[randomNum], ''));
    }

    return articles;
  }
}
