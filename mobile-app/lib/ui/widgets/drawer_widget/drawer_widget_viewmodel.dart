import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:freecodecamp/core/navigation/app_snackbar.dart';
import 'package:freecodecamp/core/providers/service_providers.dart';
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

class DrawerWidgetState {
  const DrawerWidgetState({
    this.loggedIn = false,
    this.devMode = false,
  });

  final bool loggedIn;
  final bool devMode;

  DrawerWidgetState copyWith({bool? loggedIn, bool? devMode}) {
    return DrawerWidgetState(
      loggedIn: loggedIn ?? this.loggedIn,
      devMode: devMode ?? this.devMode,
    );
  }
}

class DrawerWidgetNotifier extends Notifier<DrawerWidgetState> {
  late AuthenticationService auth;
  late DeveloperService _developerService;

  final ScrollController scrollController = ScrollController();

  @override
  DrawerWidgetState build() {
    auth = ref.watch(authenticationServiceProvider);
    _developerService = ref.watch(developerServiceProvider);
    ref.onDispose(scrollController.dispose);
    return const DrawerWidgetState();
  }

  void initState() async {
    state = state.copyWith(
      loggedIn: AuthenticationService.staticIsloggedIn,
    );
    await _checkDevMode();
    auth.isLoggedIn.listen((event) {
      state = state.copyWith(loggedIn: event);
    });
  }

  Future<void> _checkDevMode() async {
    if (await _developerService.developmentMode()) {
      state = state.copyWith(devMode: true);
    }
  }

  void snackbar() {
    AppSnackbar.show(
      title: 'Coming soon - use the web version',
      message: '',
    );
  }

  void loginSnack() {
    AppSnackbar.show(message: '', title: 'Login will soon be available!');
  }

  void routeComponent(String view, BuildContext context) async {
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

final drawerWidgetProvider =
    NotifierProvider<DrawerWidgetNotifier, DrawerWidgetState>(
  DrawerWidgetNotifier.new,
);
