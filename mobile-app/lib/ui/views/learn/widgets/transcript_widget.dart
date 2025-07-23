import 'package:flutter/material.dart';
import 'package:freecodecamp/ui/views/news/html_handler/html_handler.dart';

class Transcript extends StatelessWidget {
  const Transcript({
    super.key,
    required this.transcript,
    this.isCollapsible = true,
  });

  final String transcript;
  final bool isCollapsible;

  @override
  Widget build(BuildContext context) {
    HTMLParser parser = HTMLParser(context: context);

    if (isCollapsible) {
      return ExpansionTile(
        backgroundColor: Colors.transparent,
        collapsedBackgroundColor: Colors.transparent,
        title: const Text('Tap to expand'),
        shape: const RoundedRectangleBorder(
          side: BorderSide.none,
          borderRadius: BorderRadius.zero,
        ),
        collapsedShape: const RoundedRectangleBorder(
          side: BorderSide.none,
          borderRadius: BorderRadius.zero,
        ),
        children: [
          ...parser.parse(transcript),
        ],
      );
    } else {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ...parser.parse(transcript),
        ],
      );
    }
  }
}
