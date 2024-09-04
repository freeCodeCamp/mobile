import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:freecodecamp/app/app.locator.dart';
import 'package:freecodecamp/app/app.router.dart';
// import 'package:freecodecamp/constants/radio_articles.dart';
import 'package:freecodecamp/models/news/tutorial_model.dart';
import 'package:freecodecamp/service/news/api_service.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:jiffy/jiffy.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

class NewsFeedViewModel extends BaseViewModel {
  final _navigationService = locator<NavigationService>();
  final _newsApiService = locator<NewsApiServive>();

  final PagingController<String, Tutorial> _pagingController =
      PagingController(firstPageKey: '');
  PagingController<String, Tutorial> get pagingController => _pagingController;

  void initState(String tagSlug, String authorId) {
    _pagingController.addPageRequestListener((pageKey) {
      fetchTutorials(pageKey, tagSlug: tagSlug, authorId: authorId);
    });
  }

  void navigateTo(String id, String title) {
    _navigationService.navigateTo(
      Routes.newsTutorialView,
      arguments: NewsTutorialViewArguments(refId: id, title: title),
    );
  }

  void navigateToAuthor(String authorSlug) {
    _navigationService.navigateTo(
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

  // TODO: Add dev mode post-migration
  // Future<List<Tutorial>> readFromFiles() async {
  //   String json = await rootBundle.loadString(
  //     'assets/test_data/news_feed.json',
  //   );
  //   var decodedJson = jsonDecode(json)['posts'];
  //   for (int i = 0; i < decodedJson.length; i++) {
  //     tutorials.add(Tutorial.fromJson(decodedJson[i]));
  //   }
  //   return tutorials;
  // }

  void fetchTutorials(
    String afterCursor, {
    String? tagSlug,
    String? authorId,
  }) async {
    await dotenv.load(fileName: '.env');

    final List<Tutorial> tutorials = [];
    late final ApiData data;

    if (tagSlug != null && tagSlug != '') {
      // data = await _newsApiService.getPostsByTag(tagSlug: tagSlug);
    } else if (authorId != null && authorId != '') {
      data = await _newsApiService.getPostsByAuthor(
        authorId,
        afterCursor: afterCursor,
      );
    } else {
      data = await _newsApiService.getAllPosts(afterCursor: afterCursor);
    }

    // String hasSlug = tagSlug != '' ? '&filter=tag:$tagSlug' : '';
    // String fromAuthor = author != '' ? '&filter=author:$author' : '';
    // String page = '&page=$_pageNumber';
    // String par =
    //     '&fields=title,url,feature_image,slug,published_at,id&include=tags,authors';
    // String concact = page + par + hasSlug + fromAuthor;

    // String url =
    //     "${dotenv.env['NEWSURL']}posts/?key=${dotenv.env['NEWSKEY']}$concact";

    final tutorialJson = data.posts;
    for (int i = 0; i < tutorialJson.length; i++) {
      // if (Platform.isIOS && radioArticles.contains(tutorialJson[i]['id'])) {
      //   continue;
      // }
      tutorials.add(Tutorial.fromJson(tutorialJson[i]['node']));
    }
    if (data.hasNextPage) {
      _pagingController.appendPage(
        tutorials,
        data.endCursor,
      );
    } else {
      _pagingController.appendLastPage(tutorials);
    }
  }

  // TODO: Add search results feed back post-migration
  // final List<Tutorial> tutorials = [];
  // Future<List<Tutorial>> returnTutorialsFromSearch(
  //   List searchTutorials,
  // ) async {
  //   for (int i = 0; i < searchTutorials.length; i++) {
  //     tutorials.add(Tutorial.fromSearch(searchTutorials[i]));
  //   }
  //   return tutorials;
  // }

  @override
  void dispose() {
    _pagingController.dispose();
    super.dispose();
  }
}
