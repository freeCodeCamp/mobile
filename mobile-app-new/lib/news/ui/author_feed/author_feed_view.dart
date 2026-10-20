import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:mobile_app_new/news/models/author_model.dart';
import 'package:mobile_app_new/news/controllers/feed_controller.dart';
import 'package:mobile_app_new/news/ui/author_feed/author_feed_viewmodel.dart';
import 'package:mobile_app_new/news/ui/widgets/news_image.dart';
import 'package:mobile_app_new/news/ui/widgets/post_feed_list.dart';
import 'package:mobile_app_new/routing/news.dart';
import 'package:mobile_app_new/widgets/app_bottom_navigation.dart';
import 'package:mobile_app_new/widgets/mini_player.dart';
import 'package:mobile_app_new/widgets/error_retry.dart';
import 'package:url_launcher/url_launcher.dart';

class NewsAuthorFeedView extends ConsumerWidget {
  const NewsAuthorFeedView({super.key, required this.username, this.author});

  final String username;
  final Author? author;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final author = this.author;
    return Scaffold(
      appBar: AppBar(title: const Text('Author')),
      body: author != null
          ? _buildFeed(author)
          : ref
                .watch(newsAuthorProvider(username))
                .when(
                  loading: () =>
                      const Center(child: CircularProgressIndicator()),
                  error: (_, _) => ErrorRetry(
                    message: 'Unable to load author.',
                    onRetry: () => ref.invalidate(newsAuthorProvider(username)),
                  ),
                  data: _buildFeed,
                ),
      bottomNavigationBar: const Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          MiniPlayer(),
          AppBottomNavigation(selected: AppDestination.tutorials),
        ],
      ),
    );
  }

  Widget _buildFeed(Author author) => PostFeedList(
    source: NewsFeedSource.author(author.id),
    header: _AuthorDetails(author: author),
    compact: true,
    footer: Builder(
      builder: (context) => Padding(
        padding: const EdgeInsets.only(bottom: 24),
        child: Center(
          child: TextButton(
            onPressed: () => context.go(newsFeedPath),
            child: const Text('See all articles'),
          ),
        ),
      ),
    ),
  );
}

class _AuthorDetails extends StatelessWidget {
  const _AuthorDetails({required this.author});

  final Author author;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final bio = author.bio?.text;
    final website = Uri.tryParse(author.socialMediaLinks?.website ?? '');
    final hasWebsite =
        website != null &&
        (website.scheme == 'https' || website.scheme == 'http') &&
        website.host.isNotEmpty;
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
      child: Column(
        children: [
          Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: colors.surface, width: 4),
              boxShadow: [
                BoxShadow(
                  color: colors.shadow.withValues(alpha: .08),
                  blurRadius: 12,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: NewsImage(
              url: author.profilePicture,
              isAvatar: true,
              width: 112,
              height: 112,
            ),
          ),
          const SizedBox(height: 18),
          Text(
            author.name,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 28, fontWeight: FontWeight.w800),
          ),
          if (bio != null && bio.isNotEmpty) ...[
            const SizedBox(height: 12),
            Text(
              bio,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16,
                height: 1.6,
                color: colors.onSurfaceVariant,
              ),
            ),
          ],
          if (author.location?.isNotEmpty ?? false) ...[
            const SizedBox(height: 10),
            Text(
              author.location!,
              style: TextStyle(fontSize: 14, color: colors.onSurfaceVariant),
            ),
          ],
          if (hasWebsite) ...[
            const SizedBox(height: 16),
            OutlinedButton.icon(
              onPressed: () =>
                  launchUrl(website, mode: LaunchMode.externalApplication),
              icon: const Icon(Icons.open_in_new_rounded, size: 16),
              label: Text(website.host),
              style: OutlinedButton.styleFrom(
                backgroundColor: colors.surface,
                foregroundColor: colors.onSurface,
                side: BorderSide(color: colors.outline),
                padding: const EdgeInsets.symmetric(
                  horizontal: 18,
                  vertical: 14,
                ),
              ),
            ),
          ],
          const SizedBox(height: 20),
          Align(
            alignment: Alignment.centerLeft,
            child: Text(
              'Articles',
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w800),
            ),
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }
}
