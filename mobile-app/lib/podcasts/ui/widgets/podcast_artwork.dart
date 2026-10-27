import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:freecodecamp/podcasts/controllers/library_controller.dart';
import 'package:freecodecamp/podcasts/models/podcast_model.dart';

/// Reuses downloaded artwork so the listening screens also work offline.
class PodcastArtwork extends ConsumerWidget {
  const PodcastArtwork({
    super.key,
    required this.podcast,
    this.size = 64,
    this.radius = 12,
    this.artwork,
  });

  final Podcast podcast;
  final double size;
  final double radius;
  final File? artwork;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = Theme.of(context).colorScheme;
    final local =
        artwork ??
        ref.watch(
          podcastLibraryProvider.select(
            (state) => state.value?.artworkByPodcastId[podcast.id],
          ),
        );
    final fallback = ColoredBox(
      color: colors.surfaceContainer,
      child: Center(
        child: Icon(
          Icons.podcasts_rounded,
          size: size * .4,
          color: colors.primary,
        ),
      ),
    );

    return Container(
      width: size,
      height: size,
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        color: colors.surfaceContainer,
        borderRadius: BorderRadius.circular(radius),
        border: Border.all(color: colors.outlineVariant),
      ),
      child: local != null
          ? Image.file(
              local,
              fit: BoxFit.cover,
              errorBuilder: (_, _, _) => fallback,
            )
          : podcast.imageLink.isEmpty
          ? fallback
          : CachedNetworkImage(
              imageUrl: podcast.imageLink,
              fit: BoxFit.cover,
              placeholder: (_, _) => fallback,
              errorWidget: (_, _, _) => fallback,
            ),
    );
  }
}
