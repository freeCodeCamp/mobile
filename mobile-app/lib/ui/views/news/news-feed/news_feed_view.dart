import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:freecodecamp/models/article_model.dart';
import 'package:freecodecamp/ui/views/news/news-feed/news_feed_lazyloading.dart';
import 'package:freecodecamp/ui/views/news/news-feed/news_feed_viewmodel.dart';
import 'package:stacked/stacked.dart';
import 'package:url_launcher/url_launcher.dart';
import 'news_feed_viewmodel.dart';

class NewsFeedView extends StatelessWidget {
  const NewsFeedView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<NewsFeedModel>.reactive(
      viewModelBuilder: () => NewsFeedModel(),
      builder: (context, model, child) => Scaffold(
          backgroundColor: const Color(0xFF0a0a23),
          body: FutureBuilder(
            future: model.fetchArticles(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return articleThumbnailBuilder(model, context);
              } else if (snapshot.hasError) {
                return errorMessage();
              }
              return const Center(child: CircularProgressIndicator());
            },
          )),
    );
  }

<<<<<<< HEAD
 
  Column errorMessage() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const Text(
          'There was an error loading articles ',
          textAlign: TextAlign.center,
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: InkWell(
            child: const Text(
              'read articles online',
              textAlign: TextAlign.center,
              style: TextStyle(color: Color.fromRGBO(0x99, 0xc9, 0xff, 1)),
            ),
            onTap: () {
              launch('https://www.freecodecamp.org/news/');
            },
          ),
        ),
      ],
    );
  }

 ListView articleThumbnailBuilder(NewsFeedModel model, BuildContext context) {
=======
  articleThumbnailBuilder(NewsFeedModel model, BuildContext context) {
>>>>>>> parent of bc92617 (fix: dry out newsfeed)
    return ListView.separated(
        shrinkWrap: true,
        itemCount: model.articles.length,
        physics: const ClampingScrollPhysics(),
        separatorBuilder: (context, int i) => const Divider(
              color: Color.fromRGBO(0x2A, 0x2A, 0x40, 1),
              thickness: 3,
              height: 3,
            ),
        itemBuilder: (BuildContext contex, int i) => NewsFeedLazyLoading(
            articleCreated: () {
              SchedulerBinding.instance!.addPostFrameCallback(
                  (timeStamp) => model.handleArticleLazyLoading(i));
            },
            child: InkWell(
                splashColor: Colors.transparent,
                highlightColor: Colors.transparent,
                onTap: () {
                  model.navigateTo(model.articles[i].id);
                },
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 32.0),
                  child: thumbnailView(context, model, model.articles, i),
                ))));
  }

  Column thumbnailView(BuildContext context, NewsFeedModel model,
      List<Article>? articles, int i) {
    return Column(
      children: [
        Container(
          color: const Color(0xFF0a0a23),
          child: Column(
            children: [
              Stack(children: [
                Container(
                    color: const Color.fromRGBO(0x2A, 0x2A, 0x40, 1),
                    child: const AspectRatio(
                      aspectRatio: 16 / 9,
                      child: Center(
                          child: CircularProgressIndicator(
                        color: Colors.white,
                      )),
                    )),
                AspectRatio(
                  aspectRatio: 16 / 9,
                  child: Image.network(
                    articles![i].featureImage,
                    fit: BoxFit.cover,
                  ),
                ),
              ]),
              Row(
                children: [
                  Padding(
                    padding:
                        const EdgeInsets.only(top: 16, bottom: 8, left: 16),
                    child: Text(
                      '#' + articles[i].tagName!.toUpperCase(),
                      style: const TextStyle(fontSize: 18),
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Text(
                        articles[i].title,
                        maxLines: 2,
                        style: const TextStyle(
                          fontSize: 20,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ),
                  )
                ],
              ),
              Padding(
                padding: const EdgeInsets.only(left: 16, right: 16, top: 8),
                child: Row(
                  children: [
                    Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(right: 16),
                          child: InkWell(
                            onTap: () {
                              model.navigateToAuthor(articles[i].authorSlug);
                            },
                            child: SizedBox(
                                width: 45,
                                height: 45,
                                child: FadeInImage.assetNetwork(
                                    fadeOutDuration:
                                        const Duration(milliseconds: 500),
                                    fadeInDuration:
                                        const Duration(milliseconds: 500),
                                    fit: BoxFit.cover,
                                    placeholder:
                                        'assets/images/placeholder-profile-img.png',
                                    image: articles[i].profileImage)),
                          ),
                        ),
                      ],
                    ),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(bottom: 10),
                            child: Text(
                              articles[i].authorName.toUpperCase(),
                            ),
                          ),
                          Text(
                            model.parseDate(articles[i].createdAt),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        )
      ],
    );
  }
}
