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

  bool _hasData = true;
  bool get hasData => _hasData;

  String hitHash = '';
  List currentResult = [];

  final searchbarController = TextEditingController();
  final _navigationService = locator<NavigationService>();

  set setHasData(value) {
    _hasData = value;
    notifyListeners();
  }

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
        .setHitsPerPage(7);

    AlgoliaQuerySnapshot snap = await query.getObjects();

    List<AlgoliaObjectSnapshot> results = snap.hits;

    String localHitHash = base64Encode(
      utf8.encode(snap.hits.toString()),
    );

    if (localHitHash != hitHash && snap.hits.isNotEmpty) {
      // If the hashes are different and the search results are not empty,
      // parse the data from each AlgoliaObjectSnapshot object
      // and store it in a list called "parseResult"

      List parseResult = [];

      if (!hasData) {
        setHasData = true;
      }

      try {
        for (int i = 0; i < snap.hits.length; i++) {
          parseResult.add(snap.hits[i].data);
        }

        // Update the stored hash and clear the "currentResult" list,
        // then add the elements of "parseResult" to it
        hitHash = localHitHash;

        currentResult.clear();
        currentResult.addAll(parseResult);
      } catch (e) {
        log(e.toString());
      }
    } else {
      currentResult.clear();
      if (hasData && snap.hits.isEmpty) {
        setHasData = false;
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

  void navigateToArticle(id) {
    _navigationService.navigateTo(
      Routes.newsArticleView,
      arguments: NewsArticleViewArguments(
        refId: id,
      ),
    );
  }
}
