import 'package:flutter/material.dart';
import 'package:freecodecamp/ui/views/news/news-tutorial/news_tutorial_view.dart';
import 'package:freecodecamp/ui/views/news/news-bookmark/news_bookmark_model.dart';
import 'package:stacked/stacked.dart';

class NewsBookmarkViewWidget extends StatelessWidget {
  const NewsBookmarkViewWidget({Key? key, required this.tutorial})
      : super(key: key);

  final dynamic tutorial;

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<NewsBookmarkModel>.reactive(
        viewModelBuilder: () => NewsBookmarkModel(),
        onModelReady: (model) => model.isTutorialBookmarked(tutorial),
        builder: (context, model, child) => BottomButton(
              key: const Key('bookmark_btn'),
              label: model.bookmarked ? 'Bookmarked' : 'Bookmark',
              icon: model.bookmarked
                  ? Icons.bookmark_added
                  : Icons.bookmark_add_outlined,
              onPressed: () {
                model.bookmarkAndUnbookmark(tutorial);
              },
              rightSided: false,
            ));
  }
}
