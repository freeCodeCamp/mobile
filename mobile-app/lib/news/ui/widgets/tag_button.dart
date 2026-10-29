import 'package:flutter/material.dart';
import 'package:freecodecamp/fcc_theme.dart';
import 'package:freecodecamp/routing/news.dart';

enum TagButtonVariant { listEyebrow, articleEyebrow, link }

class TagButton extends StatelessWidget {
  const TagButton({
    super.key,
    required this.tagName,
    required this.tagSlug,
    this.variant = TagButtonVariant.link,
  });

  final String tagName;
  final String tagSlug;
  final TagButtonVariant variant;

  @override
  Widget build(BuildContext context) {
    final link = variant == TagButtonVariant.link;
    final listEyebrow = variant == TagButtonVariant.listEyebrow;
    return Padding(
      padding: EdgeInsets.only(right: 6, bottom: link ? 8 : 0),
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxWidth: MediaQuery.sizeOf(context).width * (link ? .7 : .5),
        ),
        child: TextButton(
          style: TextButton.styleFrom(
            minimumSize: const Size(44, 44),
            padding: EdgeInsets.zero,
            textStyle: TextStyle(
              fontFamily: listEyebrow ? 'JetBrains Mono' : 'Lato',
              fontSize: listEyebrow
                  ? 12
                  : link
                  ? 15
                  : 14,
              fontWeight: FontWeight.w700,
              letterSpacing: 0,
              decoration: link ? TextDecoration.underline : TextDecoration.none,
            ),
          ).copyWith(shape: FccTheme.focusShape(context, radius: 10)),
          onPressed: () =>
              NewsTagFeedRoute(tagSlug: tagSlug, $extra: tagName).push(context),
          child: Text(
            '#$tagName',
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ),
    );
  }
}
