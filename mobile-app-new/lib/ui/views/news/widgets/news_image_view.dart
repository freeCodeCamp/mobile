import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mobile_app_new/fcc_theme.dart';
import 'package:photo_view/photo_view.dart';

class NewsImageView extends StatelessWidget {
  const NewsImageView({
    super.key,
    required this.imgUrl,
  });

  final String imgUrl;

  bool get _isDataUrl => Uri.parse(imgUrl).scheme == 'data';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        shadowColor: Colors.transparent,
        leading: Tooltip(
          message: 'Back',
          child: InkWell(
            onTap: () => context.pop(),
            child: const Icon(Icons.arrow_back),
          ),
        ),
      ),
      body: PhotoView(
        backgroundDecoration: const BoxDecoration(
          color: FccColors.gray80,
          backgroundBlendMode: BlendMode.color,
        ),
        imageProvider: _isDataUrl
            ? MemoryImage(base64Decode(imgUrl.split(',').last))
            : NetworkImage(imgUrl),
      ),
    );
  }
}
