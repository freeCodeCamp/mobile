import 'package:flutter/material.dart';
import 'package:freecodecamp/widgets/article/article-search.dart';

import 'widgets/article/article-feed.dart';
import 'widgets/article/article-bookmark-feed.dart';
import 'widgets/forum/forum-category-feed.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'freeCodeCamp',
      home: Home(),
    );
  }
}

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int _index = 1;
  @override
  void initState() {
    super.initState();
  }

  void _onTapped(int index) {
    setState(() {
      _index = index;
    });
  }

  static List<Widget> views = <Widget>[
    BookmarkViewTemplate(),
    ArticleApp(),
    ArticleSearch()
  ];

  static List<Widget> titles = <Widget>[
    Text('BOOKMARKED ARTICLES'),
    Text('NEWSFEED'),
    Text('SEARCH ARTICLES')
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF0a0a23),
        title: titles.elementAt(_index),
        centerTitle: true,
      ),
      drawer: Container(
        width: MediaQuery.of(context).size.width,
        child: Drawer(
          child: SingleChildScrollView(
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(25),
                          child: Text(
                            'MENU',
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF0a0a23),
                                fontSize: 24),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                Row(
                  children: [
                    Expanded(
                        child: navButton(
                            'NEWSFEED',
                            'https://www.google.com/',
                            Icon(
                              Icons.article,
                              size: 70,
                            ),
                            false)),
                    Expanded(
                        child: navButton(
                            'FORUM',
                            'https://forum.freecodecamp.org/',
                            Icon(
                              Icons.forum_outlined,
                              size: 70,
                            ),
                            true)),
                  ],
                ),
                Row(
                  children: [
                    Expanded(
                        child: navButton(
                            'PODCAST',
                            'https://www.google.com/',
                            Icon(
                              Icons.podcasts_outlined,
                              size: 70,
                            ),
                            true)),
                    Expanded(
                        child: navButton(
                            'RADIO',
                            'https://coderadio.freecodecamp.org/',
                            Icon(
                              Icons.radio,
                              size: 70,
                            ),
                            true)),
                  ],
                ),
                Row(
                  children: [
                    Expanded(
                        child: navButton(
                            'DONATE',
                            'https://www.freecodecamp.org/donate/',
                            Icon(
                              Icons.favorite,
                              size: 70,
                            ),
                            true)),
                    Expanded(
                      child: navButton(
                          'SETTINGS',
                          'https://www.google.com/',
                          Icon(
                            Icons.settings,
                            size: 70,
                          ),
                          true),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
      body: views.elementAt(_index),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Color(0xFF0a0a23),
        unselectedItemColor: Colors.white,
        selectedItemColor: Color.fromRGBO(0x99, 0xc9, 0xff, 1),
        items: <BottomNavigationBarItem>[
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
        currentIndex: _index,
        onTap: _onTapped,
      ),
    );
  }

  InkWell navButton(String text, String url, Icon icon, bool isWebComponent) =>
      InkWell(
        onTap: () {
          if (text == 'FORUM') {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => ForumCategoryView()));
          }
          // if (isWebComponent) {
          //   Navigator.push(context,
          //       MaterialPageRoute(builder: (context) => Browserview(url: url)));
          // } else {
          //   Navigator.pop(context);
          //   setState(() {
          //     _index = 1;
          //   });
          // }
        },
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Container(
            width: 160,
            decoration: BoxDecoration(
                color: Color.fromRGBO(0xD0, 0xD0, 0xD5, 1),
                border: Border.all(color: Colors.black, width: 3)),
            child: Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: icon,
                      ),
                    )
                  ],
                ),
                Row(
                  children: [
                    Expanded(
                        child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        text,
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.w600),
                        textAlign: TextAlign.center,
                      ),
                    ))
                  ],
                )
              ],
            ),
          ),
        ),
      );
}
