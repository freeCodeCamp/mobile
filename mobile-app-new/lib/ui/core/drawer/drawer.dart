import 'package:flutter/material.dart';
import 'package:mobile_app_new/fcc_theme.dart';
import 'package:mobile_app_new/routing/learn.dart';
import 'package:mobile_app_new/routing/news.dart';
import 'package:mobile_app_new/ui/core/drawer/drawer_tile.dart';

class DrawerWidget extends StatelessWidget {
  const DrawerWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: FccColors.gray80,
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
        ],
      ),
    );
  }
}
