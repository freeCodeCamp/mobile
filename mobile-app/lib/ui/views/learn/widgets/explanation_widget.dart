import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:freecodecamp/models/learn/challenge_model.dart';
import 'package:freecodecamp/ui/views/news/html_handler/html_handler.dart';
import 'package:freecodecamp/ui/widgets/drawer_widget/drawer_widget_view.dart';

class Explanation extends StatelessWidget {
  const Explanation({
    super.key,
    required this.challenge,
  });

  final Challenge challenge;

  @override
  Widget build(BuildContext context) {
    HTMLParser parser = HTMLParser(context: context);

    return Column(
      children: [
        ExpansionTile(
          title: Text(
            'Explanation',
            style: TextStyle(
              fontSize: FontSize.large.value,
              fontWeight: FontWeight.bold,
            ),
          ),
          shape: RoundedRectangleBorder(
            side: BorderSide.none,
            borderRadius: BorderRadius.zero,
          ),
          collapsedShape: RoundedRectangleBorder(
            side: BorderSide.none,
            borderRadius: BorderRadius.zero,
          ),
          children: [
            const SizedBox(height: 8),
            ...parser.parse(challenge.explanation!),
            const SizedBox(height: 8),
          ],
        ),
        buildDivider(),
      ],
    );
  }
}
