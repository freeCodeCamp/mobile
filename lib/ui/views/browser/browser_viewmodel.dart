import 'package:stacked/stacked.dart';
import 'package:webview_flutter/webview_flutter.dart';

class BrowserViewModel extends BaseViewModel {
  void init() {
    WebView.platform = SurfaceAndroidWebView();
  }
}
