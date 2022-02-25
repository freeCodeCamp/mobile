import 'package:flutter/material.dart';
import 'package:freecodecamp/models/news/bookmarked_article_model.dart';
import 'package:freecodecamp/ui/views/news/news-article/news_article_viewmodel.dart';
import 'package:freecodecamp/ui/views/news/news-bookmark/news_bookmark_viewmodel.dart';
import 'package:freecodecamp/ui/views/news/news-bookmark/news_bookmark_widget.dart';
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
            backgroundColor: const Color(0xFF0a0a23),
            body: SafeArea(
              child: CustomScrollView(
                slivers: [
                  const SliverAppBar(
                    title: Text('BOOKMARKED ARTICLE'),
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
                            child: NewsBookmarkViewWidget(article: article),
                          )),
                        ],
                      ),
                    ),
                  ),
                  lazyLoadHtml(context, article)
                ],
              ),
            )));
  }

  SliverList lazyLoadHtml(BuildContext context, BookmarkedArticle article) {
    var htmlToList = NewsArticleViewModel.initLazyLoading(
        article.articleText, context, article);
    return SliverList(
        delegate: SliverChildBuilderDelegate(((context, index) {
      return Row(
        children: [Expanded(child: htmlToList[index])],
      );
    }), childCount: htmlToList.length));
  }
}
