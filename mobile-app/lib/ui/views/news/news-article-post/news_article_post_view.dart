import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:freecodecamp/ui/widgets/loading_bar_widget.dart';
import 'package:freecodecamp/models/news/article_model.dart';
import 'package:stacked/stacked.dart';
import 'package:url_launcher/url_launcher.dart';
import 'news_article_post_viewmodel.dart';
import 'dart:developer' as dev;

class NewsArticlePostView extends StatelessWidget {
  // ignore: prefer_const_constructors_in_immutables
  NewsArticlePostView({Key? key, required this.refId}) : super(key: key);
  late final String refId;
  List<int> localIndexCache = [];
  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<NewsArticlePostViewModel>.reactive(
      onModelReady: (model) => model.initState(refId),
      builder: (context, model, child) => Scaffold(
        appBar: AppBar(
          title: const Text(
            'Back To Feed',
          ),
          bottom: PreferredSize(
              preferredSize: const Size.fromHeight(10),
              child: Row(
                children: [
                  Expanded(
                    child: LoadingBarIndiactor(
                      progressBgColor:
                          const Color.fromRGBO(0x2A, 0x2A, 0x40, 1),
                      progressColor: Colors.white,
                      arrayLength: model.arrLength == 0 ? 100 : model.arrLength,
                      start: model.indexCache.length == 2
                          ? model.indexCache[0]
                          : 1,
                      end: model.indexCache.length == 2
                          ? model.indexCache[1]
                          : 2,
                    ),
                  ),
                ],
              )),
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

  lazyLoadHtml(String html, BuildContext context,
      NewsArticlePostViewModel model, Article article) {
    var htmlToList = model.initLazyLoading(html, context, article);
    var index = 0;

    return NotificationListener(
      child: ListView.builder(
          shrinkWrap: true,
          itemCount: htmlToList.length,
          physics: const ClampingScrollPhysics(),
          itemBuilder: (BuildContext context, int i) {
            index = i;
            return Row(
              children: [
                Expanded(child: htmlToList[i]),
              ],
            );
          }),
      onNotification: (t) {
        if (t is ScrollEndNotification) {
          SchedulerBinding.instance!.addPostFrameCallback((timeStamp) => {
                if (localIndexCache.length < 2)
                  {localIndexCache.add(index)}
                else if (model.indexCache[1] > index)
                  {
                    localIndexCache[0] = model.indexCache[1],
                    localIndexCache[1] = index,
                  }
                else
                  {localIndexCache.removeAt(0), localIndexCache.add(index)},
                model.setArticleReadProgress(htmlToList.length, localIndexCache)
              });
        }
        return false;
      },
    );
  }
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
