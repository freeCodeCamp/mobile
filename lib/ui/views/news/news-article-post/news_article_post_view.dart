import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_html/html_parser.dart';
import 'package:freecodecamp/models/article_model.dart';
import 'package:freecodecamp/ui/views/news/news-bookmark/news_bookmark_widget.dart';
import 'package:stacked/stacked.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:html/dom.dart' as dom;
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
          backgroundColor: const Color(0xFF0a0a23),
          title: const Text(
            'Back To Feed',
            style: TextStyle(
              color: Colors.white,
            ),
          ),
        ),
        backgroundColor: const Color(0xFF0a0a23),
        body: SingleChildScrollView(
          child: FutureBuilder<Article>(
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
                            placeholder:
                                'assets/images/freecodecamp-banner.png',
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
                    htmlView(article, context)
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
      ),
      viewModelBuilder: () => NewsArticlePostViewModel(),
    );
  }
}

Row htmlView(Article article, BuildContext context) {
  return Row(
    children: [
      Expanded(
        child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Html(
                shrinkWrap: true,
                data: article.text,
                style: {
                  "body": Style(color: Colors.white),
                  "p": Style(
                      fontSize: FontSize.rem(1.35),
                      lineHeight: LineHeight.em(1.2)),
                  "ul": Style(fontSize: FontSize.xLarge),
                  "li": Style(
                    margin: const EdgeInsets.only(top: 8),
                    fontSize: FontSize.rem(1.35),
                  ),
                  "pre": Style(
                    color: Colors.white,
                    width: MediaQuery.of(context).size.width,
                    backgroundColor: const Color.fromRGBO(0x2A, 0x2A, 0x40, 1),
                    padding: const EdgeInsets.all(10),
                  ),
                  "code": Style(
                      backgroundColor:
                          const Color.fromRGBO(0x2A, 0x2A, 0x40, 1)),
                  "tr": Style(
                      border:
                          const Border(bottom: BorderSide(color: Colors.grey)),
                      backgroundColor: Colors.white),
                  "th": Style(
                    padding: const EdgeInsets.all(12),
                    backgroundColor: const Color.fromRGBO(0xdf, 0xdf, 0xe2, 1),
                    color: Colors.black,
                  ),
                  "td": Style(
                    padding: const EdgeInsets.all(12),
                    color: Colors.black,
                    alignment: Alignment.topLeft,
                  ),
                },
                customRender: {
                  "table": (context, child) {
                    return SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: (context.tree as TableLayoutElement)
                          .toWidget(context),
                    );
                  },
                  "code": (context, child) {
                    return SingleChildScrollView(
                        scrollDirection: Axis.horizontal, child: child);
                  }
                },
                onLinkTap: (String? url, RenderContext context,
                    Map<String, String> attributes, dom.Element? element) {
                  launch(url!);
                },
                onImageTap: (String? url, RenderContext context,
                    Map<String, String> attributes, dom.Element? element) {
                  launch(url!);
                })),
      )
    ],
  );
}
