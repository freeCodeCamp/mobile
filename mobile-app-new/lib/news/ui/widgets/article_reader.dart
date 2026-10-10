import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:mobile_app_new/news/ui/widgets/back_to_top_button.dart';
import 'package:mobile_app_new/widgets/html_handler/html_handler.dart';
import 'package:share_plus/share_plus.dart';

/// The same reading controls are available for live and offline tutorials.
class ArticleReader extends StatefulWidget {
  const ArticleReader({
    super.key,
    required this.html,
    required this.header,
    required this.bookmarkButton,
    this.shareText,
    this.footer,
  });

  final String html;
  final Widget header;
  final Widget bookmarkButton;
  final String? shareText;
  final Widget? footer;

  @override
  State<ArticleReader> createState() => _ArticleReaderState();
}

class _ArticleReaderState extends State<ArticleReader> {
  final _scrollController = ScrollController();
  final _progress = ValueNotifier<double>(0);
  final _shareButtonKey = GlobalKey();
  double _fontSize = 18;
  List<Widget>? _htmlWidgets;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_updateProgress);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _htmlWidgets = null;
  }

  @override
  void didUpdateWidget(covariant ArticleReader oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.html != widget.html) _htmlWidgets = null;
  }

  void _updateProgress() {
    final extent = _scrollController.position.maxScrollExtent;
    _progress.value = extent <= 0
        ? 1
        : (_scrollController.offset / extent).clamp(0, 1);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _progress.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final elements = _htmlWidgets ??= HTMLParser(context: context).parse(
      widget.html,
      customStyles: {
        '*:not(h1):not(h2):not(h3):not(h4):not(h5):not(h6)': Style(
          fontSize: FontSize(_fontSize),
        ),
        'body': Style(
          padding: HtmlPaddings.zero,
          margin: Margins.zero,
          lineHeight: const LineHeight(1.65),
        ),
        'p': Style(
          fontSize: FontSize(_fontSize),
          lineHeight: const LineHeight(1.65),
          margin: Margins.only(top: 8, bottom: 12),
        ),
        'li': Style(
          fontSize: FontSize(_fontSize),
          lineHeight: const LineHeight(1.65),
        ),
        'code': Style(fontSize: FontSize(_fontSize - 2)),
        'pre': Style(fontSize: FontSize(_fontSize - 5)),
        'h1': Style(
          fontSize: FontSize(_fontSize + 12),
          fontWeight: FontWeight.w800,
        ),
        'h2': Style(
          fontSize: FontSize(_fontSize + 6),
          fontWeight: FontWeight.w800,
        ),
        'h3': Style(
          fontSize: FontSize(_fontSize + 3),
          fontWeight: FontWeight.w700,
        ),
      },
    );

    return Scaffold(
      appBar: AppBar(
        actions: [
          PopupMenuButton<double>(
            tooltip: 'Text size',
            initialValue: _fontSize,
            icon: const Text(
              'Aa',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
            ),
            onSelected: (size) => setState(() {
              _fontSize = size;
              _htmlWidgets = null;
            }),
            itemBuilder: (_) => [
              for (final option in [
                (16.0, 'Small'),
                (18.0, 'Default'),
                (22.0, 'Large'),
              ])
                CheckedPopupMenuItem(
                  value: option.$1,
                  checked: _fontSize == option.$1,
                  child: Text(option.$2),
                ),
            ],
          ),
          if (widget.shareText != null)
            IconButton(
              key: _shareButtonKey,
              tooltip: 'Share tutorial',
              icon: const Icon(Icons.ios_share_rounded),
              onPressed: _share,
            ),
          widget.bookmarkButton,
          const SizedBox(width: 8),
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(3),
          child: ValueListenableBuilder<double>(
            valueListenable: _progress,
            builder: (_, value, _) => LinearProgressIndicator(
              value: value,
              minHeight: 3,
              color: colors.primary,
              backgroundColor: colors.outlineVariant,
            ),
          ),
        ),
      ),
      floatingActionButton: BackToTopButton(
        controller: _scrollController,
        showAfter: 600,
      ),
      body: SafeArea(
        top: false,
        child: CustomScrollView(
          controller: _scrollController,
          slivers: [
            SliverToBoxAdapter(child: widget.header),
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
              sliver: SliverList.builder(
                itemCount: elements.length,
                itemBuilder: (_, index) => elements[index],
              ),
            ),
            if (widget.footer != null) SliverToBoxAdapter(child: widget.footer),
            const SliverToBoxAdapter(child: SizedBox(height: 48)),
          ],
        ),
      ),
    );
  }

  void _share() {
    final box =
        _shareButtonKey.currentContext?.findRenderObject() as RenderBox?;
    SharePlus.instance.share(
      ShareParams(
        text: widget.shareText,
        sharePositionOrigin: box == null
            ? null
            : box.localToGlobal(Offset.zero) & box.size,
      ),
    );
  }
}
