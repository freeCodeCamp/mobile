import 'package:flutter/material.dart';
import 'package:freecodecamp/ui/views/learn/learn_viewmodel.dart';
import 'package:stacked/stacked.dart';
import 'package:webview_flutter/webview_flutter.dart';

class BrowserView extends StatelessWidget {
  const BrowserView({Key? key, required this.url}) : super(key: key);

  final String url;

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<LearnViewModel>.reactive(
        viewModelBuilder: () => LearnViewModel(),
        builder: (context, model, child) => Scaffold(
              appBar: AppBar(),
              body: WillPopScope(
                onWillPop: () async {
                  if (await model.controller!.canGoBack()) {
                    await model.controller!.goBack();
                  } else {
                    model.goBack();
                  }

                  return false;
                },
                child: WebView(
                  onWebViewCreated: model.initState,
                  onPageFinished: (string) {
                    model.removeNavBar(model.controller);
                  },
                  initialUrl: url,
                  javascriptMode: JavascriptMode.unrestricted,
                  userAgent: 'random',
                ),
              ),
            ));
  }
}
