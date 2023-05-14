import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_html_table/flutter_html_table.dart';
import 'package:freecodecamp/ui/views/news/news-image-viewer/news_image_view.dart';
import 'package:html/dom.dart' as dom;
import 'package:html/parser.dart' as parser;

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

  void goToImageView(String imgUrl, BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => NewsImageView(
          imgUrl: imgUrl,
        ),
      ),
    );
  }

  Widget _parseHTMLWidget(
    child,
  ) {
    return SelectableRegion(
      selectionControls: materialTextSelectionControls,
      focusNode: FocusNode(),
      child: Html(
        shrinkWrap: true,
        data: child,
        style: {
          'body': Style(
            fontFamily: fontFamily,
            padding: const EdgeInsets.only(left: 4, right: 4),
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
          'li': Style(
            margin: Margins.only(top: 8),
            fontSize: FontSize.medium,
            color: Colors.white.withOpacity(0.87),
          ),
          'pre': Style(
            color: Colors.white,
            width: Width(
              MediaQuery.of(context).size.width,
            ),
            padding: const EdgeInsets.all(10),
            fontSize: FontSize.medium,
          ),
          'td': Style(
            border: const Border(
              bottom: BorderSide(color: Colors.grey),
            ),
            padding: const EdgeInsets.all(12),
            backgroundColor: Colors.white,
            color: Colors.black,
          ),
          'th': Style(
            padding: const EdgeInsets.all(12),
            backgroundColor: const Color.fromRGBO(0xdf, 0xdf, 0xe2, 1),
            color: Colors.black,
          ),
          'figure': Style(
            width: Width(MediaQuery.of(context).size.width),
            margin: Margins.zero,
          ),
          'h1': Style(
            margin: Margins.only(left: 2, top: 32, right: 2),
            fontSize: FontSize.xLarge,
          ),
          'h2': Style(
            margin: Margins.only(left: 2, top: 32, right: 2),
            fontSize: FontSize.larger,
          ),
          'h3': Style(
              margin: Margins.only(left: 2, top: 32, right: 2),
              fontSize: FontSize.large),
          'h4': Style(
            margin: Margins.only(left: 2, top: 32, right: 2),
            fontSize: FontSize.large,
          ),
          'h5': Style(
            margin: Margins.only(left: 2, top: 32, right: 2),
            fontSize: FontSize.medium,
          ),
          'h6': Style(
            margin: Margins.only(left: 2, top: 32, right: 2),
            fontSize: FontSize.medium,
          )
        },
        extensions: const [
          TableHtmlExtension(),
          // TagExtension(
          //   tagsToExtend: {'table'},
          //   builder: (extContext) {
          //     return SingleChildScrollView(
          //       scrollDirection: Axis.horizontal,
          //       child: extContext.node as TableElement
          //     );
          //   },
          // )
        ],
      ),
    );
  }
}
