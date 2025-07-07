import 'package:flutter/material.dart';
import 'package:freecodecamp/ui/views/news/html_handler/html_handler.dart';

class Transcript extends StatelessWidget {
  const Transcript({
    super.key,
    required this.transcript,
  });

  final String transcript;

  @override
  Widget build(BuildContext context) {
    HTMLParser parser = HTMLParser(context: context);

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
  }
}
