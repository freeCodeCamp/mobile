import 'package:flutter/material.dart';
import 'package:freecodecamp/ui/views/learn/learn_viewmodel.dart';
import 'package:freecodecamp/ui/widgets/drawer_widget/drawer_widget_view.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:stacked/stacked.dart';

class LearnView extends StatelessWidget {
  const LearnView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<LearnViewModel>.reactive(
        viewModelBuilder: () => LearnViewModel(),
        onModelReady: (model) => model.init(),
        builder: (context, model, child) => Scaffold(
              appBar: AppBar(
                title: const Text('Learn'),
                actions: [
                  IconButton(
                    icon: const Icon(Icons.download),
                    onPressed: () => model.logCookies(),
                  )
                ],
              ),
              drawer: const DrawerWidgetView(),
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
                  onWebViewCreated: model.setController,
                  initialUrl: 'https://www.freecodecamp.org/learn',
                  javascriptMode: JavascriptMode.unrestricted,
                  userAgent: 'random',
                ),
              ),
            ));
  }
}
