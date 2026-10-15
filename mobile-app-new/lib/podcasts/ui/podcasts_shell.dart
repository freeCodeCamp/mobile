import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mobile_app_new/routing/podcasts.dart';
import 'package:mobile_app_new/widgets/drawer/drawer.dart';

typedef _Tab = ({String title, String path, IconData icon});

class PodcastsShell extends StatelessWidget {
  const PodcastsShell({super.key, required this.child});

  final Widget child;

  static const List<_Tab> _tabs = [
    (title: 'Podcasts', path: podcastListPath, icon: Icons.grid_view_rounded),
    (
      title: 'Downloads',
      path: podcastDownloadsPath,
      icon: Icons.arrow_circle_down_sharp,
    ),
  ];

  static const _listIndex = 0;

  int _currentIndex(BuildContext context) {
    final location = GoRouterState.of(context).uri.path;
    final index = _tabs.indexWhere((tab) => tab.path == location);
    return index == -1 ? _listIndex : index;
  }

  @override
  Widget build(BuildContext context) {
    final index = _currentIndex(context);

    return Scaffold(
      appBar: AppBar(title: Text(_tabs[index].title)),
      drawer: const DrawerWidget(),
      body: child,
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: index,
        onTap: (i) => context.go(_tabs[i].path),
        items: [
          for (final tab in _tabs)
            BottomNavigationBarItem(
              icon: Icon(tab.icon),
              label: tab.title,
              tooltip: tab.title,
            ),
        ],
      ),
    );
  }
}
