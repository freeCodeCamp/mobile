import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'package:webview_flutter/webview_flutter.dart';

import 'browser_viewmodel.dart';

class BrowserView extends StatelessWidget {
  final String url;
  const BrowserView({Key? key, required this.url}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<BrowserViewModel>.reactive(
      onModelReady: (viewModel) => viewModel.init(),
      // appBar: AppBar(
      //   title: Text('Browser'),
      // ),
      builder: (context, viewModel, child) => Scaffold(
        body: WillPopScope(
          onWillPop: () async {
            if (await viewModel.controller!.canGoBack()) {
              await viewModel.controller!.goBack();
            } else {
              viewModel.goBack();
            }
            return false;
          },
          child: WebView(
            initialUrl: url,
            userAgent: "random",
            javascriptMode: JavascriptMode.unrestricted,
            onWebViewCreated: viewModel.setController,
          ),
        ),
      ),
      viewModelBuilder: () => BrowserViewModel(),
    );
  }
}
