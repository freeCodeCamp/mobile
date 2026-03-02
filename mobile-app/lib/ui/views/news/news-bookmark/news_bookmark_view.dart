import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:freecodecamp/extensions/i18n_extension.dart';
import 'package:freecodecamp/models/news/bookmarked_tutorial_model.dart';
import 'package:freecodecamp/ui/views/news/news-bookmark/news_bookmark_viewmodel.dart';
import 'package:freecodecamp/ui/views/news/news-tutorial/news_tutorial_viewmodel.dart';
import 'package:freecodecamp/ui/views/news/widgets/back_to_top_button.dart';

class NewsBookmarkTutorialView extends ConsumerStatefulWidget {
  final BookmarkedTutorial tutorial;

  const NewsBookmarkTutorialView({
    super.key,
    required this.tutorial,
  });

  @override
  ConsumerState<NewsBookmarkTutorialView> createState() =>
      _NewsBookmarkTutorialViewState();
}

class _NewsBookmarkTutorialViewState
    extends ConsumerState<NewsBookmarkTutorialView> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final notifier = ref.read(newsBookmarkProvider.notifier);
      await notifier.initDB();
      await notifier.isTutorialBookmarked(widget.tutorial);
      await notifier.goToTopButtonHandler();
    });
  }

  @override
  void dispose() {
    // trigger updateListView when view is disposed
    ref.read(newsBookmarkProvider.notifier).updateListView();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(newsBookmarkProvider);
    final notifier = ref.read(newsBookmarkProvider.notifier);

    return Scaffold(
      backgroundColor: const Color(0xFF0a0a23),
      body: SafeArea(
        child: CustomScrollView(
          controller: notifier.scrollController,
          slivers: [
            SliverAppBar(
              title: Text(
                context.t.tutorial_bookmark_title,
              ),
            ),
            SliverAppBar(
              pinned: true,
              backgroundColor: const Color.fromRGBO(0x2A, 0x2A, 0x40, 1),
              automaticallyImplyLeading: false,
              bottom: PreferredSize(
                preferredSize: const Size.fromHeight(8),
                child: Row(
                  children: [
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: ElevatedButton.icon(
                          onPressed: () {
                            notifier.bookmarkAndUnbookmark(widget.tutorial);
                          },
                          icon: state.isBookmarked
                              ? const Icon(Icons.bookmark_added)
                              : const Icon(Icons.bookmark_add_outlined),
                          label: Text(
                            state.isBookmarked
                                ? context.t.tutorial_bookmarked
                                : context.t.tutorial_bookmark,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            lazyLoadHtml(context, widget.tutorial)
          ],
        ),
      ),
      floatingActionButton: state.gotoTopButtonVisible
          ? BackToTopButton(
              onPressed: () => notifier.goToTop(),
            )
          : null,
      floatingActionButtonAnimator: null,
    );
  }

  SliverList lazyLoadHtml(
    BuildContext context,
    BookmarkedTutorial tutorial,
  ) {
    NewsTutorialViewModel localModel = NewsTutorialViewModel();
    var htmlToList = localModel.initLazyLoading(
      tutorial.tutorialText,
      context,
      tutorial,
    );

    return SliverList(
      delegate: SliverChildBuilderDelegate(((context, index) {
        return Row(
          children: [
            Expanded(
              child: htmlToList[index],
            ),
          ],
        );
      }), childCount: htmlToList.length),
    );
  }
}
