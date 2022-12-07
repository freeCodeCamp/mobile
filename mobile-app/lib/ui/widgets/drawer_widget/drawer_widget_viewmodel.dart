import 'package:flutter/material.dart';
import 'package:freecodecamp/service/authentication_service.dart';
import 'package:freecodecamp/app/app.locator.dart';
import 'package:freecodecamp/service/test_service.dart';
import 'package:freecodecamp/ui/views/auth/auth_view.dart';
import 'package:freecodecamp/ui/views/code_radio/code_radio_view.dart';
//import 'package:freecodecamp/ui/views/learn/learn_view.dart';
import 'package:freecodecamp/ui/views/forum/forum-categories/forum_category_view.dart';
import 'package:freecodecamp/ui/views/home/home_view.dart';
import 'package:freecodecamp/ui/views/learn/learn/learn_view.dart';
import 'package:freecodecamp/ui/views/podcast/podcast-list/podcast_list_view.dart';
import 'package:freecodecamp/ui/views/profile/profile_view.dart';
import 'package:freecodecamp/ui/views/settings/settings_view.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

class DrawerWidgtetViewModel extends BaseViewModel {
  final AuthenticationService auth = locator<AuthenticationService>();

  final SnackbarService snack = locator<SnackbarService>();

  bool _loggedIn = false;
  bool get loggedIn => _loggedIn;

  bool _devMode = false;
  bool get devmode => _devMode;

  void initState() async {
    _loggedIn = AuthenticationService.staticIsloggedIn;
    await devMode();
    notifyListeners();
    auth.isLoggedIn.listen((event) {
      _loggedIn = event;
      notifyListeners();
    });
  }

  static final _testService = locator<TestService>();

  devMode() async {
    if (await _testService.developmentMode()) {
      _devMode = true;
      notifyListeners();
    }
  }

  void snackbar() {
    snack.showSnackbar(
      title: 'Coming soon - use the web version',
      message: '',
    );
  }

  void loginSnack() {
    snack.showSnackbar(message: '', title: 'Login will soon be available!');
  }

  void routeComponent(view, context) async {
    switch (view) {
      case 'LOGIN':
        Navigator.pushReplacement(
            context,
            PageRouteBuilder(
                transitionDuration: Duration.zero,
                pageBuilder: (context, animation1, animation2) =>
                    const AuthView()));
        break;
      case 'LEARN':
        Navigator.pushReplacement(
            context,
            PageRouteBuilder(
                transitionDuration: Duration.zero,
                pageBuilder: (context, animation1, animation2) =>
                    const LearnView()));
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
      case 'PROFILE':
        Navigator.pushReplacement(
          context,
          PageRouteBuilder(
            transitionDuration: Duration.zero,
            pageBuilder: (context, animation1, animation2) =>
                const ProfileView(),
          ),
        );
        break;
    }
  }

  void handleAuth() {
    loggedIn ? auth.logout() : auth.login();
    notifyListeners();
  }
}
