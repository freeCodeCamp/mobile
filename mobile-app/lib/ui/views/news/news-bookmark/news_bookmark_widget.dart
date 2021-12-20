import 'package:flutter/material.dart';
import 'package:freecodecamp/models/article_model.dart';
import 'package:freecodecamp/ui/views/news/news-bookmark/news_bookmark_viewmodel.dart';
import 'package:stacked/stacked.dart';

class NewsBookmarkViewWidget extends StatelessWidget {
  // ignore: prefer_const_constructors_in_immutables
  NewsBookmarkViewWidget({Key? key, required this.article}) : super(key: key);
  final Article article;
  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<NewsBookmarkModel>.reactive(
        viewModelBuilder: () => NewsBookmarkModel(),
        onModelReady: (model) => model.isArticleBookmarked(article),
        builder: (context, model, child) => Padding(
              padding: const EdgeInsets.all(8),
              child: TextButton.icon(
                onPressed: () {
                  model.bookmarkAndUnbookmark(article);
                },
                icon: Icon(
                    model.bookmarked
                        ? Icons.bookmark_sharp
                        : Icons.bookmark_border_sharp,
                    color: Colors.white),
                label: Text(
                  model.bookmarked
                      ? 'Article is bookmarked'
                      : 'Bookmark for offline usage',
                ),
              ),
            ));
  }
}
