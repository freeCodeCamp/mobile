import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:freecodecamp/app/app.locator.dart';
import 'package:freecodecamp/app/app.router.dart';
import 'package:freecodecamp/models/news/tutorial_model.dart';
import 'package:freecodecamp/service/developer_service.dart';
import 'package:freecodecamp/service/dio_service.dart';
import 'package:jiffy/jiffy.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

List<String> radioArticles = [
  '622c7bf563ded806bb9e8a20',
  '5f9ca12d740569d1a4ca4d23',
  '5f9ca15f740569d1a4ca4e36',
  '5f9ca198740569d1a4ca4f89',
  '5f9ca587740569d1a4ca6a0b',
  '5f9ca99d740569d1a4ca85c3',
  '5f9cafb9740569d1a4caaf5b'
];

class NewsFeedViewModel extends BaseViewModel {
  int _pageNumber = 1;
  int get page => _pageNumber;
  final List<Tutorial> tutorials = [];
  static const int itemRequestThreshold = 14;
  final _navigationService = locator<NavigationService>();
  static final _developerService = locator<DeveloperService>();
  final _dio = DioService.dio;

  bool _devMode = false;
  bool get devmode => _devMode;

  devMode() async {
    if (await _developerService.developmentMode()) {
      _devMode = true;
      notifyListeners();
    }
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

  static String parseDate(date) {
    Jiffy jiffyDate = Jiffy.parseFromDateTime(DateTime.parse(date));
    String calcTimeSince = Jiffy.parseFromJiffy(jiffyDate).fromNow();

    return calcTimeSince.toUpperCase();
  }

  Future<List<Tutorial>> readFromFiles() async {
    String json = await rootBundle.loadString(
      'assets/test_data/news_feed.json',
    );

    var decodedJson = jsonDecode(json)['posts'];

    for (int i = 0; i < decodedJson.length; i++) {
      tutorials.add(Tutorial.fromJson(decodedJson[i]));
    }

    return tutorials;
  }

  Future<List<Tutorial>> fetchTutorials(String slug, String author) async {
    await dotenv.load(fileName: '.env');

    String hasSlug = slug != '' ? '&filter=tag:$slug' : '';
    String fromAuthor = author != '' ? '&filter=author:$author' : '';
    String page = '&page=$_pageNumber';
    String par =
        '&fields=title,url,feature_image,slug,published_at,id&include=tags,authors';
    String concact = page + par + hasSlug + fromAuthor;

    String url =
        "${dotenv.env['NEWSURL']}posts/?key=${dotenv.env['NEWSKEY']}$concact";

    final response = await _dio.get(url);
    if (response.statusCode == 200) {
      var tutorialJson = response.data['posts'];
      for (int i = 0; i < tutorialJson?.length; i++) {
        if (Platform.isIOS && radioArticles.contains(tutorialJson[i]['id'])) {
          continue;
        }
        tutorials.add(Tutorial.fromJson(tutorialJson[i]));
      }
      return tutorials;
    } else {
      throw Exception(response.data);
    }
  }

  Future<List<Tutorial>> returnTutorialsFromSearch(
    List searchTutorials,
  ) async {
    for (int i = 0; i < searchTutorials.length; i++) {
      tutorials.add(Tutorial.fromSearch(searchTutorials[i]));
    }
    return tutorials;
  }

  Future<void> refresh() {
    tutorials.clear();
    _pageNumber = 1;
    notifyListeners();
    return Future.delayed(
      const Duration(seconds: 0),
    );
  }

  Future handleTutorialLazyLoading(int index) async {
    var itemPosition = index + 1;
    var request = itemPosition % itemRequestThreshold == 0;
    var pageToRequest = itemPosition ~/ itemRequestThreshold + 1;
    if (request && pageToRequest > _pageNumber) {
      _pageNumber = pageToRequest;
      notifyListeners();
    }
  }
}

class NewsFeedLazyLoading extends StatefulWidget {
  final Function tutorialCreated;
  final Widget child;

  const NewsFeedLazyLoading({
    Key? key,
    required this.tutorialCreated,
    required this.child,
  }) : super(key: key);

  @override
  NewsFeedLazyLoadingState createState() => NewsFeedLazyLoadingState();
}

class NewsFeedLazyLoadingState extends State<NewsFeedLazyLoading> {
  @override
  void initState() {
    super.initState();
    widget.tutorialCreated();
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }
}
