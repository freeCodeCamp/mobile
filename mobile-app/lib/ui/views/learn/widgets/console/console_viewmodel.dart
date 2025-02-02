import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:stacked/stacked.dart';

class JavaScriptConsoleViewModel extends BaseViewModel {
  ScrollController controller = ScrollController();

  Color getConsoleTextColor(ConsoleMessageLevel messageLevel) {
    switch (messageLevel.toString()) {
      case 'ConsoleMessageLevel.DEBUG':
        return Colors.white.withValues(alpha: 0.87);
      case 'ConsoleMessageLevel.ERROR':
        return Colors.red.withValues(alpha: 0.87);
      case 'ConsoleMessageLevel.LOG':
        return Colors.white.withValues(alpha: 0.87);
      case 'ConsoleMessageLevel.TIP':
        return Colors.blue.withValues(alpha: 0.87);
      case 'ConsoleMessageLevel.WARNING':
        return Colors.yellow.withValues(alpha: 0.87);
      default:
        return Colors.white.withValues(alpha: 0.87);
    }
  }

  void scrollToBottom() {}
}
