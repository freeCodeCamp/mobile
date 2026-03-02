import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:freecodecamp/extensions/i18n_extension.dart';
import 'package:freecodecamp/models/news/bookmarked_tutorial_model.dart';
import 'package:freecodecamp/ui/views/news/news-bookmark/news_bookmark_viewmodel.dart';

class NewsBookmarkFeedView extends ConsumerStatefulWidget {
  const NewsBookmarkFeedView({
    super.key,
  });

  @override
  ConsumerState<NewsBookmarkFeedView> createState() =>
      _NewsBookmarkFeedViewState();
}

class _NewsBookmarkFeedViewState extends ConsumerState<NewsBookmarkFeedView> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final notifier = ref.read(newsBookmarkProvider.notifier);
      await notifier.initDB();
      await notifier.hasBookmarkedTutorials();
      await notifier.updateListView();
    });
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(newsBookmarkProvider);
    final notifier = ref.read(newsBookmarkProvider.notifier);

    return Scaffold(
      backgroundColor: const Color.fromRGBO(0x2A, 0x2A, 0x40, 1),
      body: RefreshIndicator(
        backgroundColor: const Color(0xFF0a0a23),
        color: Colors.white,
        onRefresh: () {
          return notifier.refresh();
        },
        child: state.userHasBookmarkedTutorials
            ? populateListView(state.tutorials, state.count, notifier)
            : Center(
                child: Text(
                  context.t.tutorial_no_bookmarks,
                  textAlign: TextAlign.center,
                ),
              ),
      ),
    );
  }
}

ListView populateListView(
  List<BookmarkedTutorial> tutorials,
  int count,
  NewsBookmarkNotifier notifier,
) {
  return ListView.separated(
    itemCount: count,
    separatorBuilder: (BuildContext context, int i) => const Divider(
      color: Colors.white,
    ),
    itemBuilder: (context, index) {
      var tutorial = tutorials[index];

      return ListTile(
        key: Key('bookmark_tutorial_$index'),
        title: Text(tutorial.tutorialTitle),
        trailing: const Icon(Icons.arrow_forward_ios_sharp),
        subtitle: Padding(
          padding: const EdgeInsets.only(top: 8.0),
          child: Text('Written by: ${tutorial.authorName}'),
        ),
        onTap: () {
          notifier.routeToBookmarkedTutorial(tutorial);
        },
        contentPadding: const EdgeInsets.all(16),
        minVerticalPadding: 8,
      );
    },
  );
}
