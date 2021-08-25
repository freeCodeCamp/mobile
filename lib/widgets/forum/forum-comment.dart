import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_syntax_view/flutter_syntax_view.dart';
import 'package:freecodecamp/models/post-model.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:html/dom.dart' as dom;

class ForumComment extends StatefulWidget {
  ForumComment({Key? key, required this.comments}) : super(key: key);
  late final List comments;
  _ForumCommentState createState() => _ForumCommentState();
}

class _ForumCommentState extends State<ForumComment> {
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        shrinkWrap: true,
        physics: ClampingScrollPhysics(),
        itemCount: widget.comments.length,
        itemBuilder: (context, index) {
          return Column(
            children: [
              Row(
                children: [
                  Row(children: [
                    Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(24.0),
                          child: Container(
                              decoration: BoxDecoration(
                                  border: Border.all(
                                      width: 4,
                                      color: PostModel.randomBorderColor())),
                              child: FadeInImage.assetNetwork(
                                  height: 60,
                                  placeholder:
                                      'assets/images/placeholder-profile-img.png',
                                  image: PostModel.parseProfileAvatUrl(
                                      widget.comments[index].profieImage))),
                        ),
                      ],
                    ),
                    Column(
                      children: [
                        Text(
                          widget.comments[index].username,
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 24,
                              fontWeight: FontWeight.bold),
                        )
                      ],
                    )
                  ]),
                ],
              ),
              Row(
                children: [
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                          border: Border(
                              bottom:
                                  BorderSide(width: 2, color: Colors.white))),
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Html(
                          data: widget.comments[index].postHtml,
                          style: {
                            "body": Style(color: Colors.white),
                            "p": Style(
                                fontSize: FontSize.rem(1.35),
                                lineHeight: LineHeight.em(1.2)),
                            "ul": Style(fontSize: FontSize.xLarge),
                            "li": Style(
                              margin: EdgeInsets.only(top: 8),
                              fontSize: FontSize.rem(1.35),
                            ),
                            "pre": Style(
                                color: Colors.white,
                                width: MediaQuery.of(context).size.width,
                                backgroundColor:
                                    Color.fromRGBO(0x2A, 0x2A, 0x40, 1),
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
                              var classList = context.tree.elementClasses;
                              if (classList.length > 0 &&
                                  classList[0] == 'lang-auto')
                                return ConstrainedBox(
                                  constraints: BoxConstraints(
                                      minHeight: 100, maxHeight: 800),
                                  child: SyntaxView(
                                    code: context.tree.element?.text as String,
                                    syntax: Syntax.JAVASCRIPT,
                                    syntaxTheme: SyntaxTheme.vscodeDark(),
                                    fontSize: 16.0,
                                    withZoom: true,
                                    withLinesCount: false,
                                    expanded: false,
                                  ),
                                );
                            },
                          },
                          onLinkTap: (String? url,
                              RenderContext context,
                              Map<String, String> attributes,
                              dom.Element? element) {
                            launch(url!);
                          },
                        ),
                      ),
                    ),
                  )
                ],
              )
            ],
          );
        });
  }
}
