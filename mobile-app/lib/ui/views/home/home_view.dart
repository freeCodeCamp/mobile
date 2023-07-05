import 'package:flutter/material.dart';
import 'package:freecodecamp/service/navigation/quick_actions_service.dart';
import 'package:freecodecamp/ui/views/home/home_viewmodel.dart';
import 'package:freecodecamp/ui/views/news/news-bookmark/news_bookmark_feed_view.dart';
import 'package:freecodecamp/ui/views/news/news-feed/news_feed_view.dart';
import 'package:freecodecamp/ui/views/news/news-search/news_search_view.dart';
import 'package:freecodecamp/ui/widgets/drawer_widget/drawer_widget_view.dart';
import 'package:stacked/stacked.dart';
import 'package:upgrader/upgrader.dart';

class HomeView extends StatefulWidget {
  const HomeView({Key? key}) : super(key: key);

  @override
  HomeViewState createState() => HomeViewState();
}

class HomeViewState extends State<HomeView> {
  static const titles = <Widget>[
    Text('BOOKMARKED TUTORIALS'),
    Text('TUTORIALS'),
    Text('SEARCH TUTORIALS')
  ];

  static const views = <Widget>[
    NewsBookmarkFeedView(),
    NewsFeedView(),
    NewsSearchView()
  ];

  int index = 1;
  int _currentIndex = 1;

  void _onTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  void initState() {
    super.initState();
    QuickActionsService().init();
  }

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<HomeViewModel>.reactive(
      builder: (context, model, child) => Scaffold(
        appBar: AppBar(
          title: titles.elementAt(_currentIndex),
        ),
        drawer: const DrawerWidgetView(),
        body: UpgradeAlert(
            upgrader: Upgrader(
              dialogStyle: UpgradeDialogStyle.material,
              showIgnore: false,
              showLater: false,
            ),
            child: views.elementAt(_currentIndex)),
        bottomNavigationBar: BottomNavigationBar(
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(
                Icons.bookmark_outline_sharp,
              ),
              label: 'Bookmarks',
              tooltip: 'Bookmarks',
            ),
            BottomNavigationBarItem(
              icon: Icon(
                Icons.article_sharp,
              ),
              label: 'Tutorials',
              tooltip: 'Tutorials',
            ),
            BottomNavigationBarItem(
              icon: Icon(
                Icons.search_sharp,
              ),
              label: 'Search',
              tooltip: 'Search',
            )
          ],
          currentIndex: _currentIndex,
          onTap: _onTapped,
        ),
      ),
      viewModelBuilder: () => HomeViewModel(),
    );
  }
}
