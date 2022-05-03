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

            return ListView.builder(
                shrinkWrap: true,
                scrollDirection: Axis.horizontal,
                itemCount: articles.length,
                itemBuilder: (context, index) {
                  Article article = articles[index];

                  return Row(children: [
                    Container(color: Colors.orange, child: Text(article.title))
                  ]);
                });
          }

          return const CircularProgressIndicator();
        });
  }
}
