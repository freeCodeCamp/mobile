// ignore_for_file: implementation_imports
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_highlight/flutter_highlight.dart';
import 'package:flutter_highlight/theme_map.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:freecodecamp/models/news/article_model.dart';
import 'package:freecodecamp/ui/views/news/news-article/news_article_header.dart';
import 'package:freecodecamp/ui/views/news/news-image-viewer/news_image_viewer.dart';
import 'package:html/dom.dart' as dom;
import 'package:url_launcher/url_launcher_string.dart';
import 'package:youtube_player_iframe/youtube_player_iframe.dart';

class HtmlHandler {
  HtmlHandler({Key? key, required this.html, required this.context});

  final String html;
  final BuildContext context;

  static List<Widget> htmlHandler(html, context, [article, fontFamily]) {
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
      elements.add(htmlWidgetBuilder(
          result.body!.children[i].outerHtml, context, fontFamily ?? 'Lato'));
    }
    if (article is Article) {
      elements.add(Container(height: 100));
    }
    return elements;
  }

  static void goToImageView(String imgUrl, BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => NewsImageView(imgUrl: imgUrl)),
    );
  }

  static htmlWidgetBuilder(child, BuildContext context,
      [String fontFamily = 'Lato']) {
    return SelectableRegion(
      selectionControls: materialTextSelectionControls,
      focusNode: FocusNode(),
      child: Html(
        shrinkWrap: true,
        data: child,
        style: {
          'body': Style(
              fontFamily: fontFamily,
              padding: const EdgeInsets.only(left: 4, right: 4)),
          'blockquote': Style(fontSize: FontSize.rem(1.25)),
          'p': Style(
            fontWeight:
                fontFamily == 'Inter' ? FontWeight.w400 : FontWeight.normal,
            fontSize: FontSize.rem(fontFamily == 'Inter' ? 1.25 : 1.35),
            margin: const EdgeInsets.all(0),
            lineHeight: const LineHeight(1.5),
            color: fontFamily == 'Inter'
                ? const Color.fromRGBO(0xDF, 0xDF, 0xE2, 0.87)
                : Colors.white.withOpacity(0.87),
          ),
          'li': Style(
            margin: const EdgeInsets.only(top: 8),
            fontSize: FontSize.rem(1.35),
            color: Colors.white.withOpacity(0.87),
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
              width: MediaQuery.of(context).size.width,
              margin: EdgeInsets.zero),
          'h1': Style(
              margin: const EdgeInsets.fromLTRB(2, 32, 2, 0),
              fontSize: FontSize.rem(1.8)),
          'h2': Style(
              margin: const EdgeInsets.fromLTRB(2, 32, 2, 0),
              fontSize: FontSize.rem(1.6)),
          'h3': Style(
              margin: const EdgeInsets.fromLTRB(2, 32, 2, 0),
              fontSize: FontSize.rem(1.4)),
          'h4': Style(
              margin: const EdgeInsets.fromLTRB(2, 32, 2, 0),
              fontSize: FontSize.rem(1.2)),
          'h5': Style(
              margin: const EdgeInsets.fromLTRB(2, 32, 2, 0),
              fontSize: FontSize.rem(1.2)),
          'h6': Style(
              margin: const EdgeInsets.fromLTRB(2, 32, 2, 0),
              fontSize: FontSize.rem(1.2))
        },
        customRender: {
          'table': (context, child) {
            return SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: (context.tree as TableLayoutElement).toWidget(context),
            );
          },
          'code': (code, child) {
            String? currentClass;

            bool codeLanguageIsPresent(List classNames) {
              RegExp regExp = RegExp(r'language-', caseSensitive: false);

              for (String className in classNames) {
                if (className.contains(regExp)) {
                  currentClass = className;

                  return true;
                }
              }

              return false;
            }

            List classes = code.tree.elementClasses;

            if (code.tree.element!.parent!.localName == 'pre') {
              return Row(
                children: [
                  Expanded(
                    flex: 1,
                    child: SingleChildScrollView(
                      physics: const NeverScrollableScrollPhysics(),
                      child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        physics: const ClampingScrollPhysics(),
                        child: ConstrainedBox(
                          constraints: BoxConstraints(
                              minWidth: MediaQuery.of(context).size.width - 44),
                          child: HighlightView(code.tree.element?.text ?? '',
                              padding: const EdgeInsets.all(16),
                              language: codeLanguageIsPresent(classes)
                                  ? currentClass!.split('-')[1]
                                  : 'plaintext',
                              theme: themeMap['atom-one-dark']!),
                        ),
                      ),
                    ),
                  ),
                ],
              );
            }

            return HighlightView(
              code.tree.element?.text ?? '',
              padding: const EdgeInsets.all(2.5),
              language: 'html',
              theme: themeMap['atom-one-dark']!,
            );
          },
          'iframe': (code, child) {
            var isVideo = RegExp('youtube', caseSensitive: false);
            var videoUrl = code.tree.attributes['src'];
            if (isVideo.hasMatch(videoUrl ?? '')) {
              var videoId = videoUrl?.split('/').last.split('?').first;

              YoutubePlayerController controller = YoutubePlayerController(
                initialVideoId: videoId!,
              );

              return YoutubePlayerIFrame(
                controller: controller,
              );
            }
          },
          'img': (code, child) {
            var imgUrl = code.tree.attributes['src'] ?? '';
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: InkWell(
                onTap: () => goToImageView(imgUrl, context),
                child: CachedNetworkImage(
                  imageUrl: imgUrl,
                ),
              ),
            );
          },
          'blockquote': (code, child) {
            return Container(
              decoration: const BoxDecoration(
                border: Border(
                  left: BorderSide(
                      color: Color.fromRGBO(0x99, 0xc9, 0xff, 1), width: 2),
                ),
              ),
              child: child,
            );
          }
        },
        onLinkTap: (String? url, RenderContext context,
            Map<String, String> attributes, dom.Element? element) {
          launchUrlString(url!);
        },
      ),
    );
  }
}
