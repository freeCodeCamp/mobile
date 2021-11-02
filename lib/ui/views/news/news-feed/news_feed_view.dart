import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:freecodecamp/models/article_model.dart';
import 'package:freecodecamp/ui/views/news/news-feed/news_feed_lazyloading.dart';
import 'package:freecodecamp/ui/views/news/news-feed/news_feed_viewmodel.dart';
import 'package:jiffy/jiffy.dart';
import 'package:stacked/stacked.dart';

import '../news_helpers.dart';
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
                return const Center(
                  child: Text(
                    'There was an error loading articles',
                    style: TextStyle(color: Colors.white),
                  ),
                );
              }

              return const Center(child: CircularProgressIndicator());
            },
          )),
    );
  }

  articleThumbnailBuilder(NewsFeedModel model, BuildContext context) {
    return ListView.builder(
        shrinkWrap: true,
        itemCount: model.articles.length,
        physics: const ClampingScrollPhysics(),
        itemBuilder: (BuildContext contex, int i) => NewsFeedLazyLoading(
            articleCreated: () {
              SchedulerBinding.instance!.addPostFrameCallback(
                  (timeStamp) => model.handleArticleLazyLoading(i));
            },
            child: InkWell(
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
                    constraints: BoxConstraints(
                        minHeight: 250,
                        maxHeight: 250,
                        minWidth: MediaQuery.of(context).size.width),
                    child: const Center(child: CircularProgressIndicator())),
                Container(
                  constraints: BoxConstraints(
                      maxHeight: 250,
                      minWidth: MediaQuery.of(context).size.width),
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
                      style: const TextStyle(color: Colors.white, fontSize: 18),
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
                        style:
                            const TextStyle(color: Colors.white, fontSize: 20),
                      ),
                    ),
                  )
                ],
              ),
              Row(children: [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Align(
                    alignment: Alignment.topRight,
                    child: SizedBox(
                        width: 45,
                        height: 45,
                        child: FadeInImage.assetNetwork(
                            fadeOutDuration: const Duration(milliseconds: 500),
                            fadeInDuration: const Duration(milliseconds: 500),
                            fit: BoxFit.cover,
                            placeholder:
                                'assets/images/placeholder-profile-img.png',
                            image: articles[i].profileImage)),
                  ),
                ),
                Padding(
                  padding:
                      const EdgeInsets.only(top: 16, bottom: 16, right: 16),
                  child: Text(
                    articles[i].authorName.toUpperCase(),
                    textAlign: TextAlign.right,
                    style: const TextStyle(color: Colors.white, fontSize: 18),
                  ),
                ),
                Expanded(
                    child: Align(
                  child: Text(
                    model.parseDate(articles[i].createdAt),
                    style: const TextStyle(color: Colors.white),
                  ),
                ))
              ]),
            ],
          ),
        )
      ],
    );
  }
}
