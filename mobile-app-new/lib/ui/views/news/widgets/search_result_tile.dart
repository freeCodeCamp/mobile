import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:mobile_app_new/fcc_theme.dart';
import 'package:mobile_app_new/models/news/search_post_model.dart';
import 'package:mobile_app_new/routing/news.dart';
import 'package:mobile_app_new/utils/date_utils.dart';

class SearchResultTile extends StatelessWidget {
  const SearchResultTile({super.key, required this.post});

  final SearchPost post;

  @override
  Widget build(BuildContext context) {
    final publishedAt = post.publishedAt;

    return InkWell(
      onTap: () => NewsPostRoute(slug: post.slug).push(context),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildCoverImage(),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    post.title,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      height: 1.3,
                    ),
                  ),
                  const SizedBox(height: 8),
                  _buildAuthorRow(),
                  if (publishedAt != null)
                    Padding(
                      padding: const EdgeInsets.only(top: 4),
                      child: Text(
                        parseDate(publishedAt),
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.white.withValues(alpha: 0.5),
                        ),
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

  Widget _buildCoverImage() {
    final imageUrl = post.featureImage;

    return ClipRRect(
      borderRadius: BorderRadius.circular(8),
      child: SizedBox(
        width: 120,
        height: 80,
        child: imageUrl == null
            ? Image.asset(
                'assets/images/freecodecamp-banner.png',
                fit: BoxFit.cover,
              )
            : CachedNetworkImage(
                imageUrl: imageUrl,
                fit: BoxFit.cover,
                placeholder: (context, url) =>
                    ColoredBox(color: FccColors.gray80),
                errorWidget: (context, url, error) => Image.asset(
                  'assets/images/freecodecamp-banner.png',
                  fit: BoxFit.cover,
                ),
              ),
      ),
    );
  }

  Widget _buildAuthorRow() {
    final profileImageUrl = post.author.profileImage;

    return Row(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: SizedBox(
            width: 24,
            height: 24,
            child: profileImageUrl == null
                ? Image.asset(
                    'assets/images/placeholder-profile-img.png',
                    fit: BoxFit.cover,
                  )
                : CachedNetworkImage(
                    imageUrl: profileImageUrl,
                    fit: BoxFit.cover,
                    placeholder: (context, url) =>
                        ColoredBox(color: FccColors.gray80),
                    errorWidget: (context, url, error) => Image.asset(
                      'assets/images/placeholder-profile-img.png',
                      fit: BoxFit.cover,
                    ),
                  ),
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            post.author.name,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontSize: 13,
              color: Colors.white.withValues(alpha: 0.7),
            ),
          ),
        ),
      ],
    );
  }
}
