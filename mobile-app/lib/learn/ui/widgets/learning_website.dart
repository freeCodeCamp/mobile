import 'package:flutter/material.dart';
import 'package:freecodecamp/utils/custom_tab.dart';

Future<void> openLearningWebsite(
  BuildContext context,
  String course, {
  String? chapter,
}) async {
  final url = Uri.https(
    'www.freecodecamp.org',
    '/learn/$course/',
  ).replace(fragment: chapter).toString();
  try {
    await openInCustomTab(url);
  } catch (_) {
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Could not open freeCodeCamp. Please try again.'),
        ),
      );
    }
  }
}
