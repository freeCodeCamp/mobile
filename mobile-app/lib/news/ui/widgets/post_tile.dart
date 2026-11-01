import 'package:flutter/material.dart';
import 'package:freecodecamp/news/models/post_summary_model.dart';
import 'package:freecodecamp/news/ui/widgets/news_image.dart';
import 'package:freecodecamp/news/ui/widgets/tag_button.dart';
import 'package:freecodecamp/routing/news.dart';
import 'package:freecodecamp/utils/date_utils.dart';

class PostTile extends StatelessWidget {
  const PostTile({
    super.key,
    required this.post,
    this.featured = false,
    this.selectedTagSlug,
  });

  final PostSummary post;
  final bool featured;
  final String? selectedTagSlug;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final tag = post.tags
        .where((tag) => tag.slug != selectedTagSlug)
        .firstOrNull;
    final title = Text(
      post.title,
      maxLines: featured ? 4 : 3,
      overflow: TextOverflow.ellipsis,
      style: TextStyle(
        fontSize: featured ? 20 : 15,
        fontWeight: FontWeight.w700,
        height: 1.3,
        color: colors.onSurface,
      ),
    );

    return InkWell(
      onTap: () => NewsPostRoute(slug: post.slug).push(context),
      child: Padding(
        padding: featured
            ? const EdgeInsets.symmetric(vertical: 8)
            : const EdgeInsets.only(top: 16, bottom: 14),
        child: featured
            ? Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AspectRatio(
                    aspectRatio: 16 / 9,
                    child: NewsImage(url: post.coverImage?.url),
                  ),
                  const SizedBox(height: 14),
                  title,
                  const SizedBox(height: 12),
                  _author(context, withAvatar: true),
                  const SizedBox(height: 8),
                ],
              )
            : Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  NewsImage(
                    url: post.coverImage?.url,
                    width: 104,
                    height: 70,
                    radius: 8,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (tag != null)
                          TagButton(
                            tagName: tag.name,
                            tagSlug: tag.slug,
                            variant: TagButtonVariant.listEyebrow,
                          ),
                        if (tag != null) const SizedBox(height: 4),
                        title,
                        const SizedBox(height: 4),
                        _author(context),
                      ],
                    ),
                  ),
                ],
              ),
      ),
    );
  }

  Widget _author(BuildContext context, {bool withAvatar = false}) {
    final colors = Theme.of(context).colorScheme;
    return InkWell(
      onTap: () => NewsAuthorRoute(
        username: post.author.username,
        $extra: post.author,
      ).push(context),
      child: Row(
        children: [
          if (withAvatar) ...[
            NewsImage(
              url: post.author.profilePicture,
              isAvatar: true,
              width: 24,
              height: 24,
            ),
            const SizedBox(width: 8),
          ],
          Expanded(
            child: Text(
              '${post.author.name} · ${parseDate(post.publishedAt).toLowerCase()}',
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: withAvatar ? 14 : 13,
                height: 1.4,
                color: colors.onSurfaceVariant,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
