import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:freecodecamp/fcc_theme.dart';
import 'package:go_router/go_router.dart';
import 'package:photo_view/photo_view.dart';
import 'package:share_plus/share_plus.dart';

class NewsImageView extends StatefulWidget {
  const NewsImageView({
    super.key,
    required this.imgUrl,
    this.caption,
    this.alt,
  });

  final String imgUrl;
  final String? caption;
  final String? alt;

  @override
  State<NewsImageView> createState() => _NewsImageViewState();
}

class _NewsImageViewState extends State<NewsImageView> {
  final _controller = PhotoViewController();
  final _pointers = <int>{};
  Offset? _dragStart;
  double? _initialScale;

  bool get _isDataUrl => Uri.tryParse(widget.imgUrl)?.scheme == 'data';
  bool get _atInitialScale =>
      _initialScale == null ||
      (_controller.scale ?? _initialScale!) <= _initialScale! * 1.03;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  // Observe pointers without taking the gesture arena away from PhotoView.
  // A pinch or a pan of a zoomed image must never dismiss the viewer.
  void _pointerDown(PointerDownEvent event) {
    _pointers.add(event.pointer);
    _initialScale ??= _controller.scale;
    _dragStart = _pointers.length == 1 && _atInitialScale
        ? event.position
        : null;
  }

  void _pointerUp(PointerUpEvent event) {
    final start = _dragStart;
    if (_pointers.length == 1 && start != null && _atInitialScale) {
      final delta = event.position - start;
      if (delta.dy > 100 && delta.dy > delta.dx.abs() * 1.5) context.pop();
    }
    _pointers.remove(event.pointer);
    _dragStart = null;
  }

  @override
  Widget build(BuildContext context) {
    final caption = widget.caption?.trim();
    final alt = widget.alt?.trim();
    final description = caption?.isNotEmpty == true ? caption! : alt ?? '';
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
        leading: IconButton(
          tooltip: 'Close image',
          onPressed: () => context.pop(),
          icon: const Icon(Icons.close_rounded),
        ),
        actions: [
          if (!_isDataUrl)
            Builder(
              builder: (context) => IconButton(
                tooltip: 'Share image',
                icon: const Icon(Icons.ios_share_rounded),
                onPressed: () {
                  final box = context.findRenderObject() as RenderBox?;
                  SharePlus.instance.share(
                    ShareParams(
                      text: widget.imgUrl,
                      sharePositionOrigin: box == null
                          ? null
                          : box.localToGlobal(Offset.zero) & box.size,
                    ),
                  );
                },
              ),
            ),
        ],
      ),
      body: LayoutBuilder(
        builder: (context, constraints) => Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: Listener(
                onPointerDown: _pointerDown,
                onPointerUp: _pointerUp,
                onPointerCancel: (event) {
                  _pointers.remove(event.pointer);
                  _dragStart = null;
                },
                child: Semantics(
                  image: true,
                  label: alt?.isNotEmpty == true ? alt : description,
                  child: PhotoView(
                    controller: _controller,
                    backgroundDecoration: const BoxDecoration(
                      color: Colors.black,
                    ),
                    imageProvider: _isDataUrl
                        ? MemoryImage(
                            base64Decode(widget.imgUrl.split(',').last),
                          )
                        : NetworkImage(widget.imgUrl),
                    errorBuilder: (_, _, _) => const Center(
                      child: Text(
                        'Unable to load image',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            ConstrainedBox(
              constraints: BoxConstraints(
                maxHeight: constraints.maxHeight * .35,
              ),
              child: SingleChildScrollView(
                child: SafeArea(
                  top: false,
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (description.isNotEmpty) ...[
                          Text(
                            description,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              height: 1.4,
                            ),
                          ),
                          const SizedBox(height: 6),
                        ],
                        Text(
                          'Double-tap to zoom · Swipe down to close',
                          style: TextStyle(
                            color:
                                FccTheme.themeDark.colorScheme.onSurfaceVariant,
                            height: 1.4,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
