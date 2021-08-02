import 'package:flutter/material.dart';
import 'package:freecodecamp/flash_cards.dart';
import 'package:webview_flutter/webview_flutter.dart';

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
  WebViewController? controller;
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF0a0a23),
        actions: [
          Row(
            children: <Widget>[
              IconButton(
                icon: const Icon(Icons.arrow_back_ios),
                onPressed: () async {
                  if (await controller!.canGoBack()) {
                    await controller!.goBack();
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text("No back history item")));
                    return;
                  }
                },
              ),
              IconButton(
                icon: const Icon(Icons.arrow_forward_ios),
                onPressed: () async {
                  if (await controller!.canGoForward()) {
                    await controller!.goForward();
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text("No forward history item")));
                    return;
                  }
                },
              ),
              IconButton(
                icon: const Icon(Icons.replay),
                onPressed: () {
                  controller!.reload();
                },
              ),
            ],
          ),
        ],
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
                  controller!.loadUrl('https://www.freecodecamp.org/learn/');
                  Navigator.pop(context);
                }),
            ListTile(
                title: Text(
                  'Forum',
                  style: TextStyle(color: Color(0xFF0a0a23)),
                ),
                onTap: () {
                  controller!.loadUrl('https://forum.freecodecamp.org/');
                  Navigator.pop(context);
                }),
            ListTile(
                title: Text(
                  'News',
                  style: TextStyle(color: Color(0xFF0a0a23)),
                ),
                onTap: () {
                  controller!.loadUrl('https://www.freecodecamp.org/news/');
                  Navigator.pop(context);
                }),
            ListTile(
                title: Text(
                  'Radio',
                  style: TextStyle(color: Color(0xFF0a0a23)),
                ),
                onTap: () {
                  controller!.loadUrl('https://coderadio.freecodecamp.org/');
                  Navigator.pop(context);
                }),
            ListTile(
              title: Text(
                'FAQ',
                style: TextStyle(color: Color(0xFF0a0a23)),
              ),
              onTap: () {
                controller!.loadUrl('https://www.freecodecamp.org/news/about/');
                Navigator.pop(context);
              },
            ),
            ListTile(
              title: Text(
                'Donate',
                style: TextStyle(color: Color(0xFF0a0a23)),
              ),
              onTap: () {
                controller!.loadUrl('https://www.freecodecamp.org/donate');
                Navigator.pop(context);
              },
            ),
            ListTile(
              title: Text(
                'Flash Cards',
                style: TextStyle(color: Color(0xFF0a0a23)),
              ),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => FlashCards()),
                );
              },
            )
          ],
        ),
      ),
      body: WillPopScope(
        onWillPop: () async {
          if (await controller!.canGoBack()) {
            await controller!.goBack();
          } else {
            ScaffoldMessenger.of(context)
                .showSnackBar(SnackBar(content: Text("No back history item")));
          }
          return false;
        },
        child: WebView(
          initialUrl: 'https://www.freecodecamp.org/learn/',
          userAgent: "random",
          javascriptMode: JavascriptMode.unrestricted,
          onWebViewCreated: (WebViewController webViewController) {
            setState(() {
              controller = webViewController;
            });
          },
        ),
      ),
    );
  }
}
