import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mobile_app_new/routing/news.dart';
import 'package:mobile_app_new/ui/core/drawer/drawer.dart';

class NewsViewHandlerView extends StatelessWidget {
  const NewsViewHandlerView({super.key, required this.child});

  final Widget child;

  static const _titles = ['Bookmarks', 'Tutorials', 'Search'];
  static const _paths = [newsBookmarksPath, newsFeedPath, newsSearchPath];

  int _currentIndex(BuildContext context) {
    final location = GoRouterState.of(context).uri.path;
    for (int i = 0; i < _paths.length; i++) {
      if (location.startsWith(_paths[i])) return i;
    }
    return 1;
  }

  @override
  Widget build(BuildContext context) {
    final index = _currentIndex(context);

    return Scaffold(
      appBar: AppBar(title: Text(_titles[index])),
      drawer: const DrawerWidget(),
      body: child,
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: index,
        onTap: (i) => context.go(_paths[i]),
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.bookmark_outline_sharp),
            label: 'Bookmarks',
            tooltip: 'Bookmarks',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.article_sharp),
            label: 'Tutorials',
            tooltip: 'Tutorials',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.search_sharp),
            label: 'Search',
            tooltip: 'Search',
          ),
        ],
      ),
    );
  }
}
