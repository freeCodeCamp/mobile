import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:freecodecamp/models/news/bookmarked_tutorial_model.dart';
import 'package:freecodecamp/ui/views/news/news-bookmark/news_bookmark_viewmodel.dart';
import 'package:freecodecamp/ui/views/news/news-tutorial/news_tutorial_viewmodel.dart';
import 'package:freecodecamp/ui/views/news/widgets/back_to_top_button.dart';
import 'package:stacked/stacked.dart';

class NewsBookmarkTutorialView extends StatelessWidget {
  final BookmarkedTutorial tutorial;

  const NewsBookmarkTutorialView({
    Key? key,
    required this.tutorial,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<NewsBookmarkViewModel>.reactive(
      viewModelBuilder: () => NewsBookmarkViewModel(),
      onViewModelReady: (model) async {
        await model.initDB();
        model.isTutorialBookmarked(tutorial);
        model.goToTopButtonHandler();
      },
      onDispose: (model) => model.updateListView(),
      builder: (context, model, child) => Scaffold(
        backgroundColor: const Color(0xFF0a0a23),
        body: SafeArea(
          child: CustomScrollView(
            controller: model.scrollController,
            slivers: [
              SliverAppBar(
                title: Text(
                  AppLocalizations.of(context).tutorial_bookmark_title,
                ),
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
                          child: ElevatedButton.icon(
                            onPressed: () {
                              model.bookmarkAndUnbookmark(tutorial);
                            },
                            icon: model.bookmarked
                                ? const Icon(Icons.bookmark_added)
                                : const Icon(Icons.bookmark_add_outlined),
                            label: Text(
                              model.bookmarked
                                  ? AppLocalizations.of(context).tutorial_bookmarked
                                  : AppLocalizations.of(context).tutorial_bookmark,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              lazyLoadHtml(context, tutorial)
            ],
          ),
        ),
        floatingActionButton: model.gotoTopButtonVisible
            ? BackToTopButton(
                onPressed: () => model.goToTop(),
              )
            : null,
        floatingActionButtonAnimator: null,
      ),
    );
  }

  SliverList lazyLoadHtml(
    BuildContext context,
    BookmarkedTutorial tutorial,
  ) {
    NewsTutorialViewModel localModel = NewsTutorialViewModel();
    var htmlToList = localModel.initLazyLoading(
      tutorial.tutorialText,
      context,
      tutorial,
    );

    return SliverList(
      delegate: SliverChildBuilderDelegate(((context, index) {
        return Row(
          children: [
            Expanded(
              child: htmlToList[index],
            ),
          ],
        );
      }), childCount: htmlToList.length),
    );
  }
}
