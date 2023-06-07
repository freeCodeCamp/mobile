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
import 'package:url_launcher/url_launcher_string.dart';
import 'package:youtube_player_iframe/youtube_player_iframe.dart';

class HTMLParser {
  const HTMLParser({
    Key? key,
    required this.context,
    this.fontFamily = 'Lato',
  });

  final String fontFamily;
  final BuildContext context;

  List<Widget> parse(String html) {
    dom.Document result = parser.parse(html);

    List<Widget> elements = [];

    for (int i = 0; i < result.body!.children.length; i++) {
      elements.add(
        _parseHTMLWidget(
          result.body!.children[i].outerHtml,
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

  Widget _parseHTMLWidget(child) {
    return SelectableRegion(
      selectionControls: materialTextSelectionControls,
      focusNode: FocusNode(),
      child: Html(
        shrinkWrap: true,
        data: child,
        style: {
          'body': Style(
            fontFamily: fontFamily,
            padding: HtmlPaddings.only(left: 4, right: 4),
          ),
          'blockquote': Style(fontSize: FontSize.medium),
          'p': Style(
            fontWeight:
                fontFamily == 'Inter' ? FontWeight.w400 : FontWeight.normal,
            fontSize: FontSize.larger,
            margin: Margins.zero,
            lineHeight: const LineHeight(1.5),
            color: fontFamily == 'Inter'
                ? const Color.fromRGBO(0xDF, 0xDF, 0xE2, 0.87)
                : Colors.white.withOpacity(0.87),
          ),
          'em': Style(
            fontSize: FontSize(110, Unit.percent),
          ),
          'strong': Style(
            fontSize: FontSize(110, Unit.percent),
          ),
          'a': Style(
            fontSize: FontSize(110, Unit.percent),
          ),
          'li': Style(
            margin: Margins.only(top: 8),
            fontSize: FontSize.larger,
            color: Colors.white.withOpacity(0.87),
            lineHeight: const LineHeight(1.5),
          ),
          'pre': Style(
            color: Colors.white,
            fontSize: FontSize.larger,
          ),
          'td': Style(
            border: const Border(
              bottom: BorderSide(color: Colors.grey),
            ),
            padding: HtmlPaddings.all(12),
            backgroundColor: Colors.white,
            color: Colors.black,
          ),
          'th': Style(
            padding: HtmlPaddings.all(12),
            backgroundColor: const Color.fromRGBO(0xdf, 0xdf, 0xe2, 1),
            color: Colors.black,
          ),
          'figure': Style(
            margin: Margins.zero,
            textAlign: TextAlign.center,
          ),
          'h1': Style(
            margin: Margins.only(left: 2, top: 32, right: 2),
            fontSize: FontSize.xxLarge,
          ),
          'h2': Style(
            margin: Margins.only(left: 2, top: 32, right: 2),
            fontSize: FontSize.xLarge,
          ),
          'h3': Style(
              margin: Margins.only(left: 2, top: 32, right: 2),
              fontSize: FontSize.xLarge),
          'h4': Style(
            margin: Margins.only(left: 2, top: 32, right: 2),
            fontSize: FontSize.larger,
          ),
          'h5': Style(
            margin: Margins.only(left: 2, top: 32, right: 2),
            fontSize: FontSize.large,
          ),
          'h6': Style(
            margin: Margins.only(left: 2, top: 32, right: 2),
            fontSize: FontSize.large,
          )
        },
        onLinkTap: (url, attributes, element) {
          launchUrlString(url!);
        },
        extensions: [
          const TableHtmlExtension(),
          TagWrapExtension(
            tagsToWrap: {'table'},
            builder: (child) {
              return SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: child,
              );
            },
          ),
          TagExtension(
            tagsToExtend: {'code'},
            builder: (child) {
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

              List classes = child.classes.toList();

              if (child.element!.parent!.localName == 'pre') {
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
                            child: HighlightView(child.element?.text ?? '',
                                padding: const EdgeInsets.all(16),
                                language: codeLanguageIsPresent(classes)
                                    ? currentClass!.split('-')[1]
                                    : 'plaintext',
                                theme: themeMap['atom-one-dark']!,
                                textStyle: const TextStyle(
                                  fontFamily: 'RobotoMono',
                                  fontSize: 16,
                                  color: Colors.white,
                                )),
                          ),
                        ),
                      ),
                    ),
                  ],
                );
              }

              return Stack(
                children: [
                  HighlightView(
                    child.element?.text ?? '',
                    padding: const EdgeInsets.symmetric(
                      horizontal: 4,
                      vertical: 0.2,
                    ),
                    language: 'html',
                    theme: themeMap['atom-one-dark']!,
                    textStyle: const TextStyle(
                      fontFamily: 'RobotoMono',
                      fontSize: 16,
                      color: Colors.white,
                    ),
                  ),
                  Text(
                    child.element?.text ?? '',
                    style: TextStyle(
                      fontSize: 1,
                      color: Colors.white.withOpacity(0),
                    ),
                  )
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

                YoutubePlayerController controller = YoutubePlayerController(
                  initialVideoId: videoId!,
                  params: const YoutubePlayerParams(
                    showControls: true,
                    showFullscreenButton: true,
                    autoPlay: false,
                  ),
                );

                return YoutubePlayerIFrame(
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
          TagWrapExtension(
            tagsToWrap: {'blockquote'},
            builder: (child) {
              return Container(
                decoration: const BoxDecoration(
                  border: Border(
                    left: BorderSide(
                      color: Color.fromRGBO(0x99, 0xc9, 0xff, 1),
                      width: 2,
                    ),
                  ),
                ),
                child: child,
              );
            },
          )
        ],
      ),
    );
  }
}
