import 'package:flutter/services.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:stacked/stacked.dart';

class RPGViewModel extends BaseViewModel {
  final InAppLocalhostServer localhostServer =
      InAppLocalhostServer(documentRoot: 'assets/LearnToCodeRPG');

  void init() async {
    await localhostServer.start();
    await SystemChrome.setPreferredOrientations(
        [DeviceOrientation.landscapeLeft, DeviceOrientation.landscapeRight]);
  }

  void disposeView() async {
    await localhostServer.close();
    await SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeRight,
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
  }
}
