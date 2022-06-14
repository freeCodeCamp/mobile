import 'package:flutter/material.dart';

import 'package:freecodecamp/models/news/article_model.dart';
import 'package:freecodecamp/ui/views/news/news-bookmark/news_bookmark_widget.dart';
import 'package:share/share.dart';
import 'package:stacked/stacked.dart';
import 'package:url_launcher/url_launcher_string.dart';
import 'news_article_viewmodel.dart';

class NewsArticleView extends StatelessWidget {
  // ignore: prefer_const_constructors_in_immutables
  NewsArticleView({Key? key, required this.refId}) : super(key: key);
  late final String refId;

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<NewsArticleViewModel>.reactive(
      onModelReady: (model) => model.initState(refId),
      onDispose: (model) => model.removeScrollPosition(),
      builder: (context, model, child) => Scaffold(
        backgroundColor: const Color(0xFF0a0a23),
        body: FutureBuilder<Article>(
          future: model.initState(refId),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              Article article = snapshot.data as Article;

              return Column(
                children: [
                  Expanded(
                      child: Stack(children: [
                    lazyLoadHtml(article, context),
                    bottomButtons(article, model)
                  ]))
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
      viewModelBuilder: () => NewsArticleViewModel(),
    );
  }

  Widget bottomButtons(Article article, NewsArticleViewModel model) {
    return Align(
      alignment: Alignment.bottomCenter,
      child: SizedBox(
        height: 75,
        width: 300,
        child: ListView(
          physics: const NeverScrollableScrollPhysics(),
          controller: model.bottomButtonController,
          children: [
            Row(
              children: [
                Container(
                  height: 150,
                ),
                NewsBookmarkViewWidget(article: article),
                const SizedBox(
                  height: 35,
                  child: VerticalDivider(
                    color: Colors.white,
                    width: 0,
                  ),
                ),
                BottomButton(
                  label: 'Share',
                  icon: Icons.share,
                  onPressed: () {
                    Share.share('${article.title}\n\n${article.url}');
                  },
                  rightSided: true,
                )
              ],
            ),
          ],
        ),
      ),
    );
  }

  FutureBuilder lazyLoadHtml(Article article, BuildContext context) {
    NewsArticleViewModel model = NewsArticleViewModel();

    Future elementsFuture = model.initLazyLoading(article, context);

    return FutureBuilder(builder: (context, snaphot) {
      if (snaphot.hasData) {
        return Text('has data');
      }

      return const CircularProgressIndicator();
    });
  }
}

class BottomButton extends StatelessWidget {
  const BottomButton(
      {Key? key,
      required this.label,
      required this.onPressed,
      required this.icon,
      required this.rightSided})
      : super(key: key);

  final Function onPressed;
  final String label;
  final bool rightSided;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: ElevatedButton.icon(
        icon: Icon(
          icon,
          color: Colors.white,
        ),
        onPressed: () {
          onPressed();
        },
        label: Text(label),
        style: ElevatedButton.styleFrom(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(rightSided ? 0 : 10),
                    topRight: Radius.circular(rightSided ? 10 : 0),
                    bottomLeft: Radius.circular(rightSided ? 0 : 10),
                    bottomRight: Radius.circular(rightSided ? 10 : 0))),
            primary: const Color.fromRGBO(0x2A, 0x2A, 0x40, 1)),
      ),
    );
  }
}

Container bookmark(String? bookmarkTilte, String? bookmarkDescription,
    String? bookmarkImage, String? link) {
  return Container(
    color: Colors.white,
    child: GestureDetector(
      onTap: () {
        launchUrlString(link!);
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
