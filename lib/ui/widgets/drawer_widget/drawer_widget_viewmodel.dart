import 'package:flutter/material.dart';
import 'package:freecodecamp/app/app.locator.dart';
import 'package:freecodecamp/app/app.router.dart';
import 'package:freecodecamp/ui/views/forum/forum-categories/forum_category_view.dart';
import 'package:freecodecamp/ui/views/home/home_view.dart';
import 'package:freecodecamp/ui/views/podcast/podcast_view.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

class DrawerWidgtetViewModel extends BaseViewModel {
  final NavigationService _navigationService = locator<NavigationService>();
  void goToBrowser(String url) {
    _navigationService.navigateTo(
      Routes.browserView,
      arguments: BrowserViewArguments(url: url),
    );
  }

  void navNonWebComponent(view, context) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    switch (view) {
      case 'NEWS':
        Navigator.pushReplacement(
            context,
            PageRouteBuilder(
                transitionDuration: Duration.zero,
                pageBuilder: (context, animation1, animation2) =>
                    const HomeView()));
        break;
      case 'FORUM':
        Navigator.pushReplacement(
            context,
            PageRouteBuilder(
                transitionDuration: Duration.zero,
                pageBuilder: (context, animation1, animation2) =>
                    ForumCategoryView()));
        break;
      case 'PODCAST':
        Navigator.pushReplacement(
            context,
            PageRouteBuilder(
                transitionDuration: Duration.zero,
                pageBuilder: (context, animation1, animation2) =>
                    const PodcastView()));
        break;
    }
  }
}
