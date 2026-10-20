import 'package:flutter/material.dart';
import 'package:mobile_app_new/learn/ui/challenge/widgets/parsed_html.dart';

class TaskExplanation extends StatelessWidget {
  const TaskExplanation({super.key, required this.html});

  final String html;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Material(
        color: colors.surface,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: BorderSide(color: colors.outline),
        ),
        clipBehavior: Clip.antiAlias,
        child: ExpansionTile(
          tilePadding: const EdgeInsets.symmetric(horizontal: 14),
          childrenPadding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
          minTileHeight: 48,
          shape: const Border(),
          collapsedShape: const Border(),
          iconColor: colors.onSurface,
          collapsedIconColor: colors.onSurface,
          title: const Text(
            'Explanation',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
          ),
          children: [ParsedHtml(html)],
        ),
      ),
    );
  }
}
