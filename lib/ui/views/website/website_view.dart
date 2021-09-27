import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'package:webview_flutter/webview_flutter.dart';

import 'website_viewmodel.dart';

class WebsiteView extends StatelessWidget {
  const WebsiteView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<WebsiteViewModel>.reactive(
      onModelReady: (viewModel) => viewModel.init(),
      builder: (context, viewModel, child) => Scaffold(
        appBar: AppBar(
          backgroundColor: const Color(0xFF0a0a23),
          actions: [
            Row(
              children: <Widget>[
                IconButton(
                  icon: const Icon(Icons.arrow_back_ios),
                  onPressed: () async {
                    if (await viewModel.controller!.canGoBack()) {
                      await viewModel.controller!.goBack();
                    } else {
                      viewModel.showSnackbar();
                      return;
                    }
                  },
                ),
                IconButton(
                  icon: const Icon(Icons.arrow_forward_ios),
                  onPressed: () async {
                    if (await viewModel.controller!.canGoForward()) {
                      await viewModel.controller!.goForward();
                    } else {
                      viewModel.showSnackbar();
                      return;
                    }
                  },
                ),
                IconButton(
                  icon: const Icon(Icons.replay),
                  onPressed: () {
                    viewModel.controller!.reload();
                  },
                ),
              ],
            ),
          ],
        ),
        drawer: Drawer(
          child: ListView(
            children: <Widget>[
              const DrawerHeader(
                child: Text(''),
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage('assets/images/splash_screen.png'),
                  ),
                ),
              ),
              ListTile(
                  title: const Text(
                    'Training',
                    style: TextStyle(color: Color(0xFF0a0a23)),
                  ),
                  onTap: () {
                    viewModel.controller!
                        .loadUrl('https://www.freecodecamp.org/learn/');
                    viewModel.goBack();
                  }),
              ListTile(
                  title: const Text(
                    'Forum',
                    style: TextStyle(color: Color(0xFF0a0a23)),
                  ),
                  onTap: () {
                    viewModel.controller!
                        .loadUrl('https://forum.freecodecamp.org/');
                    viewModel.goBack();
                  }),
              ListTile(
                  title: const Text(
                    'News',
                    style: TextStyle(color: Color(0xFF0a0a23)),
                  ),
                  onTap: () {
                    viewModel.controller!
                        .loadUrl('https://www.freecodecamp.org/news/');
                    viewModel.goBack();
                  }),
              ListTile(
                  title: const Text(
                    'Radio',
                    style: TextStyle(color: Color(0xFF0a0a23)),
                  ),
                  onTap: () {
                    viewModel.controller!
                        .loadUrl('https://coderadio.freecodecamp.org/');
                    viewModel.goBack();
                  }),
              ListTile(
                title: const Text(
                  'FAQ',
                  style: TextStyle(color: Color(0xFF0a0a23)),
                ),
                onTap: () {
                  viewModel.controller!
                      .loadUrl('https://www.freecodecamp.org/news/about/');
                  viewModel.goBack();
                },
              ),
              ListTile(
                title: const Text(
                  'Donate',
                  style: TextStyle(color: Color(0xFF0a0a23)),
                ),
                onTap: () {
                  viewModel.controller!
                      .loadUrl('https://www.freecodecamp.org/donate');
                  viewModel.goBack();
                },
              ),
              ListTile(
                title: const Text(
                  'Home',
                  style: TextStyle(color: Color(0xFF0a0a23)),
                ),
                onTap: () {
                  viewModel.goToHome();
                },
              ),
              ListTile(
                title: const Text(
                  'Podcasts',
                  style: TextStyle(color: Color(0xFF0a0a23)),
                ),
                onTap: () {
                  viewModel.goToPodcasts();
                },
              ),
            ],
          ),
        ),
        body: WillPopScope(
          onWillPop: () async {
            if (await viewModel.controller!.canGoBack()) {
              await viewModel.controller!.goBack();
            } else {
              viewModel.showSnackbar();
            }
            return false;
          },
          child: WebView(
            initialUrl: 'https://www.freecodecamp.org/learn/',
            userAgent: "random",
            javascriptMode: JavascriptMode.unrestricted,
            onWebViewCreated: viewModel.setController,
          ),
        ),
      ),
      viewModelBuilder: () => WebsiteViewModel(),
    );
  }
}
