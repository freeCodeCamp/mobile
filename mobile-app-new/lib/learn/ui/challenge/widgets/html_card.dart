import 'package:flutter/material.dart';
import 'package:mobile_app_new/learn/ui/challenge/widgets/challenge_card.dart';
import 'package:mobile_app_new/learn/ui/challenge/widgets/parsed_html.dart';

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
  Widget build(BuildContext context) => ChallengeCard(
    title: collapsible ? '' : title,
    child: collapsible
        ? ExpansionTile(
            tilePadding: EdgeInsets.zero,
            childrenPadding: EdgeInsets.zero,
            title: Text(title, style: Theme.of(context).textTheme.titleMedium),
            shape: const Border(),
            collapsedShape: const Border(),
            children: [ParsedHtml(html)],
          )
        : ParsedHtml(html),
  );
}
