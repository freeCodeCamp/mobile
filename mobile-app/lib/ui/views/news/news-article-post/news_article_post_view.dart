import 'package:flutter/material.dart';

import 'package:freecodecamp/models/news/article_model.dart';
import 'package:stacked/stacked.dart';
import 'package:url_launcher/url_launcher.dart';
import 'news_article_post_viewmodel.dart';

class NewsArticlePostView extends StatelessWidget {
  // ignore: prefer_const_constructors_in_immutables
  NewsArticlePostView({Key? key, required this.refId}) : super(key: key);
  late final String refId;

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<NewsArticlePostViewModel>.reactive(
      onModelReady: (model) => model.initState(refId),
      builder: (context, model, child) => Scaffold(
        appBar: AppBar(
          title: const Text(
            'Back To Feed',
          ),
        ),
        backgroundColor: const Color(0xFF0a0a23),
        body: FutureBuilder<Article>(
          future: model.articleFuture,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              var article = snapshot.data;
              return Column(
                children: [
                  Expanded(
                      child:
                          lazyLoadHtml(article!.text!, context, model, article))
                ],
              );
            } else if (snapshot.hasError) {
              throw Exception(snapshot.error);
            }

            return const Center(
              child: CircularProgressIndicator(),
            );
          },
        ),
      ),
      viewModelBuilder: () => NewsArticlePostViewModel(),
    );
  }
}

ListView lazyLoadHtml(String html, BuildContext context,
    NewsArticlePostViewModel model, Article article) {
  var htmlToList = model.initLazyLoading(html, context, article);
  return ListView.builder(
      shrinkWrap: true,
      itemCount: htmlToList.length,
      physics: const ClampingScrollPhysics(),
      itemBuilder: (BuildContext context, int i) {
        return Row(
          children: [
            Expanded(child: htmlToList[i]),
          ],
        );
      });
}

Container bookmark(String? bookmarkTilte, String? bookmarkDescription,
    String? bookmarkImage, String? link) {
  return Container(
    color: Colors.white,
    child: GestureDetector(
      onTap: () {
        launch(link!);
      },
      child: Padding(
        padding: const EdgeInsets.only(left: 10.0),
        child: Row(
          children: [
            Expanded(
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Text(
                          bookmarkTilte.toString(),
                          style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                              decoration: TextDecoration.underline,
                              decorationThickness: 2),
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.only(top: 25.0, left: 5),
                          child: Text(
                            bookmarkDescription.toString().substring(0, 125) +
                                '...',
                            style: const TextStyle(
                              fontSize: 16,
                            ),
                          ),
                        ),
                      )
                    ],
                  )
                ],
              ),
            ),
            Expanded(
              child: Column(
                children: [
                  Image.network(
                    bookmarkImage.toString(),
                    fit: BoxFit.cover,
                  )
                ],
              ),
            )
          ],
        ),
      ),
    ),
  );
}
