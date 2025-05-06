import 'package:flutter/material.dart';
import 'package:freecodecamp/extensions/i18n_extension.dart';
import 'package:freecodecamp/ui/views/news/news-bookmark/news_bookmark_feed_view.dart';
import 'package:freecodecamp/ui/views/news/news-feed/news_feed_view.dart';
import 'package:freecodecamp/ui/views/news/news-search/news_search_view.dart';
import 'package:freecodecamp/ui/views/news/news-view-handler/news_view_handler_viewmodel.dart';
import 'package:freecodecamp/ui/widgets/drawer_widget/drawer_widget_view.dart';
import 'package:stacked/stacked.dart';

class NewsViewHandlerView extends StatelessWidget {
  const NewsViewHandlerView({super.key});

  @override
  Widget build(BuildContext context) {
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

    return ViewModelBuilder<NewsViewHandlerViewModel>.reactive(
      builder: (context, model, child) => Scaffold(
        appBar: AppBar(
          title: titles.elementAt(model.index),
        ),
        drawer: const DrawerWidgetView(),
        body: views.elementAt(model.index),
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
          currentIndex: model.index,
          onTap: model.onTapped,
        ),
      ),
      viewModelBuilder: () => NewsViewHandlerViewModel(),
    );
  }
}
