import 'package:stacked/stacked.dart';
import 'package:webview_flutter/webview_flutter.dart';

class ConsoleModel extends BaseViewModel {
  String? _parsedCode;
  String? get parsedCode => _parsedCode;

  List _logList = [];
  List get logList => _logList;

  WebViewController? _webViewController;
  WebViewController? get webViewController => _webViewController;

  set setLogList(List log) {
    _logList = log;
    notifyListeners();
  }

  set setParsedCode(String code) {
    _parsedCode = code;
    notifyListeners();
  }

  set setWebViewController(WebViewController controller) {
    _webViewController = controller;
    notifyListeners();
  }

  String updateConsole(String code) {
    return code.replaceAll('console.log', 'Print.postMessage');
  }
}
