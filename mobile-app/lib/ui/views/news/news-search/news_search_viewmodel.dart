import 'dart:convert';
import 'dart:developer';
import 'dart:io';
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

  List<String> radioArticles = [
    '622c7bf563ded806bb9e8a20',
    '5f9ca12d740569d1a4ca4d23',
    '5f9ca15f740569d1a4ca4e36',
    '5f9ca198740569d1a4ca4f89',
    '5f9ca587740569d1a4ca6a0b',
    '5f9ca99d740569d1a4ca85c3',
    '5f9cafb9740569d1a4caaf5b'
  ];

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

    if (Platform.isIOS) {
      results
          .removeWhere((element) => radioArticles.contains(element.objectID));
    }

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
