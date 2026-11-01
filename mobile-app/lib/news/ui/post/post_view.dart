import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:freecodecamp/news/models/post_model.dart';
import 'package:freecodecamp/news/ui/post/post_viewmodel.dart';
import 'package:freecodecamp/news/ui/widgets/article_reader.dart';
import 'package:freecodecamp/news/ui/widgets/bookmark_button.dart';
import 'package:freecodecamp/news/ui/widgets/news_image.dart';
import 'package:freecodecamp/news/ui/widgets/tag_button.dart';
import 'package:freecodecamp/routing/news.dart';
import 'package:freecodecamp/utils/article_date.dart';
import 'package:freecodecamp/widgets/error_retry.dart';

class NewsPostHeader extends StatelessWidget {
  const NewsPostHeader({super.key, required this.post});

  final Post post;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (post.tags.isNotEmpty) ...[
            SizedBox(
              height: 38,
              child: Stack(
                clipBehavior: Clip.none,
                children: [
                  Positioned(
                    top: -6,
                    child: TagButton(
                      tagName: post.tags.first.name,
                      tagSlug: post.tags.first.slug,
                      variant: TagButtonVariant.articleEyebrow,
                    ),
                  ),
                ],
              ),
            ),
          ],
          Text(
            post.title,
            style: const TextStyle(
              fontSize: 26,
              height: 1.25,
              fontWeight: FontWeight.w900,
            ),
          ),
          const SizedBox(height: 18),
          InkWell(
            onTap: () => NewsAuthorRoute(
              username: post.author.username,
              $extra: post.author,
            ).push(context),
            child: Row(
              children: [
                NewsImage(
                  url: post.author.profilePicture,
                  isAvatar: true,
                  width: 40,
                  height: 40,
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        post.author.name,
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 3),
                      Text(
                        '${articleDate(post.publishedAt)} · ${post.readTimeInMinutes} min read',
                        style: TextStyle(
                          fontSize: 13,
                          color: colors.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 22),
          AspectRatio(
            aspectRatio: 16 / 9,
            child: InkWell(
              onTap: post.coverImage?.url == null
                  ? null
                  : () => NewsImageRoute(
                      $extra: post.coverImage!.url!,
                      alt: post.title,
                    ).push(context),
              child: NewsImage(url: post.coverImage?.url),
            ),
          ),
        ],
      ),
    );
  }
}

class NewsPostView extends ConsumerWidget {
  const NewsPostView({super.key, required this.slug});

  final String slug;

  @override
  Widget build(BuildContext context, WidgetRef ref) => ref
      .watch(newsPostProvider(slug))
      .when(
        loading: () => Scaffold(
          appBar: AppBar(),
          body: const Center(child: CircularProgressIndicator()),
        ),
        error: (_, _) => Scaffold(
          appBar: AppBar(),
          body: ErrorRetry(
            message: 'Unable to load article.',
            onRetry: () => ref.invalidate(newsPostProvider(slug)),
          ),
        ),
        data: (post) => ArticleReader(
          html: post.content.html,
          header: NewsPostHeader(post: post),
          bookmarkButton: BookmarkButton(post: post),
          shareText: '${post.title}\n\n${post.url}',
          footer: post.tags.isEmpty
              ? null
              : Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Divider(),
                      const SizedBox(height: 12),
                      const Text(
                        'More on these topics',
                        style: TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Wrap(
                        children: [
                          for (final tag in post.tags)
                            TagButton(tagName: tag.name, tagSlug: tag.slug),
                        ],
                      ),
                    ],
                  ),
                ),
        ),
      );
}
