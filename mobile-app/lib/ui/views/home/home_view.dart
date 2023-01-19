import 'package:flutter/material.dart';
import 'package:freecodecamp/ui/views/home/home_viewmodel.dart';
import 'package:freecodecamp/ui/views/news/news-bookmark/news_bookmark_feed_view.dart';
import 'package:freecodecamp/ui/views/news/news-feed/news_feed_view.dart';
import 'package:freecodecamp/ui/views/news/news-search/news_search_view.dart';
import 'package:freecodecamp/ui/widgets/drawer_widget/drawer_widget_view.dart';
import 'package:stacked/stacked.dart';
import 'package:upgrader/upgrader.dart';

class HomeView extends StatelessWidget {
  const HomeView({Key? key}) : super(key: key);

  static const titles = <Widget>[
    Text('BOOKMARKED TUTORIALS'),
    Text('TUTORIAL FEED'),
    Text('SEARCH TUTORIALS')
  ];

  static const views = <Widget>[
    NewsBookmarkFeedView(),
    NewsFeedView(),
    NewsSearchView()
  ];

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<HomeViewModel>.reactive(
      builder: (context, model, child) => Scaffold(
        appBar: AppBar(
          title: titles.elementAt(model.index),
        ),
        drawer: const DrawerWidgetView(),
        body: UpgradeAlert(
            upgrader: Upgrader(
              dialogStyle: UpgradeDialogStyle.material,
              showIgnore: false,
              showLater: false,
            ),
            child: views.elementAt(model.index)),
        bottomNavigationBar: BottomNavigationBar(
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(
                Icons.bookmark_outline_sharp,
              ),
              label: 'Bookmarks',
            ),
            BottomNavigationBarItem(
              icon: Icon(
                Icons.article_sharp,
              ),
              label: 'Tutorials',
            ),
            BottomNavigationBarItem(
              icon: Icon(
                Icons.search_sharp,
              ),
              label: 'Search',
            )
          ],
          currentIndex: model.index,
          onTap: model.onTapped,
        ),
      ),
      viewModelBuilder: () => HomeViewModel(),
    );
  }
}
