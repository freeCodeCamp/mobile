import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mobile_app_new/news/models/bookmarked_post_model.dart';
import 'package:mobile_app_new/news/controllers/bookmarks_controller.dart';
import 'package:mobile_app_new/news/ui/widgets/article_reader.dart';

// Reads the stored HTML without fetching the live article.
class NewsBookmarkPostView extends ConsumerStatefulWidget {
  const NewsBookmarkPostView({super.key, required this.post});

  final BookmarkedPost post;

  @override
  ConsumerState<NewsBookmarkPostView> createState() =>
      _NewsBookmarkPostViewState();
}

class _NewsBookmarkPostViewState extends ConsumerState<NewsBookmarkPostView> {
  bool _saving = false;

  Future<void> _toggle() async {
    setState(() => _saving = true);
    try {
      await ref.read(newsBookmarksProvider.notifier).toggle(widget.post);
    } catch (_) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Unable to update saved article. Please try again.'),
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final post = widget.post;
    final colors = Theme.of(context).colorScheme;
    final isBookmarked = ref.watch(
      newsBookmarksProvider.select(
        (bookmarks) => bookmarks.value?.any((b) => b.id == post.id) ?? false,
      ),
    );
    return ArticleReader(
      html: post.text,
      bookmarkButton: IconButton(
        tooltip: isBookmarked ? 'Remove saved article' : 'Save article',
        onPressed: _saving ? null : _toggle,
        color: isBookmarked ? colors.primary : colors.onSurfaceVariant,
        icon: Icon(
          isBookmarked ? Icons.bookmark_rounded : Icons.bookmark_border_rounded,
        ),
      ),
      header: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              post.title,
              style: const TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.w800,
                height: 1.25,
              ),
            ),
            const SizedBox(height: 14),
            Text(
              post.authorName,
              style: TextStyle(color: colors.onSurfaceVariant, fontSize: 15),
            ),
          ],
        ),
      ),
    );
  }
}
