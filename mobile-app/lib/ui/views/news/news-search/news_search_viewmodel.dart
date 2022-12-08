import 'dart:convert';
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

  final searchbarController = TextEditingController();
  final _navigationService = locator<NavigationService>();

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
      handleArticleNumber(snap.hits.length);
    }
    return results;
  }

  void setSearchTerm(value) {
    _searchTerm = value;
    notifyListeners();
  }

  void handleArticleNumber(int articleAmount) {
    setMaxArticleAmount = articleAmount;

    if (articleAmount < 7) {
      setViewedAmount = articleAmount;
      setHitMaxViewed = true;
    } else {
      setViewedAmount = 7;
      setHitMaxViewed = false;
    }
  }

  void extendArticlesViewed(int articleAmount) {
    setMaxArticleAmount = articleAmount;

    if (_maxArticleAmount == viewedAmount) {
      setHitMaxViewed = true;
    } else {
      int calculateStepSize = (articleAmount - _viewedAmount) ~/ 2;

      int handleStepSize = calculateStepSize < 7
          ? articleAmount - _viewedAmount
          : calculateStepSize;

      setViewedAmount = _viewedAmount += handleStepSize;

      if (_maxArticleAmount == viewedAmount) {
        setHitMaxViewed = true;
      }
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
