import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:freecodecamp/models/news/tutorial_model.dart';
import 'package:freecodecamp/ui/views/news/news-feed/news_feed_viewmodel.dart';
import 'package:stacked/stacked.dart';
import 'package:url_launcher/url_launcher_string.dart';

class NewsFeedView extends StatelessWidget {
  const NewsFeedView({
    Key? key,
    this.slug = '',
    this.author = '',
    this.fromAuthor = false,
    this.fromTag = false,
    this.fromSearch = false,
    this.tutorials = const [],
    this.subject = '',
  }) : super(key: key);

  final String subject;
  final String slug;
  final String author;

  final List tutorials;

  final bool fromTag;
  final bool fromAuthor;
  final bool fromSearch;

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<NewsFeedViewModel>.reactive(
      viewModelBuilder: () => NewsFeedViewModel(),
      onViewModelReady: (model) async => await model.devMode(),
      builder: (context, model, child) => Scaffold(
        appBar: fromTag || fromAuthor || fromSearch
            ? AppBar(
                title: Text(
                  'Tutorials ${fromAuthor ? 'from' : 'about'} $subject',
                ),
              )
            : null,
        backgroundColor: const Color(0xFF0a0a23),
        body: FutureBuilder(
          future: !model.devmode
              ? !fromSearch
                  ? model.fetchTutorials(slug, author)
                  : model.returnTutorialsFromSearch(tutorials)
              : model.readFromFiles(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return RefreshIndicator(
                backgroundColor: const Color(0xFF0a0a23),
                color: Colors.white,
                child: tutorialThumbnailBuilder(model),
                onRefresh: () {
                  return model.refresh();
                },
              );
            } else if (snapshot.hasError) {
              return errorMessage();
            }
            return const Center(child: CircularProgressIndicator());
          },
        ),
      ),
    );
  }

  Column errorMessage() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const Text(
          'There was an error loading tutorials',
          textAlign: TextAlign.center,
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: InkWell(
            child: const Text(
              'read tutorials online',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Color.fromRGBO(0x99, 0xc9, 0xff, 1),
              ),
            ),
            onTap: () {
              launchUrlString('https://www.freecodecamp.org/news/');
            },
          ),
        ),
      ],
    );
  }

  ListView tutorialThumbnailBuilder(NewsFeedViewModel model) {
    return ListView.separated(
      shrinkWrap: true,
      itemCount: model.tutorials.length,
      physics: const ClampingScrollPhysics(),
      separatorBuilder: (context, int i) => const Divider(
        color: Color.fromRGBO(0x2A, 0x2A, 0x40, 1),
        thickness: 3,
        height: 3,
      ),
      itemBuilder: (BuildContext contex, int i) => NewsFeedLazyLoading(
        key: Key(model.tutorials[i].id),
        tutorialCreated: () {
          SchedulerBinding.instance.addPostFrameCallback(
            (timeStamp) => model.handleTutorialLazyLoading(i),
          );
        },
        child: InkWell(
          splashColor: Colors.transparent,
          onTap: () {
            model.navigateTo(model.tutorials[i].id, model.tutorials[i].title);
          },
          child: Padding(
            padding: const EdgeInsets.only(bottom: 32.0),
            child: thumbnailView(model, i),
          ),
        ),
      ),
    );
  }

  Column thumbnailView(NewsFeedViewModel model, int i) {
    Tutorial tutorial = model.tutorials[i];

    return Column(
      children: [
        Container(
          color: const Color.fromRGBO(0x2A, 0x2A, 0x40, 1),
          child: AspectRatio(
            aspectRatio: 16 / 9,
            child: CachedNetworkImage(
              imageUrl: tutorial.featureImage,
              errorWidget: (context, url, error) => const Icon(Icons.error),
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
          child: tutorialHeader(model, i),
        )
      ],
    );
  }

  Widget tutorialHeader(NewsFeedViewModel model, int i) {
    Tutorial tutorial = model.tutorials[i];

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
