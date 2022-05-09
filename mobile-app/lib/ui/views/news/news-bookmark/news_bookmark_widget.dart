import 'package:flutter/material.dart';
import 'package:freecodecamp/ui/views/news/news-article/news_article_view.dart';
import 'package:freecodecamp/ui/views/news/news-bookmark/news_bookmark_viewmodel.dart';
import 'package:stacked/stacked.dart';

class NewsBookmarkViewWidget extends StatelessWidget {
  const NewsBookmarkViewWidget({Key? key, required this.article})
      : super(key: key);

  final dynamic article;

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<NewsBookmarkModel>.reactive(
        viewModelBuilder: () => NewsBookmarkModel(),
        onModelReady: (model) => model.isArticleBookmarked(article),
        builder: (context, model, child) => BottomButton(
              key: const Key('bookmark_btn'),
              label: model.bookmarked ? 'Bookmarked' : 'Bookmark',
              icon: model.bookmarked
                  ? Icons.bookmark_sharp
                  : Icons.bookmark_border_sharp,
              onPressed: () {
                model.bookmarkAndUnbookmark(article);
              },
              rightSided: false,
            ));
  }
}
