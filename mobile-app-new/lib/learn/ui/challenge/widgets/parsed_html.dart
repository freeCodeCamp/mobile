import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:mobile_app_new/widgets/html_handler/html_handler.dart';

// NOTE: Parses once. Re-parsing on every parent rebuild recreates the code editors,
// and their re-measuring jumps the scroll position.
class ParsedHtml extends StatefulWidget {
  const ParsedHtml(this.html, {super.key, this.customStyles = const {}});

  final String html;
  final Map<String, Style> customStyles;

  @override
  State<ParsedHtml> createState() => _ParsedHtmlState();
}

class _ParsedHtmlState extends State<ParsedHtml> {
  List<Widget>? _children;

  @override
  void didUpdateWidget(ParsedHtml oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.html != widget.html) _children = null;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: _children ??= HTMLParser(
        context: context,
      ).parse(widget.html, customStyles: widget.customStyles),
    );
  }
}
