import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:stacked/stacked.dart';

class JavaScriptConsoleViewModel extends BaseViewModel {
  ScrollController controller = ScrollController();

  Color getConsoleTextColor(ConsoleMessageLevel messageLevel) {
    switch (messageLevel.toString()) {
      case 'ConsoleMessageLevel.DEBUG':
        return Colors.white.withOpacity(0.87);
      case 'ConsoleMessageLevel.ERROR':
        return Colors.red.withOpacity(0.87);
      case 'ConsoleMessageLevel.LOG':
        return Colors.white.withOpacity(0.87);
      case 'ConsoleMessageLevel.TIP':
        return Colors.blue.withOpacity(0.87);
      case 'ConsoleMessageLevel.WARNING':
        return Colors.yellow.withOpacity(0.87);
      default:
        return Colors.white.withOpacity(0.87);
    }
  }

  void scrollToBottom() {}
}
