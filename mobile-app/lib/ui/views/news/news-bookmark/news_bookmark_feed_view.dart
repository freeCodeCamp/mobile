import 'package:flutter/material.dart' show BuildContext, Center, Color, Colors, Divider, EdgeInsets, Icon, Icons, Key, ListTile, ListView, Padding, RefreshIndicator, Scaffold, StatelessWidget, Text, TextAlign, Widget;
import 'package:freecodecamp/ui/views/news/news-bookmark/news_bookmark_viewmodel.dart';
import 'package:stacked/stacked.dart';

class NewsBookmarkFeedView extends StatelessWidget {
  const NewsBookmarkFeedView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<NewsBookmarkModel>.reactive(
        viewModelBuilder: () => NewsBookmarkModel(),
        onModelReady: (model) async {
          model.hasBookmarkedArticles();
          model.updateListView();
        },
        builder: (context, model, child) => Scaffold(
            backgroundColor: const Color.fromRGBO(0x2A, 0x2A, 0x40, 1),
            body: RefreshIndicator(
              backgroundColor: const Color(0xFF0a0a23),
              color: Colors.white,
              onRefresh: () {
                return model.refresh();
              },
              child: model.userHasBookmarkedArticles
                  ? populateListViewModel(model)
                  : const Center(
                      child: Text(
                      'Bookmark articles to view them here',
                      textAlign: TextAlign.center,
                    )),
            )));
  }
}

ListView populateListViewModel(NewsBookmarkModel model) {
  return ListView.separated(
      itemCount: model.count,
      separatorBuilder: (BuildContext context, int i) => const Divider(
            color: Colors.white,
          ),
      itemBuilder: (context, index) {
        var article = model.bookMarkedArticles[index];

        return ListTile(
            key: Key('bookmark_article_$index'),
            title: Text(article.articleTitle),
            trailing: const Icon(Icons.arrow_forward_ios_sharp),
            subtitle: Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: Text('Written by: ${article.authorName}'),
            ),
            onTap: () {
              model.routeToBookmarkedArticle(article);
            },
            contentPadding: const EdgeInsets.all(16),
            minVerticalPadding: 8);
      });
}
