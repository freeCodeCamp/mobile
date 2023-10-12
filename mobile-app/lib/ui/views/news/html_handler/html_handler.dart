import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_highlight/flutter_highlight.dart';
import 'package:flutter_highlight/theme_map.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_html_table/flutter_html_table.dart';
import 'package:freecodecamp/ui/views/news/news-image-viewer/news_image_view.dart';
import 'package:html/dom.dart' as dom;
import 'package:html/parser.dart' as parser;
import 'package:url_launcher/url_launcher.dart';
import 'package:youtube_player_iframe/youtube_player_iframe.dart';

class HTMLParser {
  const HTMLParser({
    Key? key,
    required this.context,
    this.fontFamily = 'Lato',
  });

  final String fontFamily;
  final BuildContext context;

  List<Widget> parse(
    String html, {
    bool isSelectable = true,
    Color? fontColor,
  }) {
    dom.Document result = parser.parse(html);

    List<Widget> elements = [];

    for (int i = 0; i < result.body!.children.length; i++) {
      elements.add(
        _parseHTMLWidget(
          result.body!.children[i].outerHtml,
          isSelectable,
          fontColor,
        ),
      );
    }

    return elements;
  }

  void goToImageView(
    String imgUrl,
    BuildContext context,
    bool isDataUrl,
  ) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => NewsImageView(
          imgUrl: imgUrl,
          isDataUrl: isDataUrl,
        ),
        settings: const RouteSettings(name: 'News Image View'),
      ),
    );
  }

  Widget _parseHTMLWidget(
    child, [
    bool isSelectable = true,
    Color? fontColor,
  ]) {
    Html htmlWidget = Html(
      shrinkWrap: true,
      data: child,
      style: {
        'h1': Style(
          margin: Margins.only(left: 2, top: 32, right: 2),
          fontSize: FontSize.xxLarge,
        ),
        'h2': Style(
          margin: Margins.only(left: 2, top: 32, right: 2),
          fontSize: FontSize.xxLarge,
        ),
        'h3': Style(
          margin: Margins.only(left: 2, top: 32, right: 2),
          fontSize: FontSize.xLarge,
        ),
        'h4': Style(
          margin: Margins.only(left: 2, top: 32, right: 2),
          fontSize: FontSize.large,
        ),
        'h5': Style(
          margin: Margins.only(left: 2, top: 32, right: 2),
          fontSize: FontSize.large,
        ),
        'h6': Style(
          margin: Margins.only(left: 2, top: 32, right: 2),
          fontSize: FontSize.large,
        ),
        '*:not(h1):not(h2):not(h3):not(h4):not(h5):not(h6)': Style(
          fontSize: FontSize.xLarge,
          color: fontColor ?? Colors.white.withOpacity(0.87),
          fontWeight:
              fontFamily == 'Inter' ? FontWeight.w400 : FontWeight.normal,
        ),
        'body': Style(
          fontFamily: fontFamily,
          padding: HtmlPaddings.only(left: 4, right: 4),
        ),
        'strong': Style(
          fontWeight: FontWeight.bold,
        ),
        'p': Style(
          margin: Margins.zero,
          lineHeight: const LineHeight(1.5),
        ),
        'a': Style(
          color: Colors.blue,
          textDecoration: TextDecoration.underline,
        ),
        'li': Style(
          margin: Margins.only(top: 8),
          lineHeight: const LineHeight(1.5),
        ),
        'td': Style(
          border: const Border(
            bottom: BorderSide(color: Colors.grey),
          ),
          padding: HtmlPaddings.all(12),
          backgroundColor: Colors.white,
          color: Colors.black,
          fontSize: FontSize.medium,
        ),
        'th': Style(
          padding: HtmlPaddings.all(12),
          backgroundColor: const Color.fromRGBO(0xdf, 0xdf, 0xe2, 1),
          color: Colors.black,
        ),
        'th strong': Style(
          color: Colors.black,
          fontSize: FontSize.medium,
        ),
        'figure': Style(
          margin: Margins.zero,
          textAlign: TextAlign.center,
        ),
        'figcaption': Style(
          fontSize: FontSize.medium,
        ),
        'code': Style(
          backgroundColor: const Color.fromRGBO(0x3b, 0x3b, 0x4f, 0.5),
          padding: HtmlPaddings.symmetric(vertical: 2, horizontal: 4),
          color: Colors.white.withOpacity(0.87),
          fontSize: FontSize.xLarge,
          fontFamily: 'Roboto Mono',
        ),
      },
      onLinkTap: (url, attributes, element) {
        launchUrl(Uri.parse(url!.trim()));
      },
      extensions: [
        const TableHtmlExtension(),
        TagExtension(
          tagsToExtend: {'pre'},
          builder: (child) {
            var codeElement = child.element!.children.isNotEmpty
                ? child.element!.children.first // code element
                : child.element!; // pre element
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

            List classes = codeElement.classes.toList();

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
                          minWidth: MediaQuery.of(context).size.width - 25,
                        ),
                        child: HighlightView(
                          codeElement.text,
                          padding: const EdgeInsets.all(16),
                          language: codeLanguageIsPresent(classes)
                              ? currentClass!.split('-')[1]
                              : 'plaintext',
                          theme: themeMap['atom-one-dark']!,
                          textStyle: TextStyle(
                            fontFamily: 'RobotoMono',
                            fontSize: double.parse(
                              FontSize.large.value.toString(),
                            ),
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            );
          },
        ),
        TagExtension(
          tagsToExtend: {'iframe'},
          builder: (child) {
            var isVideo = RegExp('youtube', caseSensitive: false);
            var videoUrl = child.attributes['src'];
            if (isVideo.hasMatch(videoUrl ?? '')) {
              var videoId = videoUrl?.split('/').last.split('?').first;

                YoutubePlayerController controller =
                    YoutubePlayerController.fromVideoId(
                  videoId: videoId!,
                  autoPlay: false,
                  params: const YoutubePlayerParams(
                    showControls: true,
                    showFullscreenButton: true,
                  ),
                );

              return YoutubePlayer(
                enableFullScreenOnVerticalDrag: false,
                controller: controller,
              );
            }

            return Container();
          },
        ),
        TagExtension(
          tagsToExtend: {'img'},
          builder: (child) {
            var imgUrl = child.attributes['src'] ?? '';
            bool isDataUrl = Uri.parse(imgUrl).scheme == 'data';
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: InkWell(
                onTap: () => goToImageView(imgUrl, context, isDataUrl),
                child: isDataUrl
                    ? Image.memory(
                        base64Decode(imgUrl.split(',').last),
                      )
                    : CachedNetworkImage(
                        imageUrl: imgUrl,
                      ),
              ),
            );
          },
        ),
        TagExtension(
          tagsToExtend: {'blockquote'},
          builder: (child) {
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                decoration: const BoxDecoration(
                  border: Border(
                    left: BorderSide(
                      color: Color.fromRGBO(0x99, 0xc9, 0xff, 1),
                      width: 2,
                    ),
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    child.innerHtml,
                    style: TextStyle(
                      fontSize: double.tryParse(
                        FontSize.xLarge.value.toString(),
                      ),
                      fontFamily: 'Lato',
                      color: Colors.white.withOpacity(0.87),
                    ),
                  ),
                ),
              ),
            );
          },
        )
      ],
    );

    if (isSelectable) {
      return SelectionArea(child: htmlWidget);
    } else {
      return htmlWidget;
    }
  }
}
