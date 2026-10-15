import 'package:flutter/material.dart';
import 'package:jiffy/jiffy.dart';
import 'package:mobile_app_new/news/ui/widgets/news_image.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mobile_app_new/news/models/bookmarked_post_model.dart';
import 'package:mobile_app_new/routing/news.dart';
import 'package:mobile_app_new/news/controllers/bookmarks_controller.dart';
import 'package:mobile_app_new/news/ui/widgets/offline_banner.dart';
import 'package:mobile_app_new/widgets/error_retry.dart';

class NewsBookmarkFeedView extends ConsumerWidget {
  const NewsBookmarkFeedView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final bookmarks = ref.watch(newsBookmarksProvider);
    final colors = Theme.of(context).colorScheme;
    return bookmarks.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (_, _) => ErrorRetry(
        message: 'Unable to load saved tutorials.',
        onRetry: () => ref.invalidate(newsBookmarksProvider),
      ),
      data: (posts) => RefreshIndicator(
        onRefresh: () async {
          ref.invalidate(newsBookmarksProvider);
          await ref.read(newsBookmarksProvider.future);
        },
        child: ListView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.all(20),
          children: [
            const OfflineBanner(),
            const SizedBox(height: 16),
            if (posts.isEmpty)
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 72,
                ),
                child: Column(
                  children: [
                    Icon(
                      Icons.bookmark_border_rounded,
                      color: colors.primary,
                      size: 40,
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      'Your reading list starts here',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Save a tutorial to keep it handy, even when you’re offline.',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: colors.onSurfaceVariant,
                        height: 1.5,
                      ),
                    ),
                  ],
                ),
              )
            else
              Container(
                clipBehavior: Clip.antiAlias,
                decoration: BoxDecoration(
                  color: colors.surface,
                  border: Border.all(color: colors.outlineVariant),
                  borderRadius: BorderRadius.circular(18),
                ),
                child: Column(
                  children: [
                    for (var index = 0; index < posts.length; index++) ...[
                      if (index > 0)
                        Divider(height: 1, color: colors.outlineVariant),
                      _SavedTutorial(
                        key: ValueKey(posts[index].id),
                        post: posts[index],
                      ),
                    ],
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _SavedTutorial extends ConsumerStatefulWidget {
  const _SavedTutorial({super.key, required this.post});

  final BookmarkedPost post;

  @override
  ConsumerState<_SavedTutorial> createState() => _SavedTutorialState();
}

class _SavedTutorialState extends ConsumerState<_SavedTutorial> {
  bool _removing = false;

  Future<void> _remove() async {
    setState(() => _removing = true);
    try {
      await ref.read(newsBookmarksProvider.notifier).toggle(widget.post);
    } catch (_) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Unable to remove saved tutorial. Please try again.'),
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _removing = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final post = widget.post;
    return InkWell(
      onTap: () =>
          NewsBookmarkPostRoute(id: post.id, $extra: post).push(context),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(12, 14, 4, 14),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            NewsImage(url: post.coverImageUrl, width: 64, height: 72),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    post.title,
                    style: const TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.w700,
                      height: 1.3,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    [
                      post.authorName,
                      if (post.savedAt != null) _savedLabel(post.savedAt!),
                    ].join(' · '),
                    style: TextStyle(
                      fontSize: 13,
                      color: colors.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ),
            IconButton(
              tooltip: 'Remove saved tutorial',
              onPressed: _removing ? null : _remove,
              icon: const Icon(Icons.bookmark_rounded),
              color: colors.primary,
            ),
          ],
        ),
      ),
    );
  }
}

String _savedLabel(DateTime value) {
  final saved = value.toLocal();
  final now = DateTime.now();
  if (saved.year == now.year &&
      saved.month == now.month &&
      saved.day == now.day) {
    return 'Saved today';
  }
  return 'Saved ${Jiffy.parseFromDateTime(saved).format(pattern: 'MMM d, yyyy')}';
}
