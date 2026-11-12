import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:freecodecamp/fcc_theme.dart';
import 'package:html/parser.dart' show parseFragment;

const _handleHeight = 28.0;

class ResizablePanelController extends ChangeNotifier {
  bool _expanded = true;
  double? _height;

  bool get expanded => _expanded;
  double? get height => _height;

  void update({bool? expanded, double? height, bool clearHeight = false}) {
    final nextExpanded = expanded ?? _expanded;
    final nextHeight = clearHeight ? null : (height ?? _height);
    if (nextExpanded == _expanded && nextHeight == _height) {
      return;
    }
    _expanded = nextExpanded;
    _height = nextHeight;
    notifyListeners();
  }

  void reset() => update(expanded: true, clearHeight: true);
}

class ResizablePanel extends StatefulWidget {
  const ResizablePanel({
    super.key,
    required this.title,
    required this.summaryHtml,
    required this.maxHeight,
    this.maxFraction = 1,
    required this.child,
    this.controller,
  });

  final String title;
  final String summaryHtml;
  final double maxHeight;
  final double maxFraction;
  final Widget child;
  final ResizablePanelController? controller;

  @override
  State<ResizablePanel> createState() => _ResizablePanelState();
}

class _ResizablePanelState extends State<ResizablePanel> {
  final _headerKey = GlobalKey();
  final _bodyKey = GlobalKey();
  late final ResizablePanelController _ownController;
  double? _dragHeight;
  double? _headerHeight;

  ResizablePanelController get _controller =>
      widget.controller ?? _ownController;

  @override
  void initState() {
    super.initState();
    _ownController = ResizablePanelController();
    _controller.addListener(_rebuild);
  }

  @override
  void didUpdateWidget(ResizablePanel oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.controller != widget.controller) {
      (oldWidget.controller ?? _ownController).removeListener(_rebuild);
      _controller.addListener(_rebuild);
    }
  }

  @override
  void dispose() {
    _controller.removeListener(_rebuild);
    _ownController.dispose();
    super.dispose();
  }

  void _rebuild() {
    if (mounted) {
      setState(() {});
    }
  }

  void _measureHeader() {
    if (!mounted) {
      return;
    }
    final header = _headerKey.currentContext?.size?.height;
    if (header != _headerHeight) {
      setState(() => _headerHeight = header);
    }
  }

  double _maxBodyHeight(BuildContext context) {
    final scale = MediaQuery.textScalerOf(context);
    final header = _headerHeight ?? math.max(44.0, scale.scale(14) * 1.5 + 22);
    return math.max(
      0.0,
      widget.maxHeight * widget.maxFraction - header - _handleHeight,
    );
  }

  void _dragStart(double bodyHeight) {
    _dragHeight = _controller.expanded
        ? _bodyKey.currentContext?.size?.height ?? bodyHeight
        : 0;
  }

  void _dragUpdate(DragUpdateDetails details, double maxBodyHeight) {
    final height = ((_dragHeight ?? 0) + details.delta.dy).clamp(
      0.0,
      maxBodyHeight,
    );
    setState(() => _dragHeight = height);
    _controller.update(expanded: height > 0);
  }

  void _dragEnd(double maxBodyHeight) {
    final height = _dragHeight;
    if (height == null) {
      return;
    }
    final expanded = height >= math.min(48, maxBodyHeight) && height > 0;
    setState(() => _dragHeight = null);
    _controller.update(expanded: expanded, height: expanded ? height : null);
  }

  Widget _dragRegion(
    double bodyHeight,
    double maxBodyHeight, {
    required Widget child,
  }) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onVerticalDragStart: (_) => _dragStart(bodyHeight),
      onVerticalDragUpdate: (details) => _dragUpdate(details, maxBodyHeight),
      onVerticalDragEnd: (_) => _dragEnd(maxBodyHeight),
      onVerticalDragCancel: () => _dragEnd(maxBodyHeight),
      child: child,
    );
  }

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) => _measureHeader());
    final colors = Theme.of(context).colorScheme;
    final fcc = FccDesignColors.of(context);
    final expanded = _controller.expanded;
    final dragging = _dragHeight != null;
    final instant = dragging || MediaQuery.disableAnimationsOf(context);
    final maxBodyHeight = _maxBodyHeight(context);
    final customHeight = _dragHeight ?? _controller.height;
    final defaultBodyHeight = math.min(
      MediaQuery.viewInsetsOf(context).bottom > 0 ? 140.0 : 220.0,
      widget.maxHeight * .32,
    );
    final bodyHeight = (customHeight ?? defaultBodyHeight).clamp(
      0.0,
      maxBodyHeight,
    );
    final summary =
        parseFragment(
          widget.summaryHtml,
        ).text?.replaceAll(RegExp(r'\s+'), ' ').trim() ??
        '';
    return Material(
      color: fcc.editorHighlight,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _dragRegion(
            bodyHeight,
            maxBodyHeight,
            child: Semantics(
              button: true,
              expanded: expanded,
              child: InkWell(
                onTap: () => _controller.update(expanded: !expanded),
                child: Container(
                  key: _headerKey,
                  constraints: const BoxConstraints(minHeight: 44),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 10,
                  ),
                  decoration: BoxDecoration(
                    border: Border.symmetric(
                      horizontal: BorderSide(color: colors.outlineVariant),
                    ),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.menu_book_outlined,
                        size: 18,
                        color: colors.primary,
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          expanded || summary.isEmpty ? widget.title : summary,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: expanded
                                ? FontWeight.w700
                                : FontWeight.w400,
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        expanded ? 'Hide' : 'Show',
                        style: TextStyle(
                          color: fcc.accentText,
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Icon(
                        expanded
                            ? Icons.keyboard_arrow_up
                            : Icons.keyboard_arrow_down,
                        color: colors.primary,
                        size: 18,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          AnimatedSize(
            // A zero duration makes AnimatedSize notify listeners inside its own layout.
            duration: instant
                ? const Duration(milliseconds: 1)
                : const Duration(milliseconds: 200),
            curve: Curves.easeInOut,
            alignment: Alignment.topCenter,
            child: AnimatedOpacity(
              duration: instant
                  ? Duration.zero
                  : const Duration(milliseconds: 200),
              opacity: expanded ? 1 : 0,
              child: expanded
                  ? Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        ConstrainedBox(
                          key: _bodyKey,
                          constraints: BoxConstraints(
                            minHeight: customHeight == null ? 0 : bodyHeight,
                            maxHeight: bodyHeight,
                          ),
                          child: widget.child,
                        ),
                        _dragRegion(
                          bodyHeight,
                          maxBodyHeight,
                          child: InkWell(
                            onTap: () => _controller.update(
                              height: bodyHeight >= maxBodyHeight - 1
                                  ? null
                                  : maxBodyHeight,
                              clearHeight: bodyHeight >= maxBodyHeight - 1,
                            ),
                            child: SizedBox(
                              height: _handleHeight,
                              width: double.infinity,
                              child: Icon(
                                Icons.drag_handle,
                                size: 20,
                                semanticLabel: 'Resize ${widget.title}',
                                color: colors.onSurfaceVariant,
                              ),
                            ),
                          ),
                        ),
                      ],
                    )
                  : const SizedBox(width: double.infinity),
            ),
          ),
        ],
      ),
    );
  }
}
