import 'dart:async';
import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_html_table/flutter_html_table.dart';
import 'package:html/parser.dart' as parser;
import 'package:mobile_app_new/fcc_theme.dart';
import 'package:mobile_app_new/routing/news.dart';
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
  'strong': Style(fontWeight: FontWeight.bold),
  'a': Style(
    color: Colors.white,
    textDecoration: TextDecoration.underline,
    textDecorationColor: Colors.white,
  ),
  'p': Style(fontSize: FontSize(20), margin: Margins.only(top: 8, bottom: 8)),
  'li': Style(margin: Margins.only(top: 8), lineHeight: const LineHeight(1.5)),
  'td': Style(
    border: const Border(bottom: BorderSide(color: Colors.grey)),
    padding: HtmlPaddings.all(12),
    backgroundColor: Colors.white,
    color: Colors.black,
    fontSize: FontSize.medium,
  ),
  'th': Style(
    padding: HtmlPaddings.all(12),
    backgroundColor: FccColors.gray10,
    color: Colors.black,
  ),
  'th strong': Style(color: Colors.black, fontSize: FontSize.medium),
  'figure': Style(margin: Margins.zero, textAlign: TextAlign.center),
  'figcaption': Style(fontSize: FontSize.medium),
  'code': Style(
    fontFamily: 'Hack',
    backgroundColor: FccColors.gray75,
    color: Colors.white.withValues(alpha: 0.87),
    fontSize: FontSize.xLarge,
  ),
  'pre': Style(fontFamily: 'Hack'),
  // NOTE: Text within backticks in en-US, es, and zh-CN challenge files is
  // parsed into spans with this class.
  'span.highlighted-text': Style(
    backgroundColor: FccSemanticColors.backgroundTertiary,
  ),
};

class HTMLParser {
  const HTMLParser({Key? key, required this.context});

  final BuildContext context;

  List<Widget> parse(
    String html, {
    bool isSelectable = true,
    Map<String, Style> customStyles = const {},
  }) {
    final result = parser.parse(html);

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

  Widget _parseHTMLWidget(
    String child, [
    bool isSelectable = true,
    Map<String, Style> customStyles = const {},
  ]) {
    final colors = Theme.of(context).colorScheme;
    final themeStyles = <String, Style>{
      '*:not(h1):not(h2):not(h3):not(h4):not(h5):not(h6)': Style(
        color: colors.onSurface,
      ),
      'body': Style(color: colors.onSurface),
      for (final heading in ['h1', 'h2', 'h3', 'h4', 'h5', 'h6'])
        heading: Style(color: colors.onSurface),
      'a': Style(color: colors.primary, textDecorationColor: colors.primary),
      'td': Style(
        backgroundColor: colors.surface,
        color: colors.onSurface,
        border: Border(bottom: BorderSide(color: colors.outlineVariant)),
      ),
      'th': Style(
        backgroundColor: colors.surfaceContainerLow,
        color: colors.onSurface,
      ),
      'th strong': Style(color: colors.onSurface),
      'code': Style(
        backgroundColor: colors.surfaceContainerLow,
        color: colors.onSurface,
      ),
      'span.highlighted-text': Style(
        backgroundColor: colors.surfaceContainerLow,
      ),
    };
    Html htmlWidget = Html(
      shrinkWrap: true,
      data: child,
      style: mergeMaps(
        mergeMaps(defaultStyles, themeStyles, value: (s0, s1) => s0.merge(s1)),
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
                ? child
                      .element!
                      .children
                      .first // code element
                : child.element!; // pre element
            String? currentClass;

            bool codeLanguageIsPresent(List<String> classNames) {
              RegExp regExp = RegExp(r'\blang(uage)?\b');

              for (String className in classNames) {
                if (className.contains(regExp)) {
                  currentClass = className;
                  return true;
                }
              }

              return false;
            }

            List<String> classes = codeElement.classes.toList();

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

              if (videoId == null || videoId.isEmpty) {
                return const SizedBox.shrink();
              }
              return _YouTubeEmbed(key: ValueKey(videoId), videoId: videoId);
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
                    content: Text(
                      'Copied to clipboard: $parsed',
                      style: const TextStyle(fontSize: 20),
                    ),
                    duration: const Duration(seconds: 1),
                  ),
                );
              },
              child: Text(
                parsed,
                style: TextStyle(
                  fontFamily: 'Hack',
                  color: colors.onSurface,
                  fontSize: customStyles['code']?.fontSize?.value ?? 18,
                  backgroundColor: colors.surfaceContainerLow,
                ),
              ),
            );
          },
        ),
        TagExtension(
          tagsToExtend: {'img'},
          builder: (child) {
            var imgUrl = child.attributes['src'] ?? '';
            var isDataUrl = Uri.parse(imgUrl).scheme == 'data';
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: InkWell(
                onTap: () => NewsImageRoute($extra: imgUrl).push(context),
                child: isDataUrl
                    ? Image.memory(base64Decode(imgUrl.split(',').last))
                    : CachedNetworkImage(imageUrl: imgUrl),
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
              isSelectable: isSelectable,
              customStyles: customStyles,
            );

            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                decoration: BoxDecoration(
                  border: Border(
                    left: BorderSide(color: colors.primary, width: 2),
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(children: [...blockQuoteWidgets]),
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

/// Owns the platform player independently of HTML parsing and reader styling.
class _YouTubeEmbed extends StatefulWidget {
  const _YouTubeEmbed({super.key, required this.videoId});

  final String videoId;

  @override
  State<_YouTubeEmbed> createState() => _YouTubeEmbedState();
}

class _YouTubeEmbedState extends State<_YouTubeEmbed> {
  late YoutubePlayerController _controller;

  YoutubePlayerController _createController() =>
      YoutubePlayerController.fromVideoId(
        videoId: widget.videoId,
        autoPlay: false,
        params: const YoutubePlayerParams(
          showControls: true,
          showFullscreenButton: true,
          strictRelatedVideos: true,
          origin: 'https://www.youtube-nocookie.com',
        ),
      );

  @override
  void initState() {
    super.initState();
    _controller = _createController();
  }

  @override
  void didUpdateWidget(covariant _YouTubeEmbed oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.videoId != widget.videoId) {
      unawaited(_controller.close());
      _controller = _createController();
    }
  }

  @override
  void dispose() {
    unawaited(_controller.close());
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => YoutubePlayer(
    key: ValueKey(widget.videoId),
    enableFullScreenOnVerticalDrag: false,
    controller: _controller,
  );
}
