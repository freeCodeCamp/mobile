import 'package:flutter/material.dart';
import 'package:freecodecamp/flash_cards.dart';
import 'package:freecodecamp/widgets/article/article-search.dart';

import 'widgets/article/article-feed.dart';
import 'widgets/article/article-bookmark-feed.dart';

import 'package:url_launcher/url_launcher.dart';

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
      drawer: Drawer(
        child: ListView(
          children: <Widget>[
            DrawerHeader(
              child: Text(''),
              decoration: BoxDecoration(
                image: DecorationImage(
                    image: AssetImage('assets/images/splash_screen.png')),
              ),
            ),
            ListTile(
                title: Text(
                  'Training',
                  style: TextStyle(color: Color(0xFF0a0a23)),
                ),
                onTap: () {
                  launch('https://www.freecodecamp.org/learn/');
                  Navigator.pop(context);
                }),
            ListTile(
                title: Text(
                  'Forum',
                  style: TextStyle(color: Color(0xFF0a0a23)),
                ),
                onTap: () {
                  launch('https://forum.freecodecamp.org/');
                  Navigator.pop(context);
                }),
            ListTile(
                title: Text(
                  'News',
                  style: TextStyle(color: Color(0xFF0a0a23)),
                ),
                onTap: () {
                  launch('https://www.freecodecamp.org/news/');
                  Navigator.pop(context);
                }),
            ListTile(
                title: Text(
                  'Radio',
                  style: TextStyle(color: Color(0xFF0a0a23)),
                ),
                onTap: () {
                  launch('https://coderadio.freecodecamp.org/');
                  Navigator.pop(context);
                }),
            ListTile(
              title: Text(
                'FAQ',
                style: TextStyle(color: Color(0xFF0a0a23)),
              ),
              onTap: () {
                launch('https://www.freecodecamp.org/news/about/');
                Navigator.pop(context);
              },
            ),
            ListTile(
              title: Text(
                'Donate',
                style: TextStyle(color: Color(0xFF0a0a23)),
              ),
              onTap: () {
                launch('https://www.freecodecamp.org/donate');
                Navigator.pop(context);
              },
            ),
          ],
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
}
