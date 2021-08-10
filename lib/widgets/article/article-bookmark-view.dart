import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';

import 'article-bookmark-feed.dart';

class ArticleBookmarkView extends StatefulWidget {
  ArticleBookmarkView({Key? key, this.article}) : super(key: key);

  BookmarkedArticle? article;

  @override
  _ArticleBookmarkViewState createState() => _ArticleBookmarkViewState();
}

class _ArticleBookmarkViewState extends State<ArticleBookmarkView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('BOOKMARKED ARTICLE'),
          centerTitle: true,
          backgroundColor: Color.fromRGBO(0x2A, 0x2A, 0x40, 1),
        ),
        backgroundColor: Color(0xFF0a0a23),
        body: SingleChildScrollView(
          child: Column(
            children: [
              Row(
                children: [
                  Expanded(
                    child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Html(
                            shrinkWrap: true,
                            data: widget.article!.articleText,
                            style: {
                              "body": Style(color: Colors.white),
                              "p": Style(
                                  fontSize: FontSize.large,
                                  textAlign: TextAlign.justify,
                                  lineHeight: LineHeight.em(1.2)),
                              "ul": Style(fontSize: FontSize.xLarge),
                              "li": Style(margin: EdgeInsets.only(top: 8)),
                              "pre": Style(
                                  color: Colors.white,
                                  width: MediaQuery.of(context).size.width,
                                  backgroundColor:
                                      Color.fromRGBO(0x2A, 0x2A, 0x40, 1),
                                  padding: EdgeInsets.all(25),
                                  textOverflow: TextOverflow.clip),
                              "code": Style(
                                  backgroundColor:
                                      Color.fromRGBO(0x2A, 0x2A, 0x40, 1)),
                              "tr": Style(
                                  border: Border(
                                      bottom: BorderSide(color: Colors.grey)),
                                  backgroundColor: Colors.white),
                              "th": Style(
                                padding: EdgeInsets.all(12),
                                backgroundColor:
                                    Color.fromRGBO(0xdf, 0xdf, 0xe2, 1),
                                color: Colors.black,
                              ),
                              "td": Style(
                                padding: EdgeInsets.all(12),
                                color: Colors.black,
                                alignment: Alignment.topLeft,
                              )
                            },
                            customRender: {
                              "table": (context, child) {
                                return SingleChildScrollView(
                                  scrollDirection: Axis.horizontal,
                                  child: (context.tree as TableLayoutElement)
                                      .toWidget(context),
                                );
                              }
                            })),
                  )
                ],
              )
            ],
          ),
        ));
  }
}
