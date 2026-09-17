import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:mobile_app_new/fcc_theme.dart';
import 'package:mobile_app_new/podcasts/models/podcast_model.dart';

class PodcastGridTile extends StatelessWidget {
  const PodcastGridTile({
    super.key,
    required this.podcast,
    required this.onTap,
    this.artwork,
  });

  final Podcast podcast;
  final VoidCallback onTap;

  final File? artwork;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.all(4),
        child: Stack(
          fit: StackFit.expand,
          children: [
            ColoredBox(color: FccColors.gray90, child: _artwork()),
            Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              child: DecoratedBox(
                decoration: BoxDecoration(
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.75),
                      spreadRadius: 1.5,
                      blurRadius: 0.1,
                    ),
                  ],
                ),
                child: Text(
                  podcast.title,
                  maxLines: 2,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 16,
                    height: 1.2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _artwork() {
    if (artwork case final file?) return Image.file(file, fit: BoxFit.cover);

    if (podcast.imageLink.isEmpty) {
      return const Icon(Icons.podcasts, color: FccColors.gray45, size: 48);
    }

    return CachedNetworkImage(
      imageUrl: podcast.imageLink,
      fit: BoxFit.cover,
      errorWidget: (_, _, _) =>
          const Icon(Icons.podcasts, color: FccColors.gray45, size: 48),
    );
  }
}
