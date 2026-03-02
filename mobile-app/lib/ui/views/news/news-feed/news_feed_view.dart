import 'dart:developer';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:freecodecamp/extensions/i18n_extension.dart';
import 'package:freecodecamp/models/news/tutorial_model.dart';
import 'package:freecodecamp/ui/views/news/news-feed/news_feed_viewmodel.dart';
import 'package:freecodecamp/ui/views/news/widgets/tag_widget.dart';
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
                thickness: 1,
                height: 1,
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

  Widget tutorialThumbnailBuilder(Tutorial tutorial, NewsFeedViewModel model) {
    return InkWell(
      key: Key(tutorial.id),
      splashColor: Colors.transparent,
      onTap: () {
        model.navigateTo(tutorial.id, tutorial.slug);
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: AspectRatio(
                aspectRatio: 16 / 9,
                child: Container(
                  color: const Color(0xFF2A2A40),
                  child: tutorial.featureImage == null
                      ? Image.asset(
                          'assets/images/freecodecamp-banner.png',
                          fit: BoxFit.cover,
                        )
                      : CachedNetworkImage(
                          imageUrl: tutorial.featureImage!,
                          fit: BoxFit.cover,
                          placeholder: (context, url) => Container(
                            color: const Color(0xFF2A2A40),
                          ),
                          errorWidget: (context, url, error) {
                            log('Error loading image: $url - ${tutorial.featureImage} $error');
                            return Image.asset(
                              'assets/images/freecodecamp-banner.png',
                              fit: BoxFit.cover,
                            );
                          },
                        ),
                ),
              ),
            ),
            const SizedBox(height: 8),
            if (tutorial.rawTags.isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(bottom: 6),
                child: Wrap(
                  spacing: 0,
                  runSpacing: 4,
                  children: [
                    for (int j = 0; j < tutorial.rawTags.length && j < 3; j++)
                      TagButton(
                        tagName: tutorial.rawTags[j]['name'],
                        tagSlug: tutorial.rawTags[j]['slug'] ?? tutorial.rawTags[j]['id'],
                        compact: true,
                        key: UniqueKey(),
                      ),
                  ],
                ),
              ),
            Text(
              tutorial.title,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                height: 1.25,
              ),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                GestureDetector(
                  onTap: () => model.navigateToAuthor(tutorial.authorSlug),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: SizedBox(
                      width: 24,
                      height: 24,
                      child: tutorial.profileImage == null
                          ? Image.asset(
                              'assets/images/placeholder-profile-img.png',
                              fit: BoxFit.cover,
                            )
                          : CachedNetworkImage(
                              imageUrl: tutorial.profileImage!,
                              fit: BoxFit.cover,
                              placeholder: (context, url) => Container(
                                color: const Color(0xFF2A2A40),
                              ),
                              errorWidget: (context, url, error) => Image.asset(
                                'assets/images/placeholder-profile-img.png',
                                fit: BoxFit.cover,
                              ),
                            ),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Flexible(
                  child: GestureDetector(
                    onTap: () => model.navigateToAuthor(tutorial.authorSlug),
                    child: Text(
                      tutorial.authorName,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 13,
                        color: Colors.white.withValues(alpha: 0.8),
                      ),
                    ),
                  ),
                ),
                Text(
                  '  •  ',
                  style: TextStyle(
                    fontSize: 13,
                    color: Colors.white.withValues(alpha: 0.5),
                  ),
                ),
                Text(
                  NewsFeedViewModel.parseDate(tutorial.createdAt),
                  style: TextStyle(
                    fontSize: 13,
                    color: Colors.white.withValues(alpha: 0.5),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
