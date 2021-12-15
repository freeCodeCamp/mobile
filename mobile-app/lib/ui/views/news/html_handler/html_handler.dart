import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:freecodecamp/ui/views/news/news-article-post/news_article_post_header.dart';
import 'package:freecodecamp/ui/views/news/news-article-post/news_article_post_view.dart';
import 'package:html/dom.dart' as dom;
import 'package:flutter_html/html_parser.dart';
import 'package:url_launcher/url_launcher.dart';

class HtmlHandler {
  const HtmlHandler({Key? key, required this.html, required this.context});

  final String html;
  final BuildContext context;

  static List<Widget> htmlHandler(html, context, article) {
    var result = HtmlParser.parseHTML(html);

    List<Widget> elements = [];

    elements.add(NewsArticlePostHeader(article: article));

    for (int i = 0; i < result.body!.children.length; i++) {
      elements
          .add(htmlWidgetBuilder(result.body!.children[i].outerHtml, context));
    }
    return elements;
  }

  static htmlWidgetBuilder(child, context) {
    return Html(
        shrinkWrap: true,
        data: child,
        style: {
          "body": Style(color: Colors.white),
          "p": Style(
              fontSize: FontSize.rem(1.35), lineHeight: LineHeight.em(1.2)),
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
          "code":
              Style(backgroundColor: const Color.fromRGBO(0x2A, 0x2A, 0x40, 1)),
          "tr": Style(
              border: const Border(bottom: BorderSide(color: Colors.grey)),
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
          "figure": Style(
              width: MediaQuery.of(context).size.width, margin: EdgeInsets.zero)
        },
        customRender: {
          "table": (context, child) {
            return SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: (context.tree as TableLayoutElement).toWidget(context),
            );
          },
          "code": (context, child) {
            return SingleChildScrollView(
                scrollDirection: Axis.horizontal, child: child);
          },
          "figure": (code, child) {
            var figureClasses = code.tree.elementClasses;
            bool isBookmarkCard = figureClasses.contains("kg-bookmark-card");

            if (isBookmarkCard) {
              var parent = code.tree.children[0];

              var link = parent.attributes['href'];

              var bookmarkTilte = parent.children[0].children[0].element?.text;

              var bookmarkDescription =
                  parent.children[0].children[1].element?.text;

              var bookmarkImage =
                  parent.children[1].children[0].attributes['src'];

              return bookmark(
                  bookmarkTilte, bookmarkDescription, bookmarkImage, link);
            }
          }
        },
        onLinkTap: (String? url, RenderContext context,
            Map<String, String> attributes, dom.Element? element) {
          launch(url!);
        },
        onImageTap: (String? url, RenderContext context,
            Map<String, String> attributes, dom.Element? element) {
          launch(url!);
        });
  }
}
