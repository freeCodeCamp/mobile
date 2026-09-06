import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mobile_app_new/fcc_theme.dart';
import 'package:mobile_app_new/news/models/bookmarked_post_model.dart';
import 'package:mobile_app_new/widgets/html_handler/html_handler.dart';
import 'package:mobile_app_new/news/ui/widgets/back_to_top_button.dart';
import 'package:mobile_app_new/news/ui/bookmark_feed/bookmark_feed_viewmodel.dart';

// Reads the HTML stored at bookmark time, so it works with no network.
class NewsBookmarkPostView extends ConsumerStatefulWidget {
  const NewsBookmarkPostView({super.key, required this.post});

  final BookmarkedPost post;

  @override
  ConsumerState<NewsBookmarkPostView> createState() =>
      _NewsBookmarkPostViewState();
}

class _NewsBookmarkPostViewState extends ConsumerState<NewsBookmarkPostView> {
  final ScrollController _scrollController = ScrollController();

  bool _showToTopButton = false;

  // NOTE: Parsed and stored here to avoid re-parsing on every build
  List<Widget>? _htmlWidgets;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_handleToTopButtonVisibility);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _handleToTopButtonVisibility() {
    final shouldShow = _scrollController.offset >= 100;
    if (shouldShow == _showToTopButton) return;
    setState(() => _showToTopButton = shouldShow);
  }

  void _goToTop() {
    _scrollController.animateTo(
      0,
      duration: const Duration(milliseconds: 1000),
      curve: Curves.easeInOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    final post = widget.post;

    final isBookmarked = ref.watch(
      newsBookmarksProvider.select(
        (bookmarks) => bookmarks.value?.any((b) => b.id == post.id) ?? false,
      ),
    );

    final htmlWidgets = _htmlWidgets ??= HTMLParser(
      context: context,
    ).parse(post.text);

    return Scaffold(
      backgroundColor: FccColors.gray90,
      floatingActionButton: _showToTopButton
          ? BackToTopButton(onPressed: _goToTop)
          : null,
      body: SafeArea(
        child: CustomScrollView(
          controller: _scrollController,
          slivers: [
            SliverAppBar(title: Text(post.title)),
            SliverAppBar(
              pinned: true,
              backgroundColor: FccColors.gray80,
              automaticallyImplyLeading: false,
              bottom: PreferredSize(
                preferredSize: const Size.fromHeight(8),
                child: Padding(
                  padding: const EdgeInsets.all(8),
                  child: SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: () =>
                          ref.read(newsBookmarksProvider.notifier).toggle(post),
                      icon: Icon(
                        isBookmarked
                            ? Icons.bookmark_added
                            : Icons.bookmark_add_outlined,
                      ),
                      label: Text(isBookmarked ? 'Bookmarked' : 'Bookmark'),
                    ),
                  ),
                ),
              ),
            ),
            SliverList.builder(
              itemCount: htmlWidgets.length,
              itemBuilder: (context, index) =>
                  Row(children: [Expanded(child: htmlWidgets[index])]),
            ),
          ],
        ),
      ),
    );
  }
}
