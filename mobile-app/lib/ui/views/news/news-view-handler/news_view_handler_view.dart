import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:freecodecamp/extensions/i18n_extension.dart';
import 'package:freecodecamp/ui/views/news/news-bookmark/news_bookmark_feed_view.dart';
import 'package:freecodecamp/ui/views/news/news-feed/news_feed_view.dart';
import 'package:freecodecamp/ui/views/news/news-search/news_search_view.dart';
import 'package:freecodecamp/ui/views/news/news-view-handler/news_view_handler_viewmodel.dart';
import 'package:freecodecamp/ui/widgets/drawer_widget/drawer_widget_view.dart';

class NewsViewHandlerView extends ConsumerWidget {
  const NewsViewHandlerView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final index = ref.watch(newsViewHandlerProvider);
    final notifier = ref.read(newsViewHandlerProvider.notifier);

    var titles = <Widget>[
      Text(context.t.tutorial_bookmarks_title),
      Text(context.t.tutorials),
      Text(context.t.tutorial_search_title)
    ];

    const views = <Widget>[
      NewsBookmarkFeedView(),
      NewsFeedView(),
      NewsSearchView()
    ];

    return Scaffold(
      appBar: AppBar(
        title: titles.elementAt(index),
      ),
      drawer: const DrawerWidgetView(),
      body: views.elementAt(index),
      bottomNavigationBar: BottomNavigationBar(
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: const Icon(
              Icons.bookmark_outline_sharp,
            ),
            label: context.t.tutorial_nav_bookmarks,
            tooltip: context.t.tutorial_nav_bookmarks,
          ),
          BottomNavigationBarItem(
            icon: const Icon(
              Icons.article_sharp,
            ),
            label: context.t.tutorial_nav_tutorials,
            tooltip: context.t.tutorial_nav_tutorials,
          ),
          BottomNavigationBarItem(
            icon: const Icon(
              Icons.search_sharp,
            ),
            label: context.t.tutorial_nav_search,
            tooltip: context.t.tutorial_nav_search,
          )
        ],
        currentIndex: index,
        onTap: notifier.onTapped,
      ),
    );
  }
}
