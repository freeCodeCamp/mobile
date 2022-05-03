import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:freecodecamp/models/news/article_model.dart';
import 'package:freecodecamp/ui/views/news/news-feed/news_feed_viewmodel.dart';

class RecommendationWidget extends StatelessWidget {
  RecommendationWidget({Key? key}) : super(key: key);

  final NewsFeedModel model = NewsFeedModel();

  @override
  Widget build(BuildContext context) {
    final Future<List<Article>> future = model.recommendationWidgetFuture();

    return FutureBuilder<List<Article>>(
        future: future,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            List<Article> articles = snapshot.data as List<Article>;

            return ListView.separated(
                separatorBuilder: (context, index) {
                  return Container(
                      color: const Color(0xFF0a0a23),
                      child: const VerticalDivider());
                },
                shrinkWrap: true,
                scrollDirection: Axis.horizontal,
                itemCount: articles.length,
                itemBuilder: (context, index) {
                  Article article = articles[index];

                  return InkWell(
                    onTap: () => model.navigateTo(article.id),
                    child: Container(
                      constraints: const BoxConstraints(maxWidth: 200),
                      color: const Color(0xFF0a0a23),
                      child: Column(
                        children: [
                          Row(
                            children: [
                              Container(
                                color:
                                    const Color.fromRGBO(0x2A, 0x2A, 0x40, 1),
                                child: thumbnailImage(article),
                                height: 150,
                                width: 200,
                              )
                            ],
                          ),
                          Row(children: [
                            Expanded(
                                child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                article.title,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                textScaleFactor: 1.2,
                              ),
                            ))
                          ]),
                        ],
                      ),
                    ),
                  );
                });
          }

          return const CircularProgressIndicator();
        });
  }

  AspectRatio thumbnailImage(Article article) {
    return AspectRatio(
        aspectRatio: 16 / 9,
        child: CachedNetworkImage(
          imageUrl: article.featureImage,
          errorWidget: (context, url, error) => const Icon(Icons.error),
          imageBuilder: (context, imageProvider) => Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: imageProvider,
                fit: BoxFit.cover,
              ),
            ),
          ),
        ));
  }
}
