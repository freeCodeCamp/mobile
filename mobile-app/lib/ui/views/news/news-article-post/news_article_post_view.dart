import 'package:flutter/material.dart';

import 'package:freecodecamp/models/article_model.dart';

import 'package:freecodecamp/ui/views/news/news-bookmark/news_bookmark_widget.dart';
import 'package:stacked/stacked.dart';
import 'package:url_launcher/url_launcher.dart';
import 'news_article_post_viewmodel.dart';
import 'dart:developer' as dev;

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
          backgroundColor: const Color(0xFF0a0a23),
          title: const Text(
            'Back To Feed',
            style: TextStyle(
              color: Colors.white,
            ),
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
                  Stack(
                    children: [
                      AspectRatio(
                        aspectRatio: 16 / 9,
                        child: FadeInImage.assetNetwork(
                          placeholder: 'assets/images/freecodecamp-banner.png',
                          image: article!.featureImage,
                          fit: BoxFit.cover,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Align(
                          alignment: Alignment.topRight,
                          child: ElevatedButton.icon(
                            onPressed: () {
                              launch(article.url as String);
                            },
                            icon: const Icon(Icons.open_in_new_sharp),
                            label: const Text('open in browser'),
                            style: ElevatedButton.styleFrom(
                                primary: const Color(0xFF0a0a23)),
                          ),
                        ),
                      )
                    ],
                  ),
                  Row(
                    children: [
                      Container(
                        color: const Color.fromRGBO(0x2A, 0x2A, 0x40, 1),
                        width: MediaQuery.of(context).size.width,
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Text(article.title,
                              style: const TextStyle(
                                  fontSize: 24, color: Colors.white)),
                        ),
                      )
                    ],
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: Container(
                          color: const Color.fromRGBO(0x2A, 0x2A, 0x40, 1),
                          child: Row(
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(16),
                                child: FadeInImage.assetNetwork(
                                    height: 50,
                                    width: 50,
                                    fit: BoxFit.cover,
                                    placeholder:
                                        'assets/images/placeholder-profile-img.png',
                                    image: article.profileImage),
                              ),
                              Expanded(
                                  child: Container(
                                color:
                                    const Color.fromRGBO(0x2A, 0x2A, 0x40, 1),
                                child: Padding(
                                  padding: const EdgeInsets.only(top: 8),
                                  child: Text(
                                    'Written by ' + article.authorName,
                                    style: const TextStyle(
                                        fontSize: 16, color: Colors.white),
                                  ),
                                ),
                              ))
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Container(
                        color: const Color.fromRGBO(0x2A, 0x2A, 0x40, 1),
                        width: MediaQuery.of(context).size.width,
                        child: NewsBookmarkViewWidget(article: article),
                      )
                    ],
                  ),
                  Expanded(child: lazyLoadHtml(article.text!, context, model))
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

ListView lazyLoadHtml(
    String html, BuildContext context, NewsArticlePostViewModel model) {
  var htmlToList = model.initLazyLoading(html, context);
  dev.log(htmlToList.length.toString());
  return ListView.builder(
      shrinkWrap: true,
      itemCount: htmlToList.length,
      physics: const ClampingScrollPhysics(),
      itemBuilder: (BuildContext context, int i) {
        dev.log(i.toString());
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
