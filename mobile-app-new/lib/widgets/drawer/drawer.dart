import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:mobile_app_new/routing/code_radio.dart';
import 'package:mobile_app_new/routing/learn.dart';
import 'package:mobile_app_new/routing/news.dart';
import 'package:mobile_app_new/routing/podcasts.dart';
import 'package:mobile_app_new/widgets/drawer/drawer_tile.dart';

class DrawerWidget extends StatelessWidget {
  const DrawerWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Theme.of(context).colorScheme.surface,
      child: ListView(
        children: [
          DrawerTile(
            component: 'Home',
            icon: Icons.home,
            route: () => LearnLandingRoute().go(context),
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
          if (defaultTargetPlatform != TargetPlatform.iOS)
            DrawerTile(
              component: 'Code Radio',
              icon: Icons.radio,
              route: () => const CodeRadioRoute().go(context),
            ),
        ],
      ),
    );
  }
}
