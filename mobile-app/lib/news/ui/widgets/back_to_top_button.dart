import 'package:flutter/material.dart';

class NewsBackToTopButton extends StatefulWidget {
  const NewsBackToTopButton({
    super.key,
    required this.controller,
    this.showAfter = 100,
  });

  final ScrollController controller;
  final double showAfter;

  @override
  State<NewsBackToTopButton> createState() => _NewsBackToTopButtonState();
}

class _NewsBackToTopButtonState extends State<NewsBackToTopButton> {
  bool _visible = false;

  @override
  void initState() {
    super.initState();
    widget.controller.addListener(_handleScroll);
  }

  @override
  void dispose() {
    widget.controller.removeListener(_handleScroll);
    super.dispose();
  }

  void _handleScroll() {
    if (!widget.controller.hasClients) return;

    final shouldShow = widget.controller.offset >= widget.showAfter;
    if (shouldShow == _visible) return;
    setState(() => _visible = shouldShow);
  }

  void _goToTop() {
    widget.controller.animateTo(
      0,
      duration: const Duration(milliseconds: 1000),
      curve: Curves.easeInOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return AnimatedScale(
      scale: _visible ? 1 : 0,
      duration: const Duration(milliseconds: 200),
      curve: Curves.easeOut,
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: IconButton.filled(
          onPressed: _goToTop,
          tooltip: 'Back to top',
          style: IconButton.styleFrom(
            backgroundColor: colors.surfaceContainer,
            foregroundColor: colors.onSurface,
            minimumSize: const Size.square(48),
            elevation: 3,
            shadowColor: colors.shadow,
            side: BorderSide(color: colors.outlineVariant),
          ),
          icon: const Icon(Icons.keyboard_arrow_up, size: 32),
        ),
      ),
    );
  }
}
