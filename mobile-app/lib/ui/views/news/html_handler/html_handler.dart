// ignore_for_file: implementation_imports
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_highlight/flutter_highlight.dart';
import 'package:flutter_highlight/theme_map.dart';
import 'package:freecodecamp/models/news/article_model.dart';
import 'package:freecodecamp/ui/views/news/news-article/news_article_header.dart';
import 'package:freecodecamp/ui/views/news/news-article/news_article_view.dart';
import 'package:freecodecamp/ui/views/news/news-image-viewer/news_image_viewer.dart';
import 'package:html/dom.dart' as dom;
import 'package:url_launcher/url_launcher.dart';
import 'package:youtube_player_iframe/youtube_player_iframe.dart';

class HtmlHandler {
  HtmlHandler({Key? key, required this.html, required this.context});

  final String html;
  final BuildContext context;

  static List<Widget> htmlHandler(html, context, [article]) {
    var result = HtmlParser.parseHTML(html);

    List<Widget> elements = [];

    if (article is Article) {
      elements.add(Stack(children: [
        NewsArticleHeader(article: article),
        AppBar(
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
        )
      ]));
    }
    for (int i = 0; i < result.body!.children.length; i++) {
      elements
          .add(htmlWidgetBuilder(result.body!.children[i].outerHtml, context));
    }
    return elements;
  }

  static void goToImageView(String imgUrl, BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => NewsImageView(imgUrl: imgUrl)),
    );
  }

  static htmlWidgetBuilder(child, BuildContext context) {
    return Html(
      shrinkWrap: true,
      data: child,
      style: {
        'body': Style(
            fontFamily: 'Lato',
            padding: const EdgeInsets.only(left: 4, right: 4)),
        'p': Style(
          fontSize: FontSize.rem(1.35),
          lineHeight: const LineHeight(1.5),
          color: Colors.white.withOpacity(0.87),
        ),
        'li': Style(
          margin: const EdgeInsets.only(top: 8),
          fontSize: FontSize.rem(1.35),
        ),
        'pre': Style(
          color: Colors.white,
          width: MediaQuery.of(context).size.width,
          padding: const EdgeInsets.all(10),
        ),
        'tr': Style(
            border: const Border(bottom: BorderSide(color: Colors.grey)),
            backgroundColor: Colors.white),
        'th': Style(
          padding: const EdgeInsets.all(12),
          backgroundColor: const Color.fromRGBO(0xdf, 0xdf, 0xe2, 1),
          color: Colors.black,
        ),
        'td': Style(
          padding: const EdgeInsets.all(12),
          color: Colors.black,
          alignment: Alignment.topLeft,
        ),
        'figure': Style(
            width: MediaQuery.of(context).size.width, margin: EdgeInsets.zero),
        'h2': Style(margin: const EdgeInsets.fromLTRB(2, 12, 2, 8)),
        'h3': Style(margin: const EdgeInsets.fromLTRB(2, 12, 2, 8)),
        'h4': Style(margin: const EdgeInsets.fromLTRB(2, 12, 2, 8))
      },
      customRender: {
        'table': (context, child) {
          return SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: (context.tree as TableLayoutElement).toWidget(context),
          );
        },
        'figure': (code, child) {
          var figureClasses = code.tree.elementClasses;
          bool isBookmarkCard = figureClasses.contains('kg-bookmark-card');

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
        },
        'code': (code, child) {
          for (String className in code.tree.elementClasses) {
            if (className
                .contains(RegExp(r'language-', caseSensitive: false))) {
              return Row(
                children: [
                  Expanded(
                    child: HighlightView(code.tree.element?.text ?? '',
                        padding: const EdgeInsets.all(16),
                        language: className.split('-')[1],
                        theme: themeMap['dracula']!),
                  ),
                ],
              );
            }
          }
        },
        'iframe': (code, child) {
          var isVideo = RegExp('youtube', caseSensitive: false);
          var videoUrl = code.tree.attributes['src'];
          if (isVideo.hasMatch(videoUrl ?? '')) {
            var videoId = videoUrl?.split('/').last.split('?').first;

            YoutubePlayerController _controller = YoutubePlayerController(
              initialVideoId: videoId!,
            );

            return YoutubePlayerIFrame(
              controller: _controller,
            );
          }
        },
        'img': (code, child) {
          var imgUrl = code.tree.attributes['src'] ?? '';
          return InkWell(
            onTap: () => goToImageView(imgUrl, context),
            child: CachedNetworkImage(
              imageUrl: imgUrl,
            ),
          );
        }
      },
      onLinkTap: (String? url, RenderContext context,
          Map<String, String> attributes, dom.Element? element) {
        launch(url!);
      },
    );
  }
}
