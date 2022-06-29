// ignore_for_file: implementation_imports

import 'package:flutter/material.dart';
// import 'package:flutter_font_awesome_web_names/flutter_font_awesome.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:freecodecamp/models/forum/forum_post_model.dart';
import 'package:freecodecamp/ui/views/forum/forum-post/forum_post_viewmodel.dart';
import 'package:url_launcher/url_launcher_string.dart';
import 'package:html/dom.dart' as dom;
// import 'package:flutter_syntax_view_fcc/src/flutter_syntax_view.dart';
// import 'package:flutter_syntax_view_fcc/src/theme/theme.dart';
// import 'package:flutter_syntax_view_fcc/src/syntax/base.dart';

Column htmlView(PostModel post, BuildContext context, PostViewModel model) {
  return Column(
    children: [
      Row(
        children: [
          Expanded(
              child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Html(
              data: post.postCooked,
              style: {
                'body': Style(color: Colors.white),
                'blockquote': Style(
                    backgroundColor: const Color.fromRGBO(0x65, 0x65, 0x74, 1),
                    padding: const EdgeInsets.all(8)),
                'a': Style(fontSize: FontSize.rem(1)),
                'p': Style(
                    fontSize: FontSize.rem(1.2),
                    lineHeight: LineHeight.em(1.2)),
                'ul': Style(fontSize: FontSize.xLarge),
                'li': Style(
                  margin: const EdgeInsets.only(top: 8),
                  fontSize: FontSize.rem(1.35),
                ),
                'pre': Style(
                    color: Colors.white,
                    width: MediaQuery.of(context).size.width),
                'code': Style(
                    backgroundColor: const Color.fromRGBO(0x2A, 0x2A, 0x40, 1)),
                'tr': Style(
                    border:
                        const Border(bottom: BorderSide(color: Colors.grey)),
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
              },
              // customRender: {
              //   'table': (context, child) {
              //     return SingleChildScrollView(
              //       scrollDirection: Axis.horizontal,
              //       child:
              //           (context.tree as TableLayoutElement).toWidget(context),
              //     );
              //   },
              //   'code': (code, child) {
              //     var classList = code.tree.elementClasses;
              //     if (classList.isNotEmpty && classList[0] == 'lang-auto') {
              //       return ConstrainedBox(
              //         constraints: const BoxConstraints(
              //           minHeight: 1,
              //           maxHeight: 500,
              //         ),
              //         child: SyntaxView(
              //           code: code.tree.element?.text as String,
              //           syntax: Syntax.JAVASCRIPT,
              //           syntaxTheme: SyntaxTheme.vscodeDark(),
              //           fontSize: 16.0,
              //           withLinesCount: true,
              //           adjutableHeight: true,
              //           minWidth: MediaQuery.of(context).size.width,
              //           minHeight: 1,
              //         ),
              //       );
              //     }
              //   },
              //   'aside': (context, child) {
              //     var link =
              //         context.tree.element?.attributes['data-onebox-src'] ?? '';
              //     if (link.isNotEmpty) {
              //       return InkWell(
              //         onTap: () {
              //           launchUrlString(link);
              //         },
              //         child: Text(
              //           link,
              //           style: const TextStyle(
              //               color: Color.fromRGBO(0x22, 0x91, 0xeb, 1)),
              //         ),
              //       );
              //     }
              //   },
              //   'svg': (context, child) {
              //     var iconParent = context.tree.element!.className;
              //     var isFontAwesomeIcon = iconParent
              //         .toString()
              //         .contains(RegExp(r'fa ', caseSensitive: false));

              //     var iconChild =
              //         context.tree.element!.children[0].attributes.values;
              //     var iconParsed =
              //         iconChild.first.replaceFirst(RegExp(r'#'), '');

              //     List bannedIcons = ['far-image', 'discourse-expand'];

              //     if (isFontAwesomeIcon) {
              //       if (bannedIcons.contains(iconParsed)) {
              //         return Container();
              //       } else {
              //         return FaIcon(iconParsed);
              //       }
              //     }
              //   },
              //   'img': (context, child) {
              //     var classes = context.tree.element?.className;
              //     var classesSplit = classes?.split(' ');

              //     var classIsEmoji = classesSplit!.contains('emoji') ||
              //         classesSplit.contains('emoji-only');

              //     var emojiImage = context.tree.attributes['src'].toString();

              //     if (classIsEmoji) {
              //       return Image.network(
              //         emojiImage,
              //         height: 25,
              //         width: 25,
              //       );
              //     }
              //   },
              //   'div': (context, child) {
              //     var divClasses = context.tree.element?.className;

              //     var classList = divClasses?.split(' ');

              //     var classContainsMeta = classList!.contains('meta');
              //     if (classContainsMeta) {
              //       return Container();
              //     }
              //   }
              // },
              onLinkTap: (String? url, RenderContext context,
                  Map<String, String> attributes, dom.Element? element) {
                launchUrlString(url!);
              },
            ),
          ))
        ],
      ),
    ],
  );
}
