import 'package:flutter/material.dart';
import 'package:freecodecamp/ui/views/news/news-bookmark/news_bookmark_viewmodel.dart';
import 'package:stacked/stacked.dart';
import 'news_bookmark_view.dart';

class NewsBookmarkFeedView extends StatelessWidget {
  const NewsBookmarkFeedView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<NewsBookmarkModel>.reactive(
        viewModelBuilder: () => NewsBookmarkModel(),
        onModelReady: (model) async => model.hasBookmarkedArticles(),
        builder: (context, model, child) => Scaffold(
            backgroundColor: const Color.fromRGBO(0x2A, 0x2A, 0x40, 1),
            body: model.userHasBookmarkedArticles
                ? populateListViewModel(model)
                : const Center(
                    child: Text(
                    'Bookmark articles to view them here',
                    textAlign: TextAlign.center,
                  ))));
  }
}

ListView populateListViewModel(NewsBookmarkModel model) {
  if (model.bookMarkedArticles.isEmpty) {
    model.updateListView();
  }
  return ListView.builder(
      itemCount: model.count,
      itemBuilder: (context, index) {
        return ConstrainedBox(
            key: Key('bookmark_article_$index'),
            constraints: const BoxConstraints(minHeight: 150),
            child: Container(
                decoration: const BoxDecoration(
                    border: Border(
                        bottom: BorderSide(width: 2, color: Colors.white))),
                child: InkWell(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => NewsBookmarkPostView(
                                article: model.bookMarkedArticles[index])));
                  },
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Expanded(
                            flex: 8,
                            child: Padding(
                              padding: const EdgeInsets.all(25.0),
                              child: Text(
                                model.bookMarkedArticles[index].articleTitle,
                                style: const TextStyle(fontSize: 18),
                              ),
                            ),
                          ),
                          const Expanded(
                              flex: 2,
                              child: Icon(
                                Icons.arrow_forward_ios,
                              ))
                        ],
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.all(25.0),
                              child: Text(
                                'Written by: ' +
                                    model.bookMarkedArticles[index].authorName,
                              ),
                            ),
                          )
                        ],
                      )
                    ],
                  ),
                )));
      });
}
