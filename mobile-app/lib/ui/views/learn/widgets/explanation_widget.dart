import 'package:flutter/material.dart';
import 'package:freecodecamp/models/learn/challenge_model.dart';
import 'package:freecodecamp/ui/views/news/html_handler/html_handler.dart';

class Explanation extends StatelessWidget {
  const Explanation({
    super.key,
    required this.challenge,
  });

  final Challenge challenge;

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
        ...parser.parse(challenge.explanation!),
      ],
    );
  }
}
