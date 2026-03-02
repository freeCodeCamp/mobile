import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:freecodecamp/extensions/i18n_extension.dart';
import 'package:freecodecamp/ui/views/news/news-bookmark/news_bookmark_viewmodel.dart';
import 'package:freecodecamp/ui/views/news/news-tutorial/news_tutorial_view.dart';

class NewsBookmarkViewWidget extends ConsumerStatefulWidget {
  const NewsBookmarkViewWidget({
    super.key,
    required this.tutorial,
  });

  final dynamic tutorial;

  @override
  ConsumerState<NewsBookmarkViewWidget> createState() =>
      _NewsBookmarkViewWidgetState();
}

class _NewsBookmarkViewWidgetState
    extends ConsumerState<NewsBookmarkViewWidget> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final notifier = ref.read(newsBookmarkProvider.notifier);
      await notifier.initDB();
      await notifier.isTutorialBookmarked(widget.tutorial);
    });
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(newsBookmarkProvider);
    final notifier = ref.read(newsBookmarkProvider.notifier);

    return BottomButton(
      key: const Key('bookmark_btn'),
      label: state.isBookmarked
          ? context.t.tutorial_bookmarked
          : context.t.tutorial_bookmark,
      icon: state.isBookmarked
          ? Icons.bookmark_added
          : Icons.bookmark_add_outlined,
      onPressed: () {
        notifier.bookmarkAndUnbookmark(widget.tutorial);
      },
      rightSided: false,
    );
  }
}
