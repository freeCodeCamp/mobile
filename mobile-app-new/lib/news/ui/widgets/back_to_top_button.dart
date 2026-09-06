import 'package:flutter/material.dart';
import 'package:mobile_app_new/fcc_theme.dart';

class BackToTopButton extends StatefulWidget {
  const BackToTopButton({
    super.key,
    required this.controller,
    this.showAfter = 100,
  });

  final ScrollController controller;
  final double showAfter;

  @override
  State<BackToTopButton> createState() => _BackToTopButtonState();
}

class _BackToTopButtonState extends State<BackToTopButton> {
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
    return AnimatedScale(
      scale: _visible ? 1 : 0,
      duration: const Duration(milliseconds: 200),
      curve: Curves.easeOut,
      child: Padding(
        // Lifts the button clear of the bottom action buttons.
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 64),
        child: FloatingActionButton(
          onPressed: _goToTop,
          shape: RoundedRectangleBorder(
            side: const BorderSide(width: 1, color: Colors.white),
            borderRadius: BorderRadius.circular(100),
          ),
          backgroundColor: FccColors.gray80,
          child: const Icon(
            Icons.keyboard_arrow_up,
            size: 40,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}
