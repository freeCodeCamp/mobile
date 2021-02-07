import 'dart:async';

import 'package:flutter/material.dart';
import 'package:freecodecamp/widgets/dumb_widgets/navigation_controls/navigation_controls_widget.dart';
import 'package:stacked/stacked.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'news_view_model.dart';

class NewsView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final Completer<WebViewController> _controller =
        Completer<WebViewController>();
    return ViewModelBuilder<NewsViewModel>.reactive(
      builder: (BuildContext context, NewsViewModel viewModel, Widget _) {
        return Scaffold(
          appBar: AppBar(
            backgroundColor: Color(0xFF0a0a23),
            actions: <Widget>[NavigationControls(_controller.future)],
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
                  onTap: () => viewModel.navigateToTraining(),
                ),
                ListTile(
                  title: Text(
                    'Forum',
                    style: TextStyle(color: Color(0xFF0a0a23)),
                  ),
                  onTap: () => viewModel.navigateToForum(),
                ),
                ListTile(
                  title: Text(
                    'News',
                    style: TextStyle(color: Color(0xFF0a0a23)),
                  ),
                ),
              ],
            ),
          ),
          body: Builder(builder: (BuildContext context) {
            return WebView(
              initialUrl: 'https://www.freecodecamp.org/news/',
              userAgent: "random",
              javascriptMode: JavascriptMode.unrestricted,
              onWebViewCreated: (WebViewController webViewController) {
                _controller.complete(webViewController);
              },
            );
          }),
        );
      },
      viewModelBuilder: () => NewsViewModel(),
    );
  }
}
