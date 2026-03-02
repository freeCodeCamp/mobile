import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:freecodecamp/app/app.router.dart';
import 'package:freecodecamp/core/navigation/app_navigator.dart';
import 'package:freecodecamp/core/providers/service_providers.dart';
import 'package:freecodecamp/models/news/bookmarked_tutorial_model.dart';
import 'package:freecodecamp/service/news/bookmark_service.dart';

class NewsBookmarkState {
  const NewsBookmarkState({
    this.isBookmarked = false,
    this.gotoTopButtonVisible = false,
    this.userHasBookmarkedTutorials = false,
    this.tutorials = const [],
    this.count = 0,
  });

  final bool isBookmarked;
  final bool gotoTopButtonVisible;
  final bool userHasBookmarkedTutorials;
  final List<BookmarkedTutorial> tutorials;
  final int count;

  NewsBookmarkState copyWith({
    bool? isBookmarked,
    bool? gotoTopButtonVisible,
    bool? userHasBookmarkedTutorials,
    List<BookmarkedTutorial>? tutorials,
    int? count,
  }) {
    return NewsBookmarkState(
      isBookmarked: isBookmarked ?? this.isBookmarked,
      gotoTopButtonVisible: gotoTopButtonVisible ?? this.gotoTopButtonVisible,
      userHasBookmarkedTutorials:
          userHasBookmarkedTutorials ?? this.userHasBookmarkedTutorials,
      tutorials: tutorials ?? this.tutorials,
      count: count ?? this.count,
    );
  }
}

class NewsBookmarkNotifier extends Notifier<NewsBookmarkState> {
  late BookmarksDatabaseService _databaseService;

  final ScrollController scrollController = ScrollController();

  @override
  NewsBookmarkState build() {
    _databaseService = ref.watch(bookmarksDatabaseServiceProvider);
    ref.onDispose(scrollController.dispose);
    return const NewsBookmarkState();
  }

  Future<void> initDB() async {
    await _databaseService.initialise();
  }

  Future<void> bookmarkAndUnbookmark(dynamic tutorial) async {
    if (state.isBookmarked) {
      state = state.copyWith(isBookmarked: false);
      await _databaseService.removeBookmark(tutorial);
    } else {
      state = state.copyWith(isBookmarked: true);
      await insertTutorial(tutorial);
    }
  }

  Future<void> updateListView() async {
    final tutorials = await _databaseService.getBookmarks();
    state = state.copyWith(tutorials: tutorials, count: tutorials.length);
  }

  Future<void> refresh() async {
    await updateListView();
    await hasBookmarkedTutorials();
  }

  Future goToTop() async {
    await scrollController.animateTo(
      0,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  Future<void> goToTopButtonHandler() async {
    scrollController.addListener(() {
      if (scrollController.offset >= 100) {
        if (!state.gotoTopButtonVisible) {
          state = state.copyWith(gotoTopButtonVisible: true);
        }
      } else {
        if (state.gotoTopButtonVisible) {
          state = state.copyWith(gotoTopButtonVisible: false);
        }
      }
    });
  }

  Future<void> insertTutorial(dynamic tutorial) async {
    bool isInDatabase = await _databaseService.isBookmarked(tutorial);

    if (isInDatabase == false) {
      await _databaseService.addBookmark(tutorial);
    }
  }

  Future<void> isTutorialBookmarked(dynamic tutorial) async {
    final isBookmarked = await _databaseService.isBookmarked(tutorial);
    state = state.copyWith(isBookmarked: isBookmarked);
  }

  Future<void> hasBookmarkedTutorials() async {
    var isInDatabase = await _databaseService.getBookmarks();

    if (isInDatabase.isNotEmpty) {
      state = state.copyWith(userHasBookmarkedTutorials: true);
    } else {
      state = state.copyWith(userHasBookmarkedTutorials: false);
    }
  }

  void routeToBookmarkedTutorial(BookmarkedTutorial tutorial) {
    AppNavigator.navigateTo(
      Routes.newsBookmarkTutorialView,
      arguments: NewsBookmarkTutorialViewArguments(
        tutorial: tutorial,
      ),
    );
  }
}

final newsBookmarkProvider =
    NotifierProvider<NewsBookmarkNotifier, NewsBookmarkState>(
  NewsBookmarkNotifier.new,
);
