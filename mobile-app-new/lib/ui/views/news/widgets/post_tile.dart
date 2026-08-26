import 'dart:developer';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:mobile_app_new/fcc_theme.dart';
import 'package:mobile_app_new/models/news/post_model.dart';
import 'package:mobile_app_new/routing/news.dart';
import 'package:mobile_app_new/utils/date_utils.dart';
import 'package:mobile_app_new/ui/views/news/widgets/tag_button.dart';

class PostTile extends StatelessWidget {
  const PostTile({super.key, required this.post});

  final Post post;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      splashColor: Colors.transparent,
      onTap: () {
        NewsPostRoute(slug: post.slug).push(context);
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildCoverImage(),
            const SizedBox(height: 8),
            if (post.tags.isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(bottom: 6),
                child: Wrap(
                  spacing: 0,
                  runSpacing: 4,
                  children: [
                    for (int i = 0; i < post.tags.length && i < 3; i++)
                      TagButton(
                        tagName: post.tags[i].name,
                        tagSlug: post.tags[i].slug,
                        compact: true,
                      ),
                  ],
                ),
              ),
            Text(
              post.title,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                height: 1.25,
              ),
            ),
            const SizedBox(height: 8),
            _buildAuthorRow(context),
          ],
        ),
      ),
    );
  }

  Widget _buildCoverImage() {
    final imageUrl = post.coverImage?.url;

    return ClipRRect(
      borderRadius: BorderRadius.circular(12),
      child: AspectRatio(
        aspectRatio: 16 / 9,
        child: Container(
          color: FccColors.gray80,
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
                  errorWidget: (context, url, error) {
                    log('Error loading image: $url - $imageUrl - $error');
                    return Image.asset(
                      'assets/images/freecodecamp-banner.png',
                      fit: BoxFit.cover,
                    );
                  },
                ),
        ),
      ),
    );
  }

  Widget _buildAuthorRow(BuildContext context) {
    final author = post.author;
    final profileUrl = author.profilePicture;

    return Row(
      children: [
        Flexible(
          child: GestureDetector(
            onTap: () {
              NewsAuthorRoute(
                username: author.username,
                $extra: author,
              ).push(context);
            },
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: SizedBox(
                    width: 24,
                    height: 24,
                    child: profileUrl == null
                        ? Image.asset(
                            'assets/images/placeholder-profile-img.png',
                            fit: BoxFit.cover,
                          )
                        : CachedNetworkImage(
                            imageUrl: profileUrl,
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
                Flexible(
                  child: Text(
                    author.name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 13,
                      color: Colors.white.withValues(alpha: 0.8),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        Text(
          '  •  ',
          style: TextStyle(
            fontSize: 13,
            color: Colors.white.withValues(alpha: 0.5),
          ),
        ),
        Text(
          parseDate(post.publishedAt),
          style: TextStyle(
            fontSize: 13,
            color: Colors.white.withValues(alpha: 0.5),
          ),
        ),
      ],
    );
  }
}
