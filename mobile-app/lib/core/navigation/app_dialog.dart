// A thin dialog wrapper that does NOT depend on Stacked.
//
// Uses the [AppNavigator.navigatorKey] to obtain the current [BuildContext]
// and show Material dialogs without requiring a Stacked [DialogService].
//
// Usage:
//   final confirmed = await AppDialog.showConfirmation(
//     title: 'Delete account',
//     description: 'Are you sure you want to delete your account?',
//     confirmLabel: 'Delete',
//     cancelLabel: 'Cancel',
//   );

import 'package:flutter/material.dart';
import 'package:freecodecamp/core/navigation/app_navigator.dart';

class AppDialog {
  AppDialog._();

  static BuildContext? get _context =>
      AppNavigator.navigatorKey.currentContext;

  /// Show a simple confirmation dialog with an OK/Cancel choice.
  /// Returns `true` if the user tapped the confirm button, `false` otherwise.
  static Future<bool> showConfirmation({
    required String title,
    String description = '',
    String confirmLabel = 'OK',
    String cancelLabel = 'Cancel',
    Color backgroundColor = const Color(0xFF2A2A40),
  }) async {
    final ctx = _context;
    if (ctx == null) return false;

    final result = await showDialog<bool>(
      context: ctx,
      builder: (dialogContext) => AlertDialog(
        backgroundColor: backgroundColor,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(0)),
        title: Text(title),
        content: description.isNotEmpty ? Text(description) : null,
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(false),
            child: Text(cancelLabel),
          ),
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(true),
            child: Text(confirmLabel),
          ),
        ],
      ),
    );
    return result ?? false;
  }

  /// Show a general-purpose dialog with a custom [builder].
  /// Returns whatever value the dialog resolves with.
  static Future<T?> showCustom<T>({
    required WidgetBuilder builder,
    bool barrierDismissible = true,
    RouteSettings? routeSettings,
  }) async {
    final ctx = _context;
    if (ctx == null) return null;

    return showDialog<T>(
      context: ctx,
      barrierDismissible: barrierDismissible,
      routeSettings: routeSettings,
      builder: builder,
    );
  }
}
