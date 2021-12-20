import 'package:flutter/cupertino.dart';
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

  return ListView.separated(
      separatorBuilder: (context, int i) => const Divider(
            color: Color.fromRGBO(0x42, 0x42, 0x55, 1),
            thickness: 2,
            height: 5,
          ),
      itemCount: model.count,
      itemBuilder: (context, index) {
        var bookmark = model.bookMarkedArticles[index];

        return ListTile(
          title: Text(
            bookmark.articleTitle,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(color: Colors.white),
          ),
          subtitle: Text(
            'Written by: ' + bookmark.authorName,
            style: const TextStyle(color: Colors.white, height: 3),
          ),
          onTap: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) =>
                        NewsBookmarkPostView(article: bookmark)));
          },
          onLongPress: () {
            showMenu(
              context: context,
              items: <PopupMenuItem>[
                PopupMenuItem(
                  child: Row(
                    children: const <Widget>[
                      Icon(
                        Icons.bookmark,
                        color: Colors.white,
                      ),
                      Text(
                        "Unbookmark",
                        style: TextStyle(color: Colors.white),
                      ),
                    ],
                  ),
                )
              ],
              position: RelativeRect.fill,
              color: const Color(0xFF0a0a23),
            );
          },
          isThreeLine: true,
          dense: false,
          trailing: const Icon(
            Icons.arrow_forward_ios,
            color: Colors.white,
          ),
        );
      });
}
