// A thin SnackBar wrapper that does NOT depend on Stacked.
//
// Uses the [AppNavigator.navigatorKey] to obtain the current [BuildContext]
// and show Material snack bars without requiring a Stacked [SnackbarService].
//
// Usage:
//   AppSnackbar.show(title: 'Done', message: 'Operation completed.');

import 'package:flutter/material.dart';
import 'package:freecodecamp/core/navigation/app_navigator.dart';

class AppSnackbar {
  AppSnackbar._();

  /// Show a simple snack bar with an optional [message] beneath the [title].
  static void show({
    required String title,
    String message = '',
    Duration duration = const Duration(seconds: 3),
    Color backgroundColor = const Color(0xFF2A2A40),
    Color textColor = Colors.white,
  }) {
    final context =
        AppNavigator.navigatorKey.currentContext;
    if (context == null) return;

    final combinedMessage =
        message.isNotEmpty ? '$title\n$message' : title;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          combinedMessage,
          style: TextStyle(color: textColor),
        ),
        backgroundColor: backgroundColor,
        duration: duration,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }
}
