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
        .setHitsPerPage(_maxArticleAmount);

    AlgoliaQuerySnapshot snap = await query.getObjects();

    List<AlgoliaObjectSnapshot> results = snap.hits;

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
    } else {
      setViewedAmount = articleAmount;
    }
  }

  void extendArticlesViewed() {
    // If the max article amount is already viewedAmount return and do nothing.
    // else add 7 and check again.

    if (_maxArticleAmount == viewedAmount) return;

    setViewedAmount = _viewedAmount += _stepAmount;

    if (_maxArticleAmount == viewedAmount) {
      setHitMaxViewed = true;
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
