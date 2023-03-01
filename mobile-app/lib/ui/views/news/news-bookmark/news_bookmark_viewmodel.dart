import 'dart:math';

import 'package:freecodecamp/app/app.locator.dart';
import 'package:freecodecamp/app/app.router.dart';
import 'package:freecodecamp/models/news/bookmarked_tutorial_model.dart';
import 'package:freecodecamp/service/news/bookmark_service.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

class NewsBookmarkViewModel extends BaseViewModel {
  bool _isBookmarked = false;
  bool get bookmarked => _isBookmarked;

  bool _userHasBookmarkedTutorials = false;
  bool get userHasBookmarkedTutorials => _userHasBookmarkedTutorials;

  late List<BookmarkedTutorial> _tutorials;
  List<BookmarkedTutorial> get bookMarkedTutorials => _tutorials;

  int _count = 0;
  int get count => _count;

  final _navigationService = locator<NavigationService>();
  final _databaseService = locator<BookmarksDatabaseService>();

  Future<void> initDB() async {
    await _databaseService.initialise();
  }

  void bumpBookmarkDate(String id) {
    _databaseService.setBookmarkDate(id);
  }

  void listenToBookmarkChanges() {
    _databaseService.changedBookmark.stream.listen((event) {
      refresh();
    });
  }

  void addChangeToSink() {
    // Let that sink in
    _databaseService.changedBookmark.sink.add(Random());
  }

  Future<void> bookmarkAndUnbookmark(dynamic tutorial) async {
    if (_isBookmarked) {
      _isBookmarked = false;
      await _databaseService.removeBookmark(tutorial);
      notifyListeners();
    } else {
      _isBookmarked = true;
      await insertTutorial(tutorial);
      notifyListeners();
    }
  }

  Future<void> updateListView() async {
    _tutorials = await _databaseService.getBookmarks();
    _count = _tutorials.length;
    notifyListeners();
  }

  Future<void> refresh() async {
    await updateListView();
    await hasBookmarkedTutorials();
  }

  Future<void> insertTutorial(dynamic tutorial) async {
    bool isInDatabase = await _databaseService.isBookmarked(tutorial);

    if (isInDatabase == false) {
      await _databaseService.addBookmark(tutorial);
    }
  }

  Future<void> isTutorialBookmarked(dynamic tutorial) async {
    _isBookmarked = await _databaseService.isBookmarked(tutorial);
    notifyListeners();
  }

  Future<void> hasBookmarkedTutorials() async {
    var isInDatabase = await _databaseService.getBookmarks();

    if (isInDatabase.isNotEmpty) {
      _userHasBookmarkedTutorials = true;
      notifyListeners();
    } else {
      _userHasBookmarkedTutorials = false;
      notifyListeners();
    }
  }

  void routeToBookmarkedTutorial(BookmarkedTutorial tutorial) {
    _navigationService.navigateTo(
      Routes.newsBookmarkTutorialView,
      arguments: NewsBookmarkTutorialViewArguments(
        tutorial: tutorial,
      ),
    );
  }
}
