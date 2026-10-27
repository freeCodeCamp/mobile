import 'dart:io';

import 'package:flutter/material.dart';
import 'package:freecodecamp/podcasts/models/podcast_model.dart';
import 'package:freecodecamp/podcasts/ui/widgets/podcast_artwork.dart';

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
    final colors = Theme.of(context).colorScheme;
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 20),
        child: Row(
          children: [
            PodcastArtwork(podcast: podcast, artwork: artwork, size: 60),
            const SizedBox(width: 14),
            Expanded(
              child: Text(
                podcast.title,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  height: 1.3,
                ),
              ),
            ),
            const SizedBox(width: 8),
            Icon(Icons.chevron_right_rounded, color: colors.onSurfaceVariant),
          ],
        ),
      ),
    );
  }
}
