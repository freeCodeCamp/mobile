import 'dart:io';

import 'package:algolia_helper_flutter/algolia_helper_flutter.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:freecodecamp/app/app.locator.dart';
import 'package:freecodecamp/app/app.router.dart';
import 'package:freecodecamp/constants/radio_articles.dart';
import 'package:freecodecamp/service/dio_service.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

class NewsSearchModel extends BaseViewModel {
  String _searchTerm = '';
  String get getSearchTerm => _searchTerm;
  final _dio = DioService.dio;

  bool _hasData = false;
  bool get hasData => _hasData;

  bool _isLoading = true;
  bool get isLoading => _isLoading;

  List currentResult = [];

  final searchbarController = TextEditingController();
  final _navigationService = locator<NavigationService>();

  final algolia = HitsSearcher(
    applicationID: dotenv.get('ALGOLIAAPPID'),
    apiKey: dotenv.get('ALGOLIAKEY'),
    indexName: 'news',
  );

  set setHasData(value) {
    _hasData = value;
    notifyListeners();
  }

  set setIsLoading(value) {
    _isLoading = value;
    notifyListeners();
  }

  Future<bool> isHashnodeArticle(Hit hit) async {
    final res = await _dio.get(
      'https://www.freecodecamp.org/news/ghost/api/v3/content/posts/${hit["objectID"]}/?key=${dotenv.env['NEWSKEY']}',
      options: Options(
        validateStatus: (status) {
          return status == 404 || status == 200;
        },
      ),
    );
    return res.statusCode == 404;
  }

  void init() {
    algolia.query('JavaScript');
    algolia.responses.listen((res) async {
      currentResult = [];

      // Remove radio articles from search on iOS
      if (Platform.isIOS) {
        res.hits.removeWhere(
            (element) => radioArticles.contains(element['objectID']));
      }

      // Remove Hashnode articles from search
      for (final hit in res.hits) {
        if (!await isHashnodeArticle(hit)) {
          currentResult.add(hit);
        }
      }
      res.hits.removeWhere((element) => !currentResult.contains(element));

      _hasData = res.hits.isNotEmpty;
      _isLoading = false;
      notifyListeners();
    });
  }

  void onDispose() {
    algolia.dispose();
    searchbarController.dispose();
  }

  void setSearchTerm(value) {
    _searchTerm = value;
    algolia.query(
      value.isEmpty ? 'JavaScript' : value,
    );
    notifyListeners();
  }

  void searchSubject() {
    _navigationService.navigateTo(
      Routes.newsFeedView,
      arguments: NewsFeedViewArguments(
        fromSearch: true,
        tutorials: currentResult,
        subject: _searchTerm == '' ? 'JavaScript' : _searchTerm,
      ),
    );
  }

  void navigateToTutorial(String id, String title) {
    _navigationService.navigateTo(
      Routes.newsTutorialView,
      arguments: NewsTutorialViewArguments(
        refId: id,
        title: title,
      ),
    );
  }
}
