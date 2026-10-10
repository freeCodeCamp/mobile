import 'package:flutter/material.dart';
import 'package:mobile_app_new/routing/learn.dart';
import 'package:mobile_app_new/routing/news.dart';
import 'package:mobile_app_new/routing/podcasts.dart';

// Account and donation destinations will join this bar when those sections
// are migrated. Every destination shown here has a working route.
enum AppDestination { learn, tutorials, listen }

class AppBottomNavigation extends StatelessWidget {
  const AppBottomNavigation({super.key, required this.selected});

  final AppDestination selected;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        border: Border(
          top: BorderSide(color: Theme.of(context).colorScheme.outlineVariant),
        ),
      ),
      child: NavigationBar(
        selectedIndex: selected.index,
        height: 72,
        onDestinationSelected: (index) {
          switch (AppDestination.values[index]) {
            case AppDestination.learn:
              const LearnLandingRoute().go(context);
            case AppDestination.tutorials:
              const NewsFeedRoute().go(context);
            case AppDestination.listen:
              const PodcastListRoute().go(context);
          }
        },
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.school_outlined),
            label: 'Learn',
          ),
          NavigationDestination(
            icon: Icon(Icons.article_outlined),
            label: 'Tutorials',
          ),
          NavigationDestination(
            icon: Icon(Icons.headphones_outlined),
            label: 'Listen',
          ),
        ],
      ),
    );
  }
}
