import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:freecodecamp/news/ui/widgets/back_button.dart';
import 'package:freecodecamp/news/ui/widgets/back_to_top_button.dart';
import 'package:freecodecamp/widgets/html_handler/html_handler.dart';
import 'package:share_plus/share_plus.dart';

class NewsArticleReader extends StatefulWidget {
  const NewsArticleReader({
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
  State<NewsArticleReader> createState() => _NewsArticleReaderState();
}

class _NewsArticleReaderState extends State<NewsArticleReader> {
  final _scrollController = ScrollController();
  final _progress = ValueNotifier<double>(0);
  final _shareButtonKey = GlobalKey();
  bool _progressUpdatePending = false;
  double _fontSize = 17;
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
  void didUpdateWidget(covariant NewsArticleReader oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.html != widget.html) _htmlWidgets = null;
  }

  void _updateProgress() {
    if (_progressUpdatePending) return;
    _progressUpdatePending = true;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _progressUpdatePending = false;
      if (!mounted || !_scrollController.hasClients) return;
      final position = _scrollController.position;
      _progress.value = position.maxScrollExtent <= 0
          ? 1
          : (position.pixels / position.maxScrollExtent).clamp(0, 1);
    });
    WidgetsBinding.instance.ensureVisualUpdate();
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
        'pre': Style(
          fontSize: FontSize((_fontSize - 5).clamp(13, double.infinity)),
        ),
        'h1': Style(
          fontSize: FontSize(_fontSize + 12),
          fontWeight: FontWeight.w800,
        ),
        'h2': Style(
          fontSize: FontSize(_fontSize + 3),
          fontWeight: FontWeight.w900,
        ),
        'h3': Style(
          fontSize: FontSize(_fontSize + 3),
          fontWeight: FontWeight.w700,
        ),
      },
    );

    return Scaffold(
      appBar: AppBar(
        leading: const NewsBackButton(),
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
                (17.0, 'Default'),
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
              tooltip: 'Share article',
              icon: const Icon(Icons.ios_share_rounded),
              onPressed: _share,
            ),
          widget.bookmarkButton,
          const SizedBox(width: 8),
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(4),
          child: ValueListenableBuilder<double>(
            valueListenable: _progress,
            builder: (_, value, _) => LinearProgressIndicator(
              value: value,
              minHeight: 4,
              color: colors.primary,
              backgroundColor: colors.outlineVariant,
            ),
          ),
        ),
      ),
      floatingActionButton: NewsBackToTopButton(
        controller: _scrollController,
        showAfter: 600,
      ),
      body: SafeArea(
        top: false,
        child: NotificationListener<ScrollMetricsNotification>(
          onNotification: (notification) {
            if (notification.depth == 0 &&
                notification.metrics.axis == Axis.vertical) {
              _updateProgress();
            }
            return false;
          },
          child: CustomScrollView(
            controller: _scrollController,
            slivers: [
              SliverToBoxAdapter(child: widget.header),
              SliverPadding(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                // Lay out article sections once so scrolling does not parse HTML
                // or change the estimated page height as new sections appear.
                sliver: SliverToBoxAdapter(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      for (final element in elements)
                        RepaintBoundary(child: element),
                    ],
                  ),
                ),
              ),
              if (widget.footer != null)
                SliverToBoxAdapter(child: widget.footer),
              const SliverToBoxAdapter(child: SizedBox(height: 48)),
            ],
          ),
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
