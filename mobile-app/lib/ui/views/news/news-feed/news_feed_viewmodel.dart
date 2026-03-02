import 'dart:io';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:freecodecamp/app/app.router.dart';
import 'package:freecodecamp/constants/radio_articles.dart';
import 'package:freecodecamp/core/navigation/app_navigator.dart';
import 'package:freecodecamp/core/providers/service_providers.dart';
import 'package:freecodecamp/models/news/tutorial_model.dart';
import 'package:freecodecamp/service/news/api_service.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:jiffy/jiffy.dart';

class NewsFeedViewModel {
  NewsFeedViewModel(this._newsApiService);

  final NewsApiService _newsApiService;

  String nextPageKey = '';

  late final PagingController<String, Tutorial> _pagingController;
  PagingController<String, Tutorial> get pagingController => _pagingController;

  void initState(String tagSlug, String authorId) {
    _pagingController = PagingController(
      getNextPageKey: (state) => nextPageKey,
      fetchPage: (pageKey) =>
          fetchTutorials(pageKey, tagSlug: tagSlug, authorId: authorId),
    );
  }

  void navigateTo(String id, String slug) {
    AppNavigator.navigateTo(
      Routes.newsTutorialView,
      arguments: NewsTutorialViewArguments(refId: id, slug: slug),
    );
  }

  void navigateToAuthor(String authorSlug) {
    AppNavigator.navigateTo(
      Routes.newsAuthorView,
      arguments: NewsAuthorViewArguments(authorSlug: authorSlug),
    );
  }

  // TODO: Move to utils post-migration
  static String parseDate(date) {
    Jiffy jiffyDate = Jiffy.parseFromDateTime(DateTime.parse(date));
    String calcTimeSince = Jiffy.parseFromJiffy(jiffyDate).fromNow();

    return calcTimeSince.toUpperCase();
  }

  Future<List<Tutorial>> fetchTutorials(
    String afterCursor, {
    String? tagSlug,
    String? authorId,
  }) async {
    await dotenv.load(fileName: '.env');

    final List<Tutorial> tutorials = [];
    late final ApiData data;

    if (tagSlug != null && tagSlug != '') {
      data = await _newsApiService.getPostsByTag(
        tagSlug,
        afterCursor: afterCursor,
      );
    } else if (authorId != null && authorId != '') {
      data = await _newsApiService.getPostsByAuthor(
        authorId,
        afterCursor: afterCursor,
      );
    } else {
      data = await _newsApiService.getAllPosts(afterCursor: afterCursor);
    }

    final tutorialJson = data.posts;
    for (int i = 0; i < tutorialJson.length; i++) {
      if (Platform.isIOS && radioArticles.contains(tutorialJson[i]['id'])) {
        continue;
      }
      tutorials.add(Tutorial.fromJson(tutorialJson[i]['node']));
    }
    if (data.hasNextPage) {
      nextPageKey = data.endCursor;
    } else {
      _pagingController.value = _pagingController.value.copyWith(
        hasNextPage: false,
      );
    }
    return tutorials;
  }

  void dispose() {
    _pagingController.dispose();
  }
}

// Provider for NewsFeedViewModel — one instance per [tagSlug, authorId] pair.
final newsFeedViewModelProvider =
    Provider.family<NewsFeedViewModel, (String, String)>((ref, args) {
  final newsApiService = ref.watch(newsApiServiceProvider);
  final vm = NewsFeedViewModel(newsApiService);
  vm.initState(args.$1, args.$2);
  ref.onDispose(vm.dispose);
  return vm;
});
