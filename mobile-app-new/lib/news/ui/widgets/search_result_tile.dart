import 'package:flutter/material.dart';
import 'package:mobile_app_new/news/models/search_post_model.dart';
import 'package:mobile_app_new/news/ui/widgets/news_image.dart';
import 'package:mobile_app_new/routing/news.dart';
import 'package:mobile_app_new/utils/date_utils.dart';

class SearchResultTile extends StatelessWidget {
  const SearchResultTile({super.key, required this.post});

  final SearchPost post;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final date = post.publishedAt;
    return InkWell(
      onTap: () => NewsPostRoute(slug: post.slug).push(context),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 16),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            NewsImage(url: post.featureImage, width: 104, height: 80),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    post.title,
                    maxLines: 4,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.w700,
                      height: 1.3,
                      color: colors.onSurface,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    '${post.author.name}${date == null ? '' : ' · ${parseDate(date).toLowerCase()}'}',
                    style: TextStyle(
                      fontSize: 13,
                      height: 1.4,
                      color: colors.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
