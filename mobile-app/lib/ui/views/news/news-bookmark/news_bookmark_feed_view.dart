import 'package:flutter/material.dart';
import 'package:freecodecamp/ui/views/news/news-bookmark/news_bookmark_viewmodel.dart';
import 'package:stacked/stacked.dart';

class NewsBookmarkFeedView extends StatelessWidget {
  const NewsBookmarkFeedView({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<NewsBookmarkViewModel>.reactive(
      viewModelBuilder: () => NewsBookmarkViewModel(),
      onViewModelReady: (model) async {
        model.hasBookmarkedTutorials();
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
          child: model.userHasBookmarkedTutorials
              ? populateListViewModel(model)
              : const Center(
                  child: Text(
                    'Bookmark tutorials to view them here',
                    textAlign: TextAlign.center,
                  ),
                ),
        ),
      ),
    );
  }
}

ListView populateListViewModel(NewsBookmarkViewModel model) {
  return ListView.separated(
    itemCount: model.count,
    separatorBuilder: (BuildContext context, int i) => const Divider(
      color: Colors.white,
    ),
    itemBuilder: (context, index) {
      var tutorial = model.bookMarkedTutorials[index];

      return ListTile(
        key: Key('bookmark_tutorial_$index'),
        title: Text(tutorial.tutorialTitle),
        trailing: const Icon(Icons.arrow_forward_ios_sharp),
        subtitle: Padding(
          padding: const EdgeInsets.only(top: 8.0),
          child: Text('Written by: ${tutorial.authorName}'),
        ),
        onTap: () {
          model.routeToBookmarkedTutorial(tutorial);
        },
        contentPadding: const EdgeInsets.all(16),
        minVerticalPadding: 8,
      );
    },
  );
}
