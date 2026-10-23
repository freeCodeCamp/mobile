import 'package:flutter/material.dart';
import 'package:freecodecamp/learn/ui/challenge/widgets/challenge_card.dart';
import 'package:freecodecamp/learn/ui/challenge/widgets/parsed_html.dart';

class HtmlCard extends StatelessWidget {
  const HtmlCard({
    super.key,
    required this.title,
    required this.html,
    this.collapsible = false,
  });

  final String title;
  final String html;
  final bool collapsible;

  @override
  Widget build(BuildContext context) {
    return ChallengeCard(
      title: title,
      child: collapsible
          ? ExpansionTile(
              title: const Text('Tap to expand'),
              shape: const Border(),
              collapsedShape: const Border(),
              children: [ParsedHtml(html)],
            )
          : ParsedHtml(html),
    );
  }
}
