import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:freecodecamp/models/article_model.dart';
import 'package:freecodecamp/ui/views/news/news-feed/news_feed_lazyloading.dart';
import 'package:freecodecamp/ui/views/news/news-feed/news_feed_viewmodel.dart';
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
          backgroundColor: const Color.fromRGBO(0x2A, 0x2A, 0x40, 1),
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
                child: thumbnailView(context, model, model.articles, i))));
  }

  Column thumbnailView(BuildContext context, NewsFeedModel model,
      List<Article>? articles, int i) {
    return Column(
      children: [
        Stack(
          children: [
            Container(
              decoration: BoxDecoration(
                  border: Border.all(width: 2, color: Colors.white)),
              height: 210,
              width: MediaQuery.of(context).size.width,
              child: Image.network(
                NewsHelper.getArticleImage(articles![i].featureImage, context),
                fit: BoxFit.fitWidth,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Align(
                alignment: Alignment.topRight,
                child: Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                      border: Border.all(
                          width: 4, color: NewsHelper.randomBorderColor())),
                  child: Image.network(
                    articles[i].profileImage,
                    fit: BoxFit.fill,
                  ),
                ),
              ),
            )
          ],
        ),
        Container(
          color: const Color(0xFF0a0a23),
          child: ConstrainedBox(
            constraints: const BoxConstraints(minHeight: 150),
            child: Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Text(
                          NewsHelper.truncateStr(articles[i].title),
                          style: const TextStyle(
                              color: Colors.white, fontSize: 24),
                        ),
                      ),
                    )
                  ],
                ),
                Row(children: [
                  Expanded(
                    flex: 6,
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Text(
                        '#' + articles[i].tagName!,
                        style:
                            const TextStyle(color: Colors.white, fontSize: 18),
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 6,
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Text(
                        articles[i].authorName,
                        textAlign: TextAlign.right,
                        style:
                            const TextStyle(color: Colors.white, fontSize: 18),
                      ),
                    ),
                  )
                ]),
              ],
            ),
          ),
        )
      ],
    );
  }
}
