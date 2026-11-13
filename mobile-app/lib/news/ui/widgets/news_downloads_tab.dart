import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:freecodecamp/news/controllers/bookmarks_controller.dart';
import 'package:freecodecamp/news/models/bookmarked_post_model.dart';
import 'package:freecodecamp/news/ui/widgets/image.dart';
import 'package:freecodecamp/routing/news.dart';
import 'package:freecodecamp/utils/storage_format.dart';
import 'package:freecodecamp/widgets/download_management_list.dart';
import 'package:freecodecamp/widgets/error_retry.dart';

class NewsDownloadsTab extends ConsumerWidget {
  const NewsDownloadsTab({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final bookmarks = ref.watch(newsBookmarksProvider);
    final colors = Theme.of(context).colorScheme;
    return bookmarks.when(
      skipLoadingOnReload: true,
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, stack) => ErrorRetry(
        message: 'Unable to load downloads.',
        onRetry: () => ref.invalidate(newsBookmarksProvider),
      ),
      data: (posts) => DownloadManagementList(
        items: [for (final post in posts) post.id],
        onRemove: (ids) => ref
            .read(newsBookmarksProvider.notifier)
            .removeBookmarks(ids.toSet()),
        emptyState: const NewsDownloadsEmptyState(),
        footer: Text(
          'Removing an article here also removes its bookmark.',
          style: TextStyle(
            fontSize: 13,
            height: 1.45,
            color: colors.onSurfaceVariant,
          ),
        ),
        itemBuilder: (context, index, managing, selected, onSelect) =>
            NewsDownloadTile(
              post: posts[index],
              managing: managing,
              selected: selected,
              onSelect: onSelect,
            ),
      ),
    );
  }
}

class NewsDownloadTile extends StatelessWidget {
  const NewsDownloadTile({
    super.key,
    required this.post,
    required this.managing,
    required this.selected,
    required this.onSelect,
  });

  final BookmarkedPost post;
  final bool managing;
  final bool selected;
  final VoidCallback? onSelect;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final size = post.sizeBytes;
    final details = [
      post.authorName,
      if (size != null) formatStorageBytes(size),
    ].join(' · ');
    return InkWell(
      onTap: managing
          ? onSelect
          : () =>
                NewsBookmarkPostRoute(id: post.id, $extra: post).push(context),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 18),
        child: Row(
          children: [
            NewsImage(
              url: post.coverImageUrl,
              width: 52,
              height: 52,
              radius: 8,
            ),
            const SizedBox(width: 14),
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
                  const SizedBox(height: 4),
                  Text(
                    details,
                    style: TextStyle(
                      fontSize: 13,
                      color: colors.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            if (managing)
              Checkbox(
                value: selected,
                onChanged: onSelect == null ? null : (_) => onSelect!(),
              )
            else
              Icon(Icons.chevron_right_rounded, color: colors.onSurfaceVariant),
          ],
        ),
      ),
    );
  }
}

class NewsDownloadsEmptyState extends StatelessWidget {
  const NewsDownloadsEmptyState({super.key});

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.symmetric(vertical: 48, horizontal: 20),
    child: Column(
      children: [
        Icon(
          Icons.bookmark_border_rounded,
          size: 44,
          color: Theme.of(context).colorScheme.primary,
        ),
        const SizedBox(height: 14),
        const Text(
          'No downloaded articles',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.w900),
        ),
        const SizedBox(height: 8),
        Text(
          'Tap the bookmark on an article to save it for offline reading.',
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Theme.of(context).colorScheme.onSurfaceVariant,
          ),
        ),
        const SizedBox(height: 20),
        FilledButton(
          onPressed: () => const NewsFeedRoute().go(context),
          child: const Text('Browse articles'),
        ),
      ],
    ),
  );
}
