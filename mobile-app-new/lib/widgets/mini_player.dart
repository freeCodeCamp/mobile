import 'dart:io';

import 'package:audio_service/audio_service.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mobile_app_new/code_radio/ui/player/player_viewmodel.dart';
import 'package:mobile_app_new/routing/code_radio.dart';
import 'package:mobile_app_new/routing/podcasts.dart';
import 'package:mobile_app_new/services/audio_service.dart';

/// A view of the already loaded source. Observing it never starts playback.
class MiniPlayer extends ConsumerWidget {
  const MiniPlayer({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final handler = ref.watch(audioHandlerProvider);

    return StreamBuilder<MediaItem?>(
      stream: handler.mediaItem,
      initialData: handler.mediaItem.value,
      builder: (context, mediaSnapshot) {
        final item = mediaSnapshot.data;
        if (item == null) return const SizedBox.shrink();

        return StreamBuilder<PlaybackState>(
          stream: handler.playbackState,
          initialData: handler.playbackState.value,
          builder: (context, playbackSnapshot) {
            final isRadio = handler.codeRadioSongId != null;
            if (!isRadio && handler.episodeId == null) {
              return const SizedBox.shrink();
            }

            final colors = Theme.of(context).colorScheme;
            final playback = playbackSnapshot.data!;
            final isBusy =
                playback.processingState == AudioProcessingState.loading ||
                playback.processingState == AudioProcessingState.buffering;
            final episode = handler.currentPodcastEpisode;
            final canOpen = isRadio || episode != null;

            return Padding(
              padding: const EdgeInsets.fromLTRB(12, 6, 12, 10),
              child: Material(
                color: colors.surfaceContainer,
                clipBehavior: Clip.antiAlias,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(18),
                  side: BorderSide(color: colors.outlineVariant),
                ),
                child: InkWell(
                  onTap: !canOpen
                      ? null
                      : () {
                          if (isRadio) {
                            const CodeRadioRoute().go(context);
                          } else if (episode != null) {
                            PodcastEpisodeRoute(
                              podcastId: episode.$1.id,
                              episodeId: episode.$2.id,
                              $extra: episode,
                            ).push<void>(context);
                          }
                        },
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Padding(
                        padding: const EdgeInsets.fromLTRB(12, 10, 10, 10),
                        child: Row(
                          children: [
                            _MiniArtwork(uri: item.artUri, isRadio: isRadio),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    isRadio ? 'Code Radio' : item.title,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                  const SizedBox(height: 2),
                                  if (isRadio)
                                    Text(
                                      [
                                        item.title,
                                        if (item.artist?.isNotEmpty ?? false)
                                          item.artist!,
                                      ].join(' · '),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                        color: colors.onSurfaceVariant,
                                        fontSize: 12,
                                      ),
                                    )
                                  else
                                    _PodcastTime(handler: handler, item: item),
                                ],
                              ),
                            ),
                            const SizedBox(width: 8),
                            IconButton.filled(
                              tooltip: playback.playing
                                  ? 'Pause audio'
                                  : 'Resume audio',
                              onPressed: isBusy
                                  ? null
                                  : () {
                                      if (playback.playing) {
                                        handler.pause();
                                      } else {
                                        handler.play();
                                      }
                                    },
                              style: IconButton.styleFrom(
                                backgroundColor: colors.secondary,
                                foregroundColor: colors.onSecondary,
                                disabledBackgroundColor: colors.secondary,
                                fixedSize: const Size.square(44),
                              ),
                              icon: isBusy
                                  ? SizedBox.square(
                                      dimension: 22,
                                      child: CircularProgressIndicator(
                                        strokeWidth: 2,
                                        color: colors.onSecondary,
                                      ),
                                    )
                                  : Icon(
                                      playback.playing
                                          ? Icons.pause_rounded
                                          : Icons.play_arrow_rounded,
                                    ),
                            ),
                          ],
                        ),
                      ),
                      _MiniProgress(
                        handler: handler,
                        item: item,
                        isRadio: isRadio,
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }
}

class _MiniArtwork extends StatelessWidget {
  const _MiniArtwork({required this.uri, required this.isRadio});

  final Uri? uri;
  final bool isRadio;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final fallback = Icon(
      isRadio ? Icons.radio_rounded : Icons.headphones_rounded,
      color: colors.primary,
    );

    final imageUri = uri;
    final ImageProvider<Object>? image = imageUri == null
        ? null
        : imageUri.scheme == 'file'
        ? FileImage(File.fromUri(imageUri))
        : imageUri.scheme == 'https' || imageUri.scheme == 'http'
        ? CachedNetworkImageProvider(imageUri.toString())
        : null;

    return ClipRRect(
      borderRadius: BorderRadius.circular(8),
      child: SizedBox.square(
        dimension: 40,
        child: ColoredBox(
          color: colors.surface,
          child: image == null
              ? fallback
              : Image(
                  image: image,
                  fit: BoxFit.cover,
                  errorBuilder: (_, _, _) => fallback,
                ),
        ),
      ),
    );
  }
}

class _MiniProgress extends ConsumerWidget {
  const _MiniProgress({
    required this.handler,
    required this.item,
    required this.isRadio,
  });

  final AudioPlayerHandler handler;
  final MediaItem item;
  final bool isRadio;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (isRadio) {
      // Radio providers are observed only after a radio source has been loaded.
      final radio = ref.watch(codeRadioNowPlayingProvider).value;
      final elapsed = ref.watch(codeRadioElapsedProvider).value ?? 0;
      final duration = radio?.nowPlaying.duration ?? 0;
      return _progress(context, duration <= 0 ? 0 : elapsed / duration);
    }

    return StreamBuilder<Duration>(
      stream: handler.positionStream,
      initialData: handler.playbackState.value.position,
      builder: (context, snapshot) {
        final duration = handler.duration ?? item.duration;
        final position = snapshot.data ?? Duration.zero;
        return _progress(
          context,
          duration == null || duration.inMilliseconds <= 0
              ? 0
              : position.inMilliseconds / duration.inMilliseconds,
        );
      },
    );
  }

  Widget _progress(BuildContext context, double value) {
    final colors = Theme.of(context).colorScheme;
    return LinearProgressIndicator(
      value: value.clamp(0, 1),
      minHeight: 3,
      color: colors.primary,
      backgroundColor: colors.outlineVariant,
      semanticsLabel: isRadio ? 'Live song progress' : 'Episode progress',
    );
  }
}

class _PodcastTime extends StatelessWidget {
  const _PodcastTime({required this.handler, required this.item});
  final AudioPlayerHandler handler;
  final MediaItem item;

  @override
  Widget build(BuildContext context) => StreamBuilder<Duration>(
    stream: handler.positionStream,
    initialData: handler.playbackState.value.position,
    builder: (context, snapshot) {
      final duration = handler.duration ?? item.duration;
      var position = snapshot.data ?? Duration.zero;
      if (position.isNegative) position = Duration.zero;
      if (duration != null && duration > Duration.zero && position > duration) {
        position = duration;
      }
      final text = duration != null && duration > Duration.zero
          ? '${_clock(position)} of ${_clock(duration)}'
          : _clock(position);
      return Text(
        text,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: TextStyle(
          color: Theme.of(context).colorScheme.onSurfaceVariant,
          fontSize: 12,
        ),
      );
    },
  );

  String _clock(Duration duration) {
    final seconds = (duration.inSeconds % 60).toString().padLeft(2, '0');
    if (duration.inHours > 0) {
      return '${duration.inHours}:${(duration.inMinutes % 60).toString().padLeft(2, '0')}:$seconds';
    }
    return '${duration.inMinutes}:$seconds';
  }
}
