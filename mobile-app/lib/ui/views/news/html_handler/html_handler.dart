import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_html_table/flutter_html_table.dart';
import 'package:freecodecamp/ui/theme/fcc_theme.dart';
import 'package:freecodecamp/ui/views/news/news-image-viewer/news_image_view.dart';
import 'package:html/dom.dart' as dom;
import 'package:html/parser.dart' as parser;
import 'package:phone_ide/phone_ide.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:youtube_player_iframe/youtube_player_iframe.dart';

final Map<String, Style> defaultStyles = {
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
    color: Colors.white.withValues(alpha: 0.87),
  ),
  'body': Style(
    fontFamily: 'Lato',
    padding: HtmlPaddings.only(left: 4, right: 4),
  ),
  'strong': Style(
    fontWeight: FontWeight.bold,
  ),
  'a': Style(
    color: Colors.white,
    textDecoration: TextDecoration.underline,
    textDecorationColor: Colors.white,
  ),
  'p': Style(
    fontSize: FontSize(20),
    margin: Margins.only(top: 8, bottom: 8),
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
    fontFamily: 'Hack',
    backgroundColor: FccColors.gray75,
    color: Colors.white.withValues(alpha: 0.87),
    fontSize: FontSize.xLarge,
  ),
  'pre': Style(fontFamily: 'Hack')
};

class HTMLParser {
  const HTMLParser({
    Key? key,
    required this.context,
  });

  final BuildContext context;

  List<Widget> parse(
    String html, {
    bool isSelectable = true,
    Map<String, Style> customStyles = const {},
  }) {
    dom.Document result = parser.parse(html);

    List<Widget> elements = [];

    for (int i = 0; i < result.body!.children.length; i++) {
      elements.add(
        _parseHTMLWidget(
          result.body!.children[i].outerHtml,
          isSelectable,
          customStyles,
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
        settings: const RouteSettings(name: '/news-image'),
      ),
    );
  }

  Widget _parseHTMLWidget(
    child, [
    bool isSelectable = true,
    Map<String, Style> customStyles = const {},
  ]) {
    Html htmlWidget = Html(
      shrinkWrap: true,
      data: child,
      style: mergeMaps(
        defaultStyles,
        customStyles,
        value: (s0, s1) {
          return s0.merge(s1);
        },
      ),
      onLinkTap: (url, attributes, element) {
        launchUrl(Uri.parse(url!.trim()));
      },
      extensions: [
        TagWrapExtension(
          tagsToWrap: {'table'},
          builder: (child) {
            return SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: child,
            );
          },
        ),
        const TableHtmlExtension(),
        TagExtension(
          tagsToExtend: {'pre'},
          builder: (child) {
            var codeElement = child.element!.children.isNotEmpty
                ? child.element!.children.first // code element
                : child.element!; // pre element
            String? currentClass;

            bool codeLanguageIsPresent(List classNames) {
              RegExp regExp = RegExp(r'\blang(uage)?\b');

              for (String className in classNames) {
                if (className.contains(regExp)) {
                  currentClass = className;

                  return true;
                }
              }

              return false;
            }

            List classes = codeElement.classes.toList();

            return Editor(
              options: EditorOptions(
                fontFamily: 'Hack',
                takeFullHeight: false,
                isEditable: false,
                showLinebar: false,
              ),
              defaultLanguage: codeLanguageIsPresent(classes)
                  ? currentClass!.split('-')[1]
                  : '',
              defaultValue: codeElement.text.trimRight(),
              path: 'example',
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
                  strictRelatedVideos: true,
                  origin: 'https://www.youtube-nocookie.com',
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
          tagsToExtend: {'code'},
          builder: (child) {
            String? parsed = parser.parseFragment(child.innerHtml).text ?? '';

            return InkWell(
              onTap: () {
                Clipboard.setData(ClipboardData(text: parsed));
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text.rich(
                      TextSpan(
                        children: [
                          TextSpan(
                            text: parsed,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 20,
                            ),
                          ),
                          const TextSpan(
                            text: ' copied to clipboard!',
                            style: TextStyle(fontSize: 20),
                          ),
                        ],
                      ),
                    ),
                    duration: const Duration(seconds: 1),
                  ),
                );
              },
              child: Text(
                parsed,
                style: const TextStyle(
                  fontFamily: 'Hack',
                  color: Colors.white,
                  fontSize: 18,
                  backgroundColor: FccColors.gray75,
                ),
              ),
            );
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
          builder: (node) {
            HTMLParser innerParser = HTMLParser(context: context);
            List<Widget> blockQuoteWidgets = innerParser.parse(
              node.innerHtml,
            );

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
                  child: Column(
                    children: [...blockQuoteWidgets],
                  ),
                ),
              ),
            );
          },
        ),
      ],
    );

    if (isSelectable) {
      return SelectionArea(child: htmlWidget);
    } else {
      return htmlWidget;
    }
  }
}
