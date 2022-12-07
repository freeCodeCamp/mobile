import 'dart:convert';
import 'dart:developer';

import 'package:algolia/algolia.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:freecodecamp/app/app.locator.dart';
import 'package:freecodecamp/app/app.router.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

class NewsSearchModel extends BaseViewModel {
  String _searchTerm = '';
  String get getSearchTerm => _searchTerm;

  String hitHash = '';

  int _maxArticleAmount = 21;
  int get getMaxArticleAmount => _maxArticleAmount;

  int _stepAmount = 7;

  int _viewedAmount = 7;
  int get viewedAmount => _viewedAmount;

  bool _hitMaxViewed = false;
  bool get hitMaxViewed => _hitMaxViewed;

  set setViewedAmount(value) {
    _viewedAmount = value;
    notifyListeners();
  }

  set setHitMaxViewed(value) {
    _hitMaxViewed = value;
    notifyListeners();
  }

  set setMaxArticleAmount(value) {
    _maxArticleAmount = value;
    notifyListeners();
  }

  set setStepAmount(value) {
    _stepAmount = value;
    notifyListeners();
  }

  final searchbarController = TextEditingController();
  final _navigationService = locator<NavigationService>();

  ScrollController controller = ScrollController();

  Future<List<AlgoliaObjectSnapshot>> search(String inputQuery) async {
    await dotenv.load(fileName: '.env');

    final Algolia algoliaInit = Algolia.init(
      applicationId: dotenv.env['ALGOLIAAPPID'] as String,
      apiKey: dotenv.env['ALGOLIAKEY'] as String,
    );

    Algolia algolia = algoliaInit;

    AlgoliaQuery query = algolia.instance
        .index('news')
        .similarQuery(inputQuery.isEmpty ? 'JavaScript' : inputQuery)
        .setHitsPerPage(21);

    AlgoliaQuerySnapshot snap = await query.getObjects();

    List<AlgoliaObjectSnapshot> results = snap.hits;

    String localHitHash = base64Encode(
      utf8.encode(
        snap.hits.toString().substring(0, 10),
      ),
    );

    if (localHitHash != hitHash && snap.hits.isNotEmpty) {
      hitHash = localHitHash;
      handleArticleStepAmount(snap.hits.length);
    }
    return results;
  }

  void setSearchTerm(value) {
    _searchTerm = value;
    notifyListeners();
  }

  void handleArticleStepAmount(int articleAmount) {
    _maxArticleAmount = articleAmount;

    if (articleAmount <= 7) {
      setViewedAmount = articleAmount;
      setHitMaxViewed = true;
    } else {
      setViewedAmount = 7;
      setHitMaxViewed = false;
      setStepAmount = articleAmount ~/ 3;
    }
  }

  void extendArticlesViewed() {
    // If the max article amount is already viewedAmount return and do nothing.
    // else add 7 and check again.

    if (_maxArticleAmount == viewedAmount) {
      setMaxArticleAmount = true;
    } else {
      setViewedAmount = _viewedAmount += _stepAmount;
    }
  }

  void navigateToArticle(id) {
    _navigationService.navigateTo(
      Routes.newsArticleView,
      arguments: NewsArticleViewArguments(
        refId: id,
      ),
    );
  }
}
