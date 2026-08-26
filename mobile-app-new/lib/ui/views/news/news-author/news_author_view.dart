import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:mobile_app_new/fcc_theme.dart';
import 'package:mobile_app_new/models/news/author_model.dart';
import 'package:mobile_app_new/ui/views/news/news-author/news_author_viewmodel.dart';
import 'package:mobile_app_new/ui/views/news/widgets/post-feed-list/post_feed_list.dart';

class NewsAuthorView extends ConsumerWidget {
  const NewsAuthorView({super.key, required this.username, this.author});

  final String username;
  final Author? author;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final author = this.author;

    return Scaffold(
      appBar: AppBar(title: Text(author?.name ?? username)),
      backgroundColor: FccColors.gray90,
      body: author != null
          ? _buildFeed(author)
          : ref
                .watch(newsAuthorProvider(username))
                .when(
                  loading: () =>
                      const Center(child: CircularProgressIndicator()),
                  error: (error, stack) => _ErrorView(
                    onRetry: () => ref.invalidate(newsAuthorProvider(username)),
                  ),
                  data: _buildFeed,
                ),
    );
  }

  Widget _buildFeed(Author author) => PostFeedList(
    authorId: author.id,
    header: _AuthorDetails(author: author),
  );
}

class _ErrorView extends StatelessWidget {
  const _ErrorView({required this.onRetry});

  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text(
            'Unable to load author.',
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 12),
          TextButton(onPressed: onRetry, child: const Text('Retry')),
        ],
      ),
    );
  }
}

class _AuthorDetails extends StatelessWidget {
  const _AuthorDetails({required this.author});

  final Author author;

  @override
  Widget build(BuildContext context) {
    final location = author.location;
    final bio = author.bio?.text;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 32),
      child: Column(
        children: [
          _buildProfilePicture(),
          const SizedBox(height: 16),
          Text(
            author.name,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
          ),
          if (location != null && location.isNotEmpty) ...[
            const SizedBox(height: 4),
            Text(location, style: const TextStyle(fontSize: 16)),
          ],
          if (bio != null && bio.isNotEmpty) ...[
            const SizedBox(height: 16),
            Text(
              bio,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 16),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildProfilePicture() {
    final imageUrl = author.profilePicture;

    return Container(
      width: 160,
      height: 160,
      decoration: const BoxDecoration(
        shape: BoxShape.circle,
        color: FccColors.gray80,
        border: Border.fromBorderSide(
          BorderSide(color: Colors.white, width: 2),
        ),
      ),
      child: ClipOval(
        child: imageUrl == null
            ? Image.asset(
                'assets/images/placeholder-profile-img.png',
                fit: BoxFit.cover,
              )
            : CachedNetworkImage(
                imageUrl: imageUrl,
                fit: BoxFit.cover,
                placeholder: (context, url) =>
                    const ColoredBox(color: FccColors.gray80),
                errorWidget: (context, url, error) => Image.asset(
                  'assets/images/placeholder-profile-img.png',
                  fit: BoxFit.cover,
                ),
              ),
      ),
    );
  }
}
