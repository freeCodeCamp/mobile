import 'package:flutter/material.dart';
import 'package:mobile_app_new/routing/news.dart';

class TagButton extends StatelessWidget {
  const TagButton({
    super.key,
    required this.tagName,
    required this.tagSlug,
    this.compact = false,
  });

  final String tagName;
  final String tagSlug;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return Padding(
      padding: EdgeInsets.only(right: 6, bottom: compact ? 0 : 8),
      child: InkWell(
        borderRadius: BorderRadius.circular(30),
        onTap: () =>
            NewsTagFeedRoute(tagSlug: tagSlug, $extra: tagName).push(context),
        child: Container(
          constraints: BoxConstraints(
            maxWidth: MediaQuery.sizeOf(context).width * (compact ? .5 : .7),
          ),
          padding: compact
              ? const EdgeInsets.symmetric(vertical: 3)
              : const EdgeInsets.symmetric(horizontal: 12, vertical: 9),
          decoration: compact
              ? null
              : ShapeDecoration(
                  color: colors.surfaceContainerLow,
                  shape: const StadiumBorder(),
                ),
          child: Text(
            '#$tagName',
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontSize: compact ? 12 : 13,
              fontWeight: compact ? FontWeight.w500 : FontWeight.w600,
              color: colors.primary,
              letterSpacing: compact ? .4 : 0,
            ),
          ),
        ),
      ),
    );
  }
}
