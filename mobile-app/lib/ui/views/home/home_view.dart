import 'package:flutter/material.dart';
import 'package:freecodecamp/ui/views/news/news-bookmark/news_bookmark_feed_view.dart';
import 'package:freecodecamp/ui/views/news/news-feed/news_feed_view.dart';
import 'package:freecodecamp/ui/views/news/news-search/news_search_view.dart';
import 'package:stacked/stacked.dart';

import '../../widgets/drawer_widget/drawer_widget_view.dart';
import 'home_viemmodel.dart';

class HomeView extends StatelessWidget {
  const HomeView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    List<dynamic> views = <dynamic>[
      const NewsBookmarkFeedView(),
      const NewsFeedView(),
      const NewsSearchView()
      //const ArticleSearch()
    ];
    List<Widget> titles = <Widget>[
      const Text('BOOKMARKED ARTICLES'),
      const Text('NEWSFEED'),
      const Text('SEARCH ARTICLES')
    ];
    return ViewModelBuilder<HomeViewModel>.reactive(
      builder: (context, viewModel, child) => Scaffold(
        appBar: AppBar(
          backgroundColor: const Color(0xFF0a0a23),
          title: titles.elementAt(viewModel.index),
          centerTitle: true,
        ),
        drawer:  const DrawerWidgetView(),
        body: views.elementAt(viewModel.index),
        bottomNavigationBar: BottomNavigationBar(
          backgroundColor: const Color(0xFF0a0a23),
          unselectedItemColor: Colors.white,
          selectedItemColor: const Color.fromRGBO(0x99, 0xc9, 0xff, 1),
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
                icon: Icon(
                  Icons.bookmark_outline_sharp,
                  color: Colors.white,
                ),
                label: 'Bookmarks'),
            BottomNavigationBarItem(
                icon: Icon(
                  Icons.article_sharp,
                  color: Colors.white,
                ),
                label: 'Articles'),
            BottomNavigationBarItem(
                icon: Icon(
                  Icons.search_sharp,
                  color: Colors.white,
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
