import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:freecodecamp/fcc_theme.dart';
import 'package:freecodecamp/news/controllers/bookmarks_controller.dart';
import 'package:freecodecamp/news/models/bookmarked_post_model.dart';
import 'package:freecodecamp/news/ui/widgets/news_image.dart';
import 'package:freecodecamp/news/ui/widgets/offline_banner.dart';
import 'package:freecodecamp/routing/news.dart';
import 'package:freecodecamp/widgets/error_retry.dart';
import 'package:go_router/go_router.dart';
import 'package:jiffy/jiffy.dart';

class NewsBookmarkFeedView extends ConsumerWidget {
  const NewsBookmarkFeedView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final bookmarks = ref.watch(newsBookmarksProvider);
    final colors = Theme.of(context).colorScheme;
    return bookmarks.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (_, _) => ErrorRetry(
        message: 'Unable to load saved articles.',
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
            if (posts.isEmpty)
              const NewsSavedEmptyState()
            else ...[
              const OfflineBanner(),
              const SizedBox(height: 16),
              Container(
                clipBehavior: Clip.antiAlias,
                decoration: BoxDecoration(
                  color: colors.surface,
                  border: Border.all(color: colors.outlineVariant),
                  borderRadius: BorderRadius.circular(16),
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
            content: Text('Unable to remove saved article. Please try again.'),
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
            NewsImage(
              url: post.coverImageUrl,
              width: 64,
              height: 64,
              radius: 10,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    post.title,
                    style: const TextStyle(
                      fontSize: 15,
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
              tooltip: 'Remove saved article',
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

class NewsSavedEmptyState extends StatelessWidget {
  const NewsSavedEmptyState({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return CustomPaint(
      foregroundPainter: _DashedCardBorder(colors.outlineVariant),
      child: Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: colors.surface,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          children: [
            Container(
              width: 64,
              height: 64,
              decoration: BoxDecoration(
                color: colors.primaryContainer,
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.bookmark_border_rounded,
                color: FccDesignColors.of(context).accentText,
                size: 40,
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'No saved articles',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.w900),
            ),
            const SizedBox(height: 8),
            Text(
              'Tap the bookmark on an article to save it.',
              textAlign: TextAlign.center,
              style: TextStyle(color: colors.onSurfaceVariant, height: 1.5),
            ),
            const SizedBox(height: 16),
            FilledButton(
              onPressed: () => context.go(newsFeedPath),
              child: const Text('Browse articles'),
            ),
          ],
        ),
      ),
    );
  }
}

class _DashedCardBorder extends CustomPainter {
  const _DashedCardBorder(this.color);
  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final path = Path()
      ..addRRect(
        RRect.fromRectAndRadius(
          (Offset.zero & size).deflate(.5),
          const Radius.circular(16),
        ),
      );
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1;
    for (final metric in path.computeMetrics()) {
      for (double offset = 0; offset < metric.length; offset += 10) {
        canvas.drawPath(metric.extractPath(offset, offset + 6), paint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant _DashedCardBorder oldDelegate) =>
      color != oldDelegate.color;
}
