import 'dart:io';

import 'package:algolia_helper_flutter/algolia_helper_flutter.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:freecodecamp/app/app.locator.dart';
import 'package:freecodecamp/app/app.router.dart';
import 'package:freecodecamp/constants/radio_articles.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

class NewsSearchModel extends BaseViewModel {
  String _searchTerm = '';
  String get getSearchTerm => _searchTerm;

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

  void init() {
    algolia.query('JavaScript');
    algolia.responses.listen((res) {
      // Remove radio articles from search on iOS
      if (Platform.isIOS) {
        res.hits.removeWhere(
            (element) => radioArticles.contains(element['objectID']));
      }

      currentResult = res.hits;
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

  // TODO: Add search results feed back post-migration
  // void searchSubject() {
  //   _navigationService.navigateTo(
  //     Routes.newsFeedView,
  //     arguments: NewsFeedViewArguments(
  //       fromSearch: true,
  //       tutorials: currentResult,
  //       subject: _searchTerm == '' ? 'JavaScript' : _searchTerm,
  //     ),
  //   );
  // }

  void navigateToTutorial(String id, String title, String slug) {
    _navigationService.navigateTo(
      Routes.newsTutorialView,
      arguments: NewsTutorialViewArguments(
        refId: id,
        slug: slug,
        title: title,
      ),
    );
  }
}
