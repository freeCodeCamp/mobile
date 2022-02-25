import 'package:flutter/material.dart';
import 'package:freecodecamp/models/news/bookmarked_article_model.dart';
import 'package:freecodecamp/ui/views/news/news-article/news_article_viewmodel.dart';
import 'package:freecodecamp/ui/views/news/news-bookmark/news_bookmark_viewmodel.dart';
import 'package:stacked/stacked.dart';

class NewsBookmarkPostView extends StatelessWidget {
  final BookmarkedArticle article;

  const NewsBookmarkPostView({Key? key, required this.article})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<NewsBookmarkModel>.reactive(
        viewModelBuilder: () => NewsBookmarkModel(),
        onModelReady: (model) => model.isArticleBookmarked(article),
        onDispose: (model) => model.updateListView(),
        builder: (context, model, child) => Scaffold(
            appBar: AppBar(
              title: const Text('BOOKMARKED ARTICLE'),
            ),
            backgroundColor: const Color(0xFF0a0a23),
            body: lazyLoadHtml(context, article)));
  }

  ListView lazyLoadHtml(BuildContext context, BookmarkedArticle article) {
    var htmlToList = NewsArticleViewModel.initLazyLoading(
        article.articleText, context, article);
    return ListView.builder(
        shrinkWrap: true,
        itemCount: htmlToList.length,
        physics: const ClampingScrollPhysics(),
        itemBuilder: (BuildContext context, int i) {
          return Row(
            children: [
              Expanded(child: htmlToList[i]),
            ],
          );
        });
  }
}
