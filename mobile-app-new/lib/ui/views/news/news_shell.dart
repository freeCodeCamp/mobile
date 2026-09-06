import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mobile_app_new/routing/news.dart';
import 'package:mobile_app_new/ui/core/drawer/drawer.dart';

typedef _Tab = ({String title, String path, IconData icon});

class NewsShell extends StatelessWidget {
  const NewsShell({super.key, required this.child});

  final Widget child;

  static const List<_Tab> _tabs = [
    (
      title: 'Bookmarks',
      path: newsBookmarksPath,
      icon: Icons.bookmark_outline_sharp,
    ),
    (title: 'Tutorials', path: newsFeedPath, icon: Icons.article_sharp),
    (title: 'Search', path: newsSearchPath, icon: Icons.search_sharp),
  ];

  static const _feedIndex = 1;

  int _currentIndex(BuildContext context) {
    final location = GoRouterState.of(context).uri.path;
    final index = _tabs.indexWhere((tab) => tab.path == location);
    return index == -1 ? _feedIndex : index;
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
