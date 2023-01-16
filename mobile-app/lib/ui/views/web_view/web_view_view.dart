import 'package:flutter/material.dart';
import 'package:freecodecamp/ui/views/web_view/web_viewmodel.dart';
import 'package:stacked/stacked.dart';
import 'package:webview_flutter/webview_flutter.dart';

class WebViewView extends StatelessWidget {
  const WebViewView({Key? key, required this.url}) : super(key: key);

  final String url;

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<WebViewModel>.reactive(
        viewModelBuilder: () => WebViewModel(),
        builder: (context, model, child) => Scaffold(
              appBar: AppBar(),
              body: WebView(
                initialUrl: url,
                userAgent: 'random',
                javascriptMode: JavascriptMode.unrestricted,
                initialCookies: const [],
                onWebViewCreated: (controller) async {},
              ),
            ));
  }
}
