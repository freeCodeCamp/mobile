import 'package:flutter/material.dart';
import 'package:freecodecamp/app/app.locator.dart';
import 'package:freecodecamp/ui/views/code_radio/code_radio_view.dart';
//import 'package:freecodecamp/ui/views/learn/learn_view.dart';
import 'package:freecodecamp/ui/views/forum/forum-categories/forum_category_view.dart';
import 'package:freecodecamp/ui/views/home/home_view.dart';
import 'package:freecodecamp/ui/views/podcast/podcast-list/podcast_list_view.dart';
import 'package:freecodecamp/ui/views/settings/settings_view.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

class DrawerWidgtetViewModel extends BaseViewModel {
  // a temp variable for showing the forum button when dev mode is set to false
  // this is because the forum has two different urls, one for prod
  // and one for testing purposes. When the development value is set to false
  // the normal fcc forum is not accessible
  final bool _showForum = false;

  bool get showForum => _showForum;

  final SnackbarService snack = locator<SnackbarService>();

  void routeComponent(view, context) async {
    switch (view) {
      case 'LEARN':
        snack.showSnackbar(
          title: 'Coming soon - use the web version',
          message: '',
        );
        // Navigator.pushReplacement(
        //     context,
        //     PageRouteBuilder(
        //         transitionDuration: Duration.zero,
        //         pageBuilder: (context, animation1, animation2) =>
        //             const LearnView()));
        break;
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
                    const PodcastListView()));
        break;
      case 'SETTINGS':
        Navigator.pushReplacement(
            context,
            PageRouteBuilder(
                transitionDuration: Duration.zero,
                pageBuilder: (context, animation1, animatiom2) =>
                    const SettingsView()));
        break;
      case 'CODERADIO':
        Navigator.pushReplacement(
            context,
            PageRouteBuilder(
                transitionDuration: Duration.zero,
                pageBuilder: (context, animation1, animatiom2) =>
                    const CodeRadioView()));
        break;
    }
  }
}
