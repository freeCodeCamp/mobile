import 'package:flutter/material.dart';
import 'package:freecodecamp/ui/views/news/news-bookmark/news_bookmark_feed_view.dart';
import 'package:freecodecamp/ui/views/news/news-feed/news_feed_view.dart';
import 'package:freecodecamp/ui/views/news/news-search/news_search_view.dart';
import 'package:stacked/stacked.dart';

import '../../widgets/drawer_widget/drawer_widget_view.dart';
import 'home_viemmodel.dart';

class HomeView extends StatelessWidget {
  const HomeView({Key? key}) : super(key: key);

  static const titles = <Widget>[
    Text('BOOKMARKED ARTICLES'),
    Text('NEWSFEED'),
    Text('SEARCH ARTICLES')
  ];

  static const views = <Widget>[
    NewsBookmarkFeedView(),
    NewsFeedView(),
    NewsSearchView()
    //const ArticleSearch()
  ];

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<HomeViewModel>.reactive(
      builder: (context, viewModel, child) => Scaffold(
        appBar: AppBar(
          title: titles.elementAt(viewModel.index),
        ),

        drawer:  const DrawerWidgetView(),
        body: IndexedStack(
          index: viewModel.index,
          children: views,
        ),
        bottomNavigationBar: BottomNavigationBar(
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
                icon: Icon(
                  Icons.bookmark_outline_sharp,
                ),
                label: 'Bookmarks'),
            BottomNavigationBarItem(
                icon: Icon(
                  Icons.article_sharp,
                ),
                label: 'Articles'),
            BottomNavigationBarItem(
                icon: Icon(
                  Icons.search_sharp,
                ),
                label: 'Search')
          ],
          currentIndex: viewModel.index,
          onTap: viewModel.onTapped,
        ),
      ),
      viewModelBuilder: () => HomeViewModel(),
    );
  }
}
