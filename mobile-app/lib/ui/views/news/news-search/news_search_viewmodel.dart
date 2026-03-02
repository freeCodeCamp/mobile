import 'dart:io';

import 'package:algolia_helper_flutter/algolia_helper_flutter.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:freecodecamp/app/app.router.dart';
import 'package:freecodecamp/constants/radio_articles.dart';
import 'package:freecodecamp/core/navigation/app_navigator.dart';

class NewsSearchState {
  const NewsSearchState({
    this.searchTerm = '',
    this.hasData = false,
    this.isLoading = true,
    this.currentResult = const [],
  });

  final String searchTerm;
  final bool hasData;
  final bool isLoading;
  final List currentResult;

  NewsSearchState copyWith({
    String? searchTerm,
    bool? hasData,
    bool? isLoading,
    List? currentResult,
  }) {
    return NewsSearchState(
      searchTerm: searchTerm ?? this.searchTerm,
      hasData: hasData ?? this.hasData,
      isLoading: isLoading ?? this.isLoading,
      currentResult: currentResult ?? this.currentResult,
    );
  }
}

class NewsSearchNotifier extends Notifier<NewsSearchState> {
  final searchbarController = TextEditingController();

  late final HitsSearcher algolia;

  @override
  NewsSearchState build() {
    algolia = HitsSearcher(
      applicationID: dotenv.get('ALGOLIAAPPID'),
      apiKey: dotenv.get('ALGOLIAKEY'),
      indexName: 'news',
    );

    ref.onDispose(() {
      algolia.dispose();
      searchbarController.dispose();
    });

    return const NewsSearchState();
  }

  void init() {
    algolia.query('JavaScript');
    algolia.responses.listen((res) {
      // Remove radio articles from search on iOS
      if (Platform.isIOS) {
        res.hits.removeWhere(
            (element) => radioArticles.contains(element['objectID']));
      }

      state = state.copyWith(
        currentResult: res.hits,
        hasData: res.hits.isNotEmpty,
        isLoading: false,
      );
    });
  }

  void setSearchTerm(value) {
    state = state.copyWith(searchTerm: value);
    algolia.query(
      value.isEmpty ? 'JavaScript' : value,
    );
  }

  void setHasData(bool value) {
    state = state.copyWith(hasData: value);
  }

  void setIsLoading(bool value) {
    state = state.copyWith(isLoading: value);
  }

  void navigateToTutorial(String id, String slug) {
    AppNavigator.navigateTo(
      Routes.newsTutorialView,
      arguments: NewsTutorialViewArguments(
        refId: id,
        slug: slug,
      ),
    );
  }
}

final newsSearchProvider =
    NotifierProvider<NewsSearchNotifier, NewsSearchState>(
  NewsSearchNotifier.new,
);
