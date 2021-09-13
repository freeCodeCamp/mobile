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
      builder: (context, viewModel, child) => Scaffold(
        body: SafeArea(
          child: WebView(
            initialUrl: url,
            javascriptMode: JavascriptMode.unrestricted,
          ),
        ),
      ),
      viewModelBuilder: () => BrowserViewModel(),
    );
  }
}
