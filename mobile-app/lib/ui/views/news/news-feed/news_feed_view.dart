import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:freecodecamp/models/article_model.dart';
import 'package:freecodecamp/ui/views/news/news-feed/news_feed_lazyloading.dart';
import 'package:freecodecamp/ui/views/news/news-feed/news_feed_viewmodel.dart';
import 'package:stacked/stacked.dart';
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
                  ),
                );
              }

              return const Center(child: CircularProgressIndicator());
            },
          )),
    );
  }

  ListView articleThumbnailBuilder(NewsFeedModel model, BuildContext context) {
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
                child: thumbnailView(context, model, model.articles, i))));
  }

  Widget thumbnailView(BuildContext context, NewsFeedModel model,
      List<Article>? articles, int i) {
    return Column(
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
        Container(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(bottom: 8),
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
                    child: Text(
                      articles[i].title,
                      maxLines: 2,
                      style: const TextStyle(
                        fontSize: 20,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  )
                ],
              ),
              authorCard(model, articles, i),
            ],
          ),
        )
      ],
    );
  }

  Row authorCard(NewsFeedModel model, List<Article> articles, int i) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(right: 16, top: 16),
          child: InkWell(
            onTap: () {
              model.navigateToAuthor(articles[i].authorSlug);
            },
            child: Stack(children: [
              Container(
                width: 45,
                height: 45,
                color: const Color.fromRGBO(0x2A, 0x2A, 0x40, 1),
              ),
              SizedBox(
                  width: 45,
                  height: 45,
                  child: FadeInImage.assetNetwork(
                      fadeOutDuration: const Duration(milliseconds: 500),
                      fadeInDuration: const Duration(milliseconds: 500),
                      fit: BoxFit.cover,
                      placeholder: 'assets/images/placeholder-profile-img.png',
                      image: articles[i].profileImage)),
            ]),
          ),
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              articles[i].authorName.toUpperCase(),
            ),
            Text(
              model.parseDate(articles[i].createdAt),
            ),
          ],
        ),
      ],
    );
  }
}
