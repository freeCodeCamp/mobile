import 'dart:async';

import 'package:flutter/material.dart';
import 'package:freecodecamp/widgets/dumb_widgets/navigation_controls/navigation_controls_widget.dart';
import 'package:stacked/stacked.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'training_view_model.dart';

class TrainingView extends StatelessWidget {
  final Completer<WebViewController> _controller =
      Completer<WebViewController>();
  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<TrainingViewModel>.reactive(
      builder: (BuildContext context, TrainingViewModel viewModel, Widget _) {
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
                  onTap: () => viewModel.navigateToNews(),
                ),
              ],
            ),
          ),
          body: Builder(builder: (BuildContext context) {
            return WebView(
              initialUrl: 'https://www.freecodecamp.org/learn/',
              userAgent: "random",
              javascriptMode: JavascriptMode.unrestricted,
              onWebViewCreated: (WebViewController webViewController) {
                _controller.complete(webViewController);
              },
            );
          }),
        );
      },
      viewModelBuilder: () => TrainingViewModel(),
    );
  }
}
