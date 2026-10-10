import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:photo_view/photo_view.dart';
import 'package:share_plus/share_plus.dart';

class NewsImageView extends StatelessWidget {
  const NewsImageView({super.key, required this.imgUrl});

  final String imgUrl;

  bool get _isDataUrl => Uri.parse(imgUrl).scheme == 'data';

  @override
  Widget build(BuildContext context) => Scaffold(
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
                    text: imgUrl,
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
    body: Column(
      children: [
        Expanded(
          child: PhotoView(
            backgroundDecoration: const BoxDecoration(color: Colors.black),
            imageProvider: _isDataUrl
                ? MemoryImage(base64Decode(imgUrl.split(',').last))
                : NetworkImage(imgUrl),
            errorBuilder: (_, _, _) => const Center(
              child: Text(
                'Unable to load image',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ),
        ),
        const SafeArea(
          top: false,
          child: Padding(
            padding: EdgeInsets.all(20),
            child: Text(
              'Pinch or double-tap to zoom',
              style: TextStyle(color: Color(0xFFCFC6E6)),
            ),
          ),
        ),
      ],
    ),
  );
}
