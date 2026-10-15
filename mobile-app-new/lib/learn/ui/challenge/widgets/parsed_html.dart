import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:mobile_app_new/widgets/html_handler/html_handler.dart';

// Keep parsed content stable during answer edits, but refresh it when the
// theme, text scale, or content changes.
class ParsedHtml extends StatefulWidget {
  const ParsedHtml(
    this.html, {
    super.key,
    this.customStyles = const {},
    this.selectable = true,
    this.plainCodeBlocks = false,
    this.enableTapActions = true,
  });
  final String html;
  final Map<String, Style> customStyles;
  final bool selectable;
  final bool plainCodeBlocks;
  final bool enableTapActions;
  @override
  State<ParsedHtml> createState() => _ParsedHtmlState();
}

class _ParsedHtmlState extends State<ParsedHtml> {
  List<Widget>? _children;
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _children = null;
  }

  @override
  void didUpdateWidget(ParsedHtml oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.html != widget.html ||
        oldWidget.selectable != widget.selectable ||
        oldWidget.plainCodeBlocks != widget.plainCodeBlocks ||
        oldWidget.enableTapActions != widget.enableTapActions ||
        !mapEquals(oldWidget.customStyles, widget.customStyles)) {
      _children = null;
    }
  }

  List<Widget> _parse(BuildContext context) {
    final body = Style(
      fontSize: FontSize(16),
      lineHeight: const LineHeight(1.6),
    ).merge(widget.customStyles['*'] ?? Style());
    final styles = <String, Style>{
      '*': body,
      '*:not(h1):not(h2):not(h3):not(h4):not(h5):not(h6)': body,
      'body': Style(margin: Margins.zero, padding: HtmlPaddings.zero),
      'p': body,
      'li': body,
      'h1': Style(fontSize: FontSize(26)),
      'h2': Style(fontSize: FontSize(24)),
      'h3': Style(fontSize: FontSize(20)),
      'code': Style(fontSize: FontSize(16)),
      'pre': Style(fontSize: FontSize(13)),
    };
    for (final entry in widget.customStyles.entries) {
      styles[entry.key] = (styles[entry.key] ?? Style()).merge(entry.value);
    }
    // A curriculum answer may be plain text or mix text with inline markup.
    // Keep those text nodes together when the shared parser splits block roots.
    return HTMLParser(context: context).parse(
      '<div>${widget.html}</div>',
      isSelectable: widget.selectable,
      plainCodeBlocks: widget.plainCodeBlocks,
      enableTapActions: widget.enableTapActions,
      customStyles: styles,
    );
  }

  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: _children ??= _parse(context),
  );
}
