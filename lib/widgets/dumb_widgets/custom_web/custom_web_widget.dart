import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class CustomWebWidget extends StatefulWidget {
  const CustomWebWidget({
    Key key,
    @required Completer<WebViewController> controller,
    @required this.url,
  })  : _controller = controller,
        super(key: key);

  final Completer<WebViewController> _controller;
  final String url;

  @override
  _CustomWebWidgetState createState() => _CustomWebWidgetState();
}

class _CustomWebWidgetState extends State<CustomWebWidget> {
  @override
  void initState() {
    super.initState();
    // Enable hybrid composition.
    if (Platform.isAndroid) WebView.platform = SurfaceAndroidWebView();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      // ignore: missing_return
      onWillPop: () async {
        WebViewController controllerSnapshot = await widget._controller.future;
        if (await controllerSnapshot.canGoBack()) {
          await controllerSnapshot.goBack();
        } else {
          // ignore: deprecated_member_use
          Scaffold.of(context).showSnackBar(
            const SnackBar(content: Text("No back history item")),
          );
          return false;
        }
      },
      child: WebView(
        debuggingEnabled: true,
        initialUrl: widget.url,
        userAgent: "random",
        javascriptMode: JavascriptMode.unrestricted,
        onWebViewCreated: (WebViewController webViewController) {
          widget._controller.complete(webViewController);
          // webViewController.evaluateJavascript(
          //     'window.addEventListener ("touchmove", function (event) { event.preventDefault (); }, {passive: false});');
        },
      ),
    );
  }
}
