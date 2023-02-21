import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:freecodecamp/app/app.locator.dart';
import 'package:freecodecamp/app/app.router.dart';
import 'package:freecodecamp/models/news/tutorial_model.dart';
import 'package:freecodecamp/service/developer_service.dart';
import 'package:http/http.dart' as http;
import 'package:jiffy/jiffy.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:flutter/material.dart';

class NewsFeedViewModel extends BaseViewModel {
  int _pageNumber = 1;
  int get page => _pageNumber;
  final List<Tutorial> tutorials = [];
  static const int itemRequestThreshold = 14;
  final _navigationService = locator<NavigationService>();
  static final _developerService = locator<DeveloperService>();

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
    return Jiffy(date).fromNow().toUpperCase();
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

    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      var tutorialJson = json.decode(response.body)['posts'];
      for (int i = 0; i < tutorialJson?.length; i++) {
        tutorials.add(Tutorial.fromJson(tutorialJson[i]));
      }
      return tutorials;
    } else {
      throw Exception(response.body);
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
