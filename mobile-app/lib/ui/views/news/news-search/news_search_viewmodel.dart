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
  List currentResult = [];

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

  // This code is a function for searching for news articles using the Algolia search engine.
  // It takes a search query as an argument and uses the similarQuery method
  // provided by the Algolia library to retrieve search results. It then generates
  // a hash of the first 10 characters of the hits and updates a hitHash variable
  // if the hash is different from the previous value. It also calls the
  // handleArticleNumber function with the number of hits as an argument.
  // Finally, it returns the list of hits as its result.

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
      List parseResult = [];

      try {
        for (int i = 0; i < snap.hits.length; i++) {
          parseResult.add(snap.hits[i].data);
        }

        hitHash = localHitHash;

        currentResult.clear();
        currentResult.addAll(parseResult);
      } catch (e) {
        log(e.toString());
      }
    }
    return results;
  }

  void setSearchTerm(value) {
    _searchTerm = value;
    notifyListeners();
  }

  void searchSubject() {
    _navigationService.navigateTo(
      Routes.newsFeedView,
      arguments: NewsFeedViewArguments(
        fromSearch: true,
        articles: currentResult,
        subject: _searchTerm == '' ? 'JavaScript' : _searchTerm,
      ),
    );
  }

  // This function gets triggered when the input of the user changes in the
  // search-bar. It checks if the amount of returned results is greater than
  // seven. If not hide the button to show more articles.

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

  // This code is handling the number of articles that are currently being viewed.
  // It calculates a step size, which is the number of additional articles to be
  // added to the current number of viewed articles, and updates the viewedAmount
  // accordingly. It also sets the setHitMaxViewed flag to indicate whether all
  // articles are currently being viewed.

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
