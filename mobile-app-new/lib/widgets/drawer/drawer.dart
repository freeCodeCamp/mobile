import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/foundation.dart';
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
import 'package:mobile_app_new/widgets/section_divider.dart';

class DrawerWidget extends ConsumerWidget {
  const DrawerWidget({super.key});

  void _navigate(BuildContext context, VoidCallback route) {
    Scaffold.of(context).closeDrawer();
    route();
  }

  Future<void> _signOut(BuildContext context, WidgetRef ref) async {
    Scaffold.of(context).closeDrawer();
    try {
      await ref.read(authProvider.notifier).signOut();
    } catch (_) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Could not sign out. Please try again.'),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final auth = ref.watch(authProvider);
    final user = auth.value;
    final colors = Theme.of(context).colorScheme;
    final path = GoRouterState.of(context).uri.path;
    return Drawer(
      backgroundColor: colors.surface,
      child: SafeArea(
        child: ListView(
          padding: const EdgeInsets.symmetric(vertical: 16),
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: ListTile(
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 8,
                  vertical: 8,
                ),
                leading: CircleAvatar(
                  radius: 25,
                  backgroundColor: colors.surfaceContainer,
                  backgroundImage: user != null && user.picture.isNotEmpty
                      ? CachedNetworkImageProvider(user.picture)
                      : null,
                  child: user == null || user.picture.isEmpty
                      ? Icon(
                          Icons.person_outline,
                          color: colors.onSurfaceVariant,
                        )
                      : null,
                ),
                title: Text(switch (auth) {
                  _ when auth.isLoading => 'Loading your account…',
                  _ when auth.hasError => "Couldn't load your account",
                  _ =>
                    user == null
                        ? 'Learning as a guest'
                        : user.name.trim().isEmpty
                        ? user.username
                        : user.name,
                }, style: const TextStyle(fontWeight: FontWeight.w700)),
                subtitle: Text(
                  auth.hasError
                      ? 'Tap to retry'
                      : user == null
                      ? 'Sign in to save your progress'
                      : '@${user.username}',
                ),
                onTap: auth.isLoading
                    ? null
                    : auth.hasError
                    ? () => unawaited(ref.read(authProvider.notifier).refresh())
                    : () => _navigate(
                        context,
                        () => const ProfileRoute().go(context),
                      ),
              ),
            ),
            const SizedBox(height: 8),
            sectionDivider,
            const SizedBox(height: 8),
            DrawerTile(
              component: 'Courses',
              icon: Icons.school_outlined,
              selected: path.startsWith('/learn'),
              route: () => _navigate(
                context,
                () => const LearnLandingRoute().go(context),
              ),
            ),
            DrawerTile(
              component: 'Daily challenges',
              icon: Icons.extension_outlined,
              route: () => _navigate(
                context,
                () => const LearnDailyChallengeArchiveRoute().go(context),
              ),
            ),
            DrawerTile(
              component: 'Articles',
              icon: Icons.article_outlined,
              selected: path.startsWith('/news'),
              route: () =>
                  _navigate(context, () => const NewsFeedRoute().go(context)),
            ),
            DrawerTile(
              component: 'Listen',
              icon: Icons.headphones_outlined,
              selected: path.startsWith('/podcasts'),
              route: () => _navigate(
                context,
                () => const PodcastListRoute().go(context),
              ),
            ),
            if (defaultTargetPlatform != TargetPlatform.iOS)
              DrawerTile(
                component: 'Code Radio',
                icon: Icons.radio_outlined,
                route: () => _navigate(
                  context,
                  () => const CodeRadioRoute().go(context),
                ),
              ),
            const SizedBox(height: 8),
            sectionDivider,
            const SizedBox(height: 8),
            DrawerTile(
              component: 'Profile',
              icon: Icons.person_outline,
              selected: path == profilePath,
              route: () =>
                  _navigate(context, () => const ProfileRoute().go(context)),
            ),
            DrawerTile(
              component: 'Settings',
              icon: Icons.settings_outlined,
              selected: path == settingsPath,
              route: () =>
                  _navigate(context, () => const SettingsRoute().go(context)),
            ),
            DrawerTile(
              component: 'Donate',
              icon: Icons.favorite_border,
              textColor: colors.tertiary,
              route: () =>
                  openInCustomTab('https://www.freecodecamp.org/donate/'),
            ),
            DrawerTile(
              component: 'Report an issue',
              icon: Icons.error_outline,
              route: () => openInCustomTab(
                'https://github.com/freeCodeCamp/mobile/issues',
              ),
            ),
            if (!auth.isLoading && !auth.hasError)
              DrawerTile(
                component: auth.isLoggedIn ? 'Log out' : 'Sign in',
                icon: auth.isLoggedIn ? Icons.logout : Icons.login,
                textColor: auth.isLoggedIn
                    ? colors.error
                    : FccDesignColors.of(context).accentText,
                route: () => auth.isLoggedIn
                    ? _signOut(context, ref)
                    : _navigate(
                        context,
                        () => const LoginRoute().push<void>(context),
                      ),
              ),
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 20, 24, 8),
              child: Text(
                'freeCodeCamp is a donor-supported tax-exempt 501(c)(3) nonprofit organization.',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
