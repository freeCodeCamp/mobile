import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:stacked/stacked.dart';

class RPGViewModel extends BaseViewModel {
  final InAppLocalhostServer localhostServer = InAppLocalhostServer(documentRoot: 'assets/LearnToCodeRPG');

  void init() async {
    await localhostServer.start();
  }
}
