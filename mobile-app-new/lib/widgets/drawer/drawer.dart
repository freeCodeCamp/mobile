import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:mobile_app_new/fcc_theme.dart';
import 'package:mobile_app_new/routing/auth.dart';
import 'package:mobile_app_new/routing/code_radio.dart';
import 'package:mobile_app_new/routing/learn.dart';
import 'package:mobile_app_new/routing/news.dart';
import 'package:mobile_app_new/routing/podcasts.dart';
import 'package:mobile_app_new/routing/settings.dart';
import 'package:mobile_app_new/services/auth_service.dart';
import 'package:mobile_app_new/utils/custom_tab.dart';
import 'package:mobile_app_new/widgets/drawer/drawer_tile.dart';
import 'package:mobile_app_new/widgets/drawer/scroll_shadow.dart';
import 'package:mobile_app_new/widgets/section_divider.dart';

class DrawerWidget extends ConsumerWidget {
  const DrawerWidget({super.key});

  void _login(BuildContext context) {
    Scaffold.of(context).closeDrawer();
    const LoginRoute().push(context);
  }

  // NOTE: Only Profile needs a signed-in user, so only it is left behind.
  void _signOut(BuildContext context, WidgetRef ref) {
    if (GoRouterState.of(context).uri.path == profilePath) {
      const LearnLandingRoute().go(context);
    }
    unawaited(ref.read(authProvider.notifier).signOut());
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final auth = ref.watch(authProvider);

    return Drawer(
      backgroundColor: FccColors.gray80,
      child: Column(
        children: [
          Expanded(
            child: SafeArea(
              bottom: false,
              child: ScrollShadow(
                child: ListView(
                  children: [
                    ListTile(
                      contentPadding: const EdgeInsets.all(16),
                      leading: Image.asset(
                        'assets/images/placeholder-profile-img.png',
                        width: 75,
                        height: 75,
                      ),
                      title: Text(switch (auth.value) {
                        _ when auth.isLoading => 'Loading your account…',
                        _ when auth.hasError => "Couldn't load your account",
                        null => 'Anonymous User',
                        final user when user.name.isEmpty => user.username,
                        final user => user.name,
                      }),
                      subtitle: auth.isLoading
                          ? null
                          : Text(switch (auth) {
                              _ when auth.hasError => 'Tap to retry',
                              _ when auth.isLoggedIn => 'Our coolest Camper',
                              _ => 'Sign in to save your progress',
                            }),
                      onTap: switch (auth) {
                        _ when auth.isLoading => null,
                        _ when auth.hasError => () => unawaited(
                          ref.read(authProvider.notifier).refresh(),
                        ),
                        _ when auth.isLoggedIn => () => const ProfileRoute().go(
                          context,
                        ),
                        _ => () => _login(context),
                      },
                    ),
                    sectionDivider,
                    DrawerTile(
                      component: 'Daily Challenges',
                      icon: Icons.extension,
                      route: () =>
                          const LearnDailyChallengeArchiveRoute().go(context),
                    ),
                    DrawerTile(
                      component: 'Learn',
                      route: () => const LearnLandingRoute().go(context),
                    ),
                    DrawerTile(
                      component: 'Tutorials',
                      icon: Icons.forum_outlined,
                      route: () => const NewsFeedRoute().go(context),
                    ),
                    DrawerTile(
                      component: 'Podcast',
                      icon: Icons.podcasts,
                      route: () => const PodcastListRoute().go(context),
                    ),
                    if (!Platform.isIOS)
                      DrawerTile(
                        component: 'Code Radio',
                        icon: Icons.radio,
                        route: () => const CodeRadioRoute().go(context),
                      ),
                    sectionDivider,
                    DrawerTile(
                      component: 'Donate',
                      icon: Icons.favorite,
                      route: () => openInCustomTab(
                        'https://www.freecodecamp.org/donate/',
                      ),
                    ),
                    DrawerTile(
                      component: 'Settings',
                      icon: Icons.settings,
                      route: () => const SettingsRoute().go(context),
                    ),
                    sectionDivider,
                    DrawerTile(
                      component: 'Report an issue',
                      icon: Icons.bug_report,
                      route: () => openInCustomTab(
                        'https://github.com/freeCodeCamp/mobile',
                      ),
                    ),
                    if (!auth.isLoading && !auth.hasError)
                      DrawerTile(
                        component: auth.isLoggedIn ? 'Log Out' : 'Log In',
                        icon: auth.isLoggedIn ? Icons.logout : Icons.login,
                        textColor: auth.isLoggedIn
                            ? FccColors.red80
                            : Colors.white,
                        route: () => auth.isLoggedIn
                            ? _signOut(context, ref)
                            : _login(context),
                      ),
                  ],
                ),
              ),
            ),
          ),
          const SafeArea(
            minimum: EdgeInsets.only(bottom: 16),
            child: Text(
              'freeCodeCamp is a donor-supported tax-exempt 501(c)(3) nonprofit organization',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 10, color: Colors.white70),
            ),
          ),
        ],
      ),
    );
  }
}
