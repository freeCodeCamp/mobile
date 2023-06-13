import 'dart:async';
import 'dart:convert';
import 'package:freecodecamp/app/app.locator.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:freecodecamp/app/app.router.dart';
import 'package:freecodecamp/models/news/tutorial_model.dart';
import 'package:freecodecamp/service/developer_service.dart';
import 'package:freecodecamp/ui/views/news/html_handler/html_handler.dart';
import 'package:freecodecamp/ui/views/news/news-tutorial/news_tutorial_view.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:stacked/stacked.dart';
import 'package:http/http.dart' as http;
import 'package:stacked_services/stacked_services.dart';

class NewsTutorialViewModel extends BaseViewModel {
  late Future<Tutorial> _tutorialFuture;
  static final NavigationService _navigationService =
      locator<NavigationService>();

  final _developerService = locator<DeveloperService>();

  Future<Tutorial>? get tutorialFuture => _tutorialFuture;

  final ScrollController _scrollController = ScrollController();
  ScrollController get scrollController => _scrollController;

  final ScrollController _bottomButtonController = ScrollController();
  ScrollController get bottomButtonController => _bottomButtonController;

  Future<Tutorial> readFromFiles() async {
    String json = await rootBundle.loadString(
      'assets/test_data/news_post.json',
    );

    var decodedJson = jsonDecode(json);

    return Tutorial.toPostFromJson(decodedJson);
  }

  Future<Tutorial> initState(id) async {
    handleBottomButtonAnimation();

    if (await _developerService.developmentMode()) {
      return readFromFiles();
    } else {
      return fetchTutorial(id);
    }
  }

  Future<void> handleBottomButtonAnimation() async {
    _scrollController.addListener(() async {
      SharedPreferences prefs = await SharedPreferences.getInstance();

      if (prefs.getDouble('position') == null) {
        prefs.setDouble('position', _scrollController.offset);
      }

      double oldScrollPos = prefs.getDouble('position') as double;

      if (_scrollController.offset <= oldScrollPos) {
        _bottomButtonController.animateTo(
          _bottomButtonController.position.maxScrollExtent - 50,
          duration: const Duration(milliseconds: 1000),
          curve: Curves.easeInOut,
        );
      } else {
        _bottomButtonController.animateTo(
          0,
          duration: const Duration(milliseconds: 1000),
          curve: Curves.easeInOut,
        );
      }
      Timer(const Duration(seconds: 2), () {
        if (_scrollController.hasClients) {
          prefs.setDouble('position', _scrollController.offset);
        }
      });
    });
  }

  Future<void> initBottomButtonAnimation() async {
    // if the user has not scrolled yet the bottom buttons will not appear
    // this means we need to animate it manually.
    Future.delayed(
      const Duration(seconds: 1),
      () => {
        if (_bottomButtonController.hasClients)
          {
            _bottomButtonController.animateTo(
              _bottomButtonController.position.maxScrollExtent - 50,
              duration: const Duration(milliseconds: 1000),
              curve: Curves.easeInOut,
            )
          }
      },
    );
  }

  static void goToAuthorProfile(String slug) {
    _navigationService.navigateTo(
      Routes.newsAuthorView,
      arguments: NewsAuthorViewArguments(authorSlug: slug),
    );
  }

  List<Widget> initLazyLoading(html, context, tutorial) {
    HTMLParser parser = HTMLParser(context: context);

    List<Widget> elements = parser.parse(html);

    if (tutorial is Tutorial) {
      // insert before the first element
      elements.insert(
        0,
        Stack(
          children: [
            NewsTutorialHeader(tutorial: tutorial),
            AppBar(
              backgroundColor: Colors.transparent,
              shadowColor: Colors.transparent,
              leading: Tooltip(
                message: 'Back',
                child: InkWell(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: Container(
                    margin: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(50),
                      color: Colors.black.withOpacity(0.5),
                    ),
                    child: const Icon(Icons.arrow_back),
                  ),
                ),
              ),
            )
          ],
        ),
      );

      // insert after the last element
      elements.add(const SizedBox(
        height: 100,
      ));

      initBottomButtonAnimation();
    }

    return elements;
  }

  Future<void> removeScrollPosition() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    _scrollController.dispose();
    _bottomButtonController.dispose();

    prefs.remove('position');
  }

  Future<Tutorial> fetchTutorial(tutorialId) async {
    await dotenv.load(fileName: '.env');

    final response = await http.get(
      Uri.parse(
          'https://www.freecodecamp.org/news/ghost/api/v3/content/posts/$tutorialId/?key=${dotenv.env['NEWSKEY']}&include=tags,authors'),
    );
    if (response.statusCode == 200) {
      return Tutorial.toPostFromJson(jsonDecode(
        response.body,
      ));
    } else {
      throw Exception(response.body);
    }
  }
}
