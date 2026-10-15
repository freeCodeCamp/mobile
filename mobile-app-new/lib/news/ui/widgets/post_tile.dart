import 'package:flutter/material.dart';
import 'package:mobile_app_new/news/models/post_summary_model.dart';
import 'package:mobile_app_new/news/ui/widgets/news_image.dart';
import 'package:mobile_app_new/news/ui/widgets/tag_button.dart';
import 'package:mobile_app_new/routing/news.dart';
import 'package:mobile_app_new/utils/date_utils.dart';

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
        fontSize: featured ? 23 : 17,
        fontWeight: FontWeight.w700,
        height: 1.3,
        color: colors.onSurface,
      ),
    );

    return InkWell(
      onTap: () => NewsPostRoute(slug: post.slug).push(context),
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: featured ? 8 : 18),
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
                  NewsImage(url: post.coverImage?.url, width: 104, height: 80),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (tag != null)
                          TagButton(
                            tagName: tag.name,
                            tagSlug: tag.slug,
                            compact: true,
                          ),
                        title,
                        const SizedBox(height: 6),
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
              width: 28,
              height: 28,
            ),
            const SizedBox(width: 8),
          ],
          Expanded(
            child: Text(
              '${post.author.name} · ${parseDate(post.publishedAt).toLowerCase()}',
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: 13,
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
