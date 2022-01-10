import 'package:flutter/material.dart';
import 'package:freecodecamp/ui/views/news/news-bookmark/news_bookmark_feed_view.dart';
import 'package:freecodecamp/ui/views/news/news-feed/news_feed_view.dart';
import 'package:freecodecamp/ui/views/news/news-search/news_search_view.dart';
import 'package:freecodecamp/ui/widgets/drawer_widget/drawer_widget_view.dart';
import 'package:stacked/stacked.dart';

import 'home_viemmodel.dart';

class HomeView extends StatelessWidget {
  const HomeView({Key? key}) : super(key: key);

  static const titles = <Widget>[
    Text('BOOKMARKED ARTICLES', style: TextStyle(fontSize: 15)),
    Text('NEWSFEED', style: TextStyle(fontSize: 15)),
    Text('SEARCH', style: TextStyle(fontSize: 15))
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
          elevation: 0,
          title: titles.elementAt(viewModel.index),
        ),
        drawer: SizedBox(
          width: MediaQuery.of(context).size.width,
          child: const DrawerWidgetView(),
        ),
        body: IndexedStack(
          index: viewModel.index,
          children: views,
        ),
        bottomNavigationBar: BottomNavigationBar(
          selectedLabelStyle:
              const TextStyle(fontSize: 11, fontWeight: FontWeight.w600),
          unselectedLabelStyle:
              const TextStyle(fontSize: 11, fontWeight: FontWeight.w600),
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
                icon: Icon(
                  Icons.bookmark_outline_sharp,
                ),
                label: 'Bookmarks'),
            BottomNavigationBarItem(
                icon: Icon(
                  Icons.article_outlined,
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
