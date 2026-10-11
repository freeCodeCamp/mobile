import 'package:flutter/material.dart';

const _color = Colors.black;
const _size = 6.0;

// NOTE: Fades a shadow in at the top/bottom edge while there is more to scroll that way.
class ScrollShadow extends StatefulWidget {
  const ScrollShadow({super.key, required this.child});

  final Widget child;

  @override
  State<ScrollShadow> createState() => _ScrollShadowState();
}

class _ScrollShadowState extends State<ScrollShadow> {
  bool _showTop = false;
  bool _showBottom = false;

  bool _onMetrics(ScrollMetrics metrics) {
    final showTop = metrics.pixels > metrics.minScrollExtent;
    final showBottom = metrics.pixels < metrics.maxScrollExtent;

    if (showTop != _showTop || showBottom != _showBottom) {
      setState(() {
        _showTop = showTop;
        _showBottom = showBottom;
      });
    }
    return false;
  }

  Widget _shadow({required bool visible, required bool top}) {
    return Positioned(
      top: top ? 0 : null,
      bottom: top ? null : 0,
      left: 0,
      right: 0,
      child: IgnorePointer(
        child: AnimatedOpacity(
          opacity: visible ? 1 : 0,
          duration: const Duration(milliseconds: 250),
          curve: visible ? Curves.easeIn : Curves.easeOut,
          child: Container(
            height: _size,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: top ? Alignment.topCenter : Alignment.bottomCenter,
                end: top ? Alignment.bottomCenter : Alignment.topCenter,
                colors: [_color, _color.withAlpha(0)],
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        NotificationListener<ScrollMetricsNotification>(
          onNotification: (notification) => _onMetrics(notification.metrics),
          child: NotificationListener<ScrollNotification>(
            onNotification: (notification) => _onMetrics(notification.metrics),
            child: widget.child,
          ),
        ),
        _shadow(visible: _showTop, top: true),
        _shadow(visible: _showBottom, top: false),
      ],
    );
  }
}
