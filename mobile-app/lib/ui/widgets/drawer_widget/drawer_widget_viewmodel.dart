import 'package:flutter/material.dart';
import 'package:freecodecamp/app/app.locator.dart';
import 'package:freecodecamp/service/authentication/authentication_service.dart';
import 'package:freecodecamp/service/developer_service.dart';
import 'package:freecodecamp/ui/views/code_radio/code_radio_view.dart';
import 'package:freecodecamp/ui/views/learn/daily_challenge/daily_challenge_view.dart';
import 'package:freecodecamp/ui/views/learn/landing/landing_view.dart';
import 'package:freecodecamp/ui/views/login/native_login_view.dart';
import 'package:freecodecamp/ui/views/news/news-view-handler/news_view_handler_view.dart';
import 'package:freecodecamp/ui/views/podcast/podcast-list/podcast_list_view.dart';
import 'package:freecodecamp/ui/views/profile/profile_view.dart';
import 'package:freecodecamp/ui/views/settings/settings_view.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

class DrawerWidgetViewModel extends BaseViewModel {
  final AuthenticationService auth = locator<AuthenticationService>();

  final SnackbarService snack = locator<SnackbarService>();

  bool _loggedIn = false;
  bool get loggedIn => _loggedIn;

  bool _devMode = false;
  bool get devmode => _devMode;

  final ScrollController _scrollController = ScrollController();
  ScrollController get scrollController => _scrollController;

  void initState() async {
    _loggedIn = AuthenticationService.staticIsloggedIn;
    await devMode();
    notifyListeners();
    auth.isLoggedIn.listen((event) {
      _loggedIn = event;
      notifyListeners();
    });
  }

  static final _developerService = locator<DeveloperService>();

  devMode() async {
    if (await _developerService.developmentMode()) {
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
      case 'DAILY_CHALLENGES':
        Navigator.pushReplacement(
          context,
          PageRouteBuilder(
            transitionDuration: Duration.zero,
            pageBuilder: (context, animation1, animation2) =>
                const DailyChallengeView(),
            settings: const RouteSettings(
              name: '/daily-challenge',
            ),
          ),
        );
        break;
      case 'LEARN':
        Navigator.pushReplacement(
          context,
          PageRouteBuilder(
            transitionDuration: Duration.zero,
            pageBuilder: (context, animation1, animation2) =>
                const LearnLandingView(),
            settings: const RouteSettings(
              name: '/learn',
            ),
          ),
        );
        break;
      case 'NEWS':
        Navigator.pushReplacement(
          context,
          PageRouteBuilder(
            transitionDuration: Duration.zero,
            pageBuilder: (context, animation1, animation2) =>
                const NewsViewHandlerView(),
            settings: const RouteSettings(
              name: '/news',
            ),
          ),
        );
        break;
      case 'PODCAST':
        Navigator.pushReplacement(
          context,
          PageRouteBuilder(
            transitionDuration: Duration.zero,
            pageBuilder: (context, animation1, animation2) =>
                const PodcastListView(),
            settings: const RouteSettings(
              name: '/podcasts-list',
            ),
          ),
        );
        break;
      case 'CODERADIO':
        Navigator.pushReplacement(
          context,
          PageRouteBuilder(
            transitionDuration: Duration.zero,
            pageBuilder: (context, animation1, animatiom2) =>
                const CodeRadioView(),
            settings: const RouteSettings(
              name: '/code-radio',
            ),
          ),
        );
        break;
      case 'PROFILE':
        Navigator.pushReplacement(
          context,
          PageRouteBuilder(
            transitionDuration: Duration.zero,
            pageBuilder: (context, animation1, animation2) =>
                const ProfileView(),
            settings: const RouteSettings(
              name: '/profile',
            ),
          ),
        );
        break;
      case 'LOGIN':
        Navigator.push(
          context,
          PageRouteBuilder(
            transitionDuration: Duration.zero,
            pageBuilder: (context, animation1, animation2) =>
                const NativeLoginView(),
            settings: const RouteSettings(
              name: '/login',
            ),
          ),
        );
        break;
      case 'SETTINGS':
        Navigator.push(
          context,
          PageRouteBuilder(
            transitionDuration: Duration.zero,
            pageBuilder: (context, animation1, animation2) =>
                const SettingsView(),
            settings: const RouteSettings(
              name: '/settings',
            ),
          ),
        );
        break;
    }
  }
}
