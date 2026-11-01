import 'package:flutter/material.dart';
import 'package:freecodecamp/utils/custom_tab.dart';

Uri learningWebsiteUri(String superBlock, {String? block}) {
  final path = block == null
      ? '/learn/$superBlock/'
      : '/learn/$superBlock/$block/$block';
  return Uri.https('www.freecodecamp.org', path);
}

Future<void> openLearningWebsite(
  BuildContext context,
  String superBlock, {
  String? block,
}) async {
  final url = learningWebsiteUri(superBlock, block: block).toString();
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
