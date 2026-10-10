import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mobile_app_new/news/models/bookmarked_post_model.dart';
import 'package:mobile_app_new/news/models/post_model.dart';
import 'package:mobile_app_new/news/controllers/bookmarks_controller.dart';
import 'package:mobile_app_new/news/services/api_service.dart';

/// Saves the full article, including HTML, so list bookmarks work offline too.
class BookmarkButton extends ConsumerStatefulWidget {
  BookmarkButton({super.key, required Post post})
    : post = post,
      id = post.id,
      slug = post.slug;

  const BookmarkButton.forSummary({
    super.key,
    required this.id,
    required this.slug,
  }) : post = null;

  final Post? post;
  final String id;
  final String slug;

  @override
  ConsumerState<BookmarkButton> createState() => _BookmarkButtonState();
}

class _BookmarkButtonState extends ConsumerState<BookmarkButton> {
  bool _saving = false;

  Future<void> _toggle() async {
    setState(() => _saving = true);
    try {
      final notifier = ref.read(newsBookmarksProvider.notifier);
      final post = widget.post;
      if (post != null) {
        await notifier.toggle(BookmarkedPost.fromPost(post));
      } else {
        final api = ref.read(newsApiServiceProvider);
        final slug = widget.slug;
        await notifier.toggleById(
          widget.id,
          () async => BookmarkedPost.fromPost(await api.getPostBySlug(slug)),
        );
      }
    } catch (_) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Unable to update saved tutorial. Please try again.'),
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final bookmarked = ref.watch(
      newsBookmarksProvider.select(
        (bookmarks) => bookmarks.value?.any((b) => b.id == widget.id) ?? false,
      ),
    );
    return IconButton(
      tooltip: bookmarked
          ? 'Remove saved tutorial'
          : 'Save tutorial for offline reading',
      onPressed: _saving ? null : _toggle,
      color: bookmarked
          ? Theme.of(context).colorScheme.primary
          : Theme.of(context).colorScheme.onSurfaceVariant,
      icon: _saving
          ? const SizedBox.square(
              dimension: 20,
              child: CircularProgressIndicator(strokeWidth: 2),
            )
          : Icon(
              bookmarked
                  ? Icons.bookmark_rounded
                  : Icons.bookmark_border_rounded,
            ),
    );
  }
}
