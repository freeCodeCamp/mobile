import 'dart:developer';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:freecodecamp/extensions/i18n_extension.dart';
import 'package:freecodecamp/models/news/tutorial_model.dart';
import 'package:freecodecamp/ui/views/news/news-feed/news_feed_viewmodel.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:stacked/stacked.dart';

class NewsFeedView extends StatelessWidget {
  const NewsFeedView({
    super.key,
    this.tagSlug = '',
    this.authorId = '',
    this.fromAuthor = false,
    this.fromTag = false,
    this.fromSearch = false,
    this.tutorials = const [],
    this.subject = '',
  });

  final String subject;
  final String tagSlug;
  final String authorId;

  final List tutorials;

  final bool fromTag;
  final bool fromAuthor;
  final bool fromSearch;

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<NewsFeedViewModel>.reactive(
      viewModelBuilder: () => NewsFeedViewModel(),
      onViewModelReady: (model) => model.initState(tagSlug, authorId),
      builder: (context, model, child) => Scaffold(
        appBar: fromTag || fromAuthor || fromSearch
            ? AppBar(
                title: fromAuthor
                    ? Text(
                        context.t.tutorials_from(subject),
                      )
                    : Text(
                        context.t.tutorials_about(subject),
                      ),
              )
            : null,
        backgroundColor: const Color(0xFF0a0a23),
        // body: FutureBuilder(
        //   future: !model.devmode
        //       ? !fromSearch
        //           ? model.fetchTutorials(slug, author)
        //           : model.returnTutorialsFromSearch(tutorials)
        //       : model.readFromFiles(),
        //   builder: (context, snapshot) {
        //     if (snapshot.hasData) {
        //       return RefreshIndicator(
        //         backgroundColor: const Color(0xFF0a0a23),
        //         color: Colors.white,
        //         child: tutorialThumbnailBuilder(model),
        //         onRefresh: () {
        //           return model.refresh();
        //         },
        //       );
        //     } else if (snapshot.hasError) {
        //       return errorMessage(context);
        //     }
        //     return const Center(child: CircularProgressIndicator());
        //   },
        // ),
        body: RefreshIndicator(
          onRefresh: () => Future.sync(() => model.pagingController.refresh()),
          backgroundColor: const Color(0xFF0a0a23),
          color: Colors.white,
          // child: tutorialThumbnailBuilder(model),
          child: PagingListener(
            controller: model.pagingController,
            builder: (context, state, fetchNextPage) => PagedListView.separated(
              state: state,
              fetchNextPage: fetchNextPage,
              separatorBuilder: (context, int i) => const Divider(
                color: Color.fromRGBO(0x2A, 0x2A, 0x40, 1),
                thickness: 3,
                height: 3,
              ),
              builderDelegate: PagedChildBuilderDelegate<Tutorial>(
                itemBuilder: (context, tutorial, index) => Container(
                  key: Key('news-tutorial-$index'),
                  child: tutorialThumbnailBuilder(tutorial, model),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  // Column errorMessage(BuildContext context) {
  //   return Column(
  //     mainAxisAlignment: MainAxisAlignment.center,
  //     crossAxisAlignment: CrossAxisAlignment.stretch,
  //     children: [
  //       Text(
  //         context.t.tutorial_load_error,
  //         textAlign: TextAlign.center,
  //       ),
  //       Padding(
  //         padding: const EdgeInsets.all(8.0),
  //         child: InkWell(
  //           child: Text(
  //             context.t.tutorial_read_online,
  //             textAlign: TextAlign.center,
  //             style: const TextStyle(
  //               color: Color.fromRGBO(0x99, 0xc9, 0xff, 1),
  //             ),
  //           ),
  //           onTap: () {
  //             launchUrl(Uri.parse('https://www.freecodecamp.org/news/'));
  //           },
  //         ),
  //       ),
  //     ],
  //   );
  // }

  InkWell tutorialThumbnailBuilder(Tutorial tutorial, NewsFeedViewModel model) {
    return InkWell(
      key: Key(tutorial.id),
      splashColor: Colors.transparent,
      onTap: () {
        model.navigateTo(tutorial.id, tutorial.slug);
      },
      child: Padding(
        padding: const EdgeInsets.only(bottom: 32.0),
        child: thumbnailView(tutorial, model),
      ),
    );
  }

  Column thumbnailView(Tutorial tutorial, NewsFeedViewModel model) {
    return Column(
      children: [
        Container(
          color: const Color.fromRGBO(0x2A, 0x2A, 0x40, 1),
          child: AspectRatio(
            aspectRatio: 16 / 9,
            child: tutorial.featureImage == null
                ? Image.asset(
                    'assets/images/freecodecamp-banner.png',
                    fit: BoxFit.cover,
                  )
                : CachedNetworkImage(
                    imageUrl: tutorial.featureImage!,
                    errorWidget: (context, url, error) {
                      log('Error loading image: $url - $tutorial.featureImage $error');
                      return const Icon(Icons.error);
                    },
                    imageBuilder: (context, imageProvider) => Container(
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: imageProvider,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ),
          ),
        ),
        Align(
          alignment: Alignment.centerLeft,
          child: Padding(
            padding: const EdgeInsets.only(left: 16, right: 16),
            child: Wrap(
              children: [
                for (int j = 0; j < tutorial.tagNames.length && j < 3; j++)
                  tutorial.tagNames[j]
              ],
            ),
          ),
        ),
        Container(
          padding: const EdgeInsets.only(left: 16, right: 16, top: 8),
          child: tutorialHeader(tutorial, model),
        )
      ],
    );
  }

  Widget tutorialHeader(Tutorial tutorial, NewsFeedViewModel model) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                tutorial.title,
                maxLines: 2,
                style: const TextStyle(
                  fontSize: 20,
                  overflow: TextOverflow.ellipsis,
                  height: 1.5,
                ),
              ),
            ),
          ],
        ),
        Row(
          children: [
            Padding(
              padding: const EdgeInsets.only(right: 16, top: 16),
              child: InkWell(
                onTap: () {
                  model.navigateToAuthor(tutorial.authorSlug);
                },
                child: Container(
                  width: 45,
                  height: 45,
                  color: const Color.fromRGBO(0x2A, 0x2A, 0x40, 1),
                  child: tutorial.profileImage == null
                      ? Image.asset(
                          'assets/images/placeholder-profile-img.png',
                          width: 45,
                          height: 45,
                          fit: BoxFit.cover,
                        )
                      : CachedNetworkImage(
                          imageUrl: tutorial.profileImage as String,
                          errorWidget: (context, url, error) => Image.asset(
                            'assets/images/placeholder-profile-img.png',
                            width: 45,
                            height: 45,
                            fit: BoxFit.cover,
                          ),
                          imageBuilder: (context, imageProvider) => Container(
                            decoration: BoxDecoration(
                              image: DecorationImage(
                                image: imageProvider,
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                        ),
                ),
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(bottom: 10, top: 16),
                  child: Text(
                    tutorial.authorName.toUpperCase(),
                  ),
                ),
                Text(
                  NewsFeedViewModel.parseDate(tutorial.createdAt),
                ),
              ],
            ),
          ],
        ),
      ],
    );
  }
}
