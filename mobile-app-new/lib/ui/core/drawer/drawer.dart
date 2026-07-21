import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mobile_app_new/fcc_theme.dart';
import 'package:mobile_app_new/router/news.dart';
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
            route: () => context.go('/'),
          ),
          DrawerTile(
            component: 'Tutorials',
            icon: Icons.forum_outlined,
            route: () => context.go(newsFeedPath),
          ),
        ],
      ),
    );
  }
}
