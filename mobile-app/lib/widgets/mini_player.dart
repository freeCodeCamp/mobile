import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:freecodecamp/code_radio/controllers/player_controller.dart';
import 'package:freecodecamp/fcc_theme.dart';
import 'package:freecodecamp/podcasts/controllers/player_controller.dart';
import 'package:freecodecamp/routing/code_radio.dart';
import 'package:freecodecamp/routing/podcasts.dart';
import 'package:freecodecamp/services/media_player_service.dart';

// A view of the already loaded source. Observing it never starts playback.
class MiniPlayer extends ConsumerWidget {
  const MiniPlayer({super.key, this.beforeNavigate});

  final Future<bool> Function()? beforeNavigate;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final player = ref.watch(mediaPlayerProvider);
    final item = player.item;
    if (!player.isVisible || item == null) return const SizedBox.shrink();
    if (player.isRadio && defaultTargetPlatform == TargetPlatform.iOS) {
      return const SizedBox.shrink();
    }
    final colors = Theme.of(context).colorScheme;
    final accent = FccDesignColors.of(context).accentText;
    final playback = player.playback;
    final isRadio = player.isRadio;
    final isBusy = player.isBusy;
    final episode = player.episode;
    final canOpen = isRadio || episode != null;

    return Padding(
      padding: const EdgeInsets.fromLTRB(12, 6, 12, 10),
      child: DecoratedBox(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: colors.shadow.withValues(
                alpha: colors.brightness == Brightness.dark ? .30 : .14,
              ),
              blurRadius: 24,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Material(
          color: colors.surface,
          clipBehavior: Clip.antiAlias,
          borderRadius: BorderRadius.circular(16),
          child: InkWell(
            onTap: !canOpen
                ? null
                : () async {
                    if (beforeNavigate != null && !await beforeNavigate!()) {
                      return;
                    }
                    if (!context.mounted) return;
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
                                  fontSize: 13,
                                ),
                              )
                            else
                              _PodcastTime(player: player),
                          ],
                        ),
                      ),
                      const SizedBox(width: 8),
                      IconButton.outlined(
                        tooltip: playback.playing
                            ? 'Pause audio'
                            : 'Resume audio',
                        onPressed: isBusy
                            ? null
                            : () async {
                                try {
                                  await ref
                                      .read(mediaPlayerProvider.notifier)
                                      .toggle(item.id);
                                } catch (_) {
                                  if (context.mounted) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        content: Text(
                                          'Unable to play audio. Please try again.',
                                        ),
                                      ),
                                    );
                                  }
                                }
                              },
                        style: IconButton.styleFrom(
                          foregroundColor: accent,
                          disabledForegroundColor: colors.outline,
                          fixedSize: const Size.square(48),
                          shape: const CircleBorder(),
                          side: BorderSide(color: accent, width: 1.5),
                        ),
                        icon: isBusy
                            ? SizedBox.square(
                                dimension: 22,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color: colors.outline,
                                ),
                              )
                            : Icon(
                                playback.playing
                                    ? Icons.pause_rounded
                                    : Icons.play_arrow_rounded,
                              ),
                      ),
                      IconButton(
                        tooltip: 'Dismiss player',
                        style: IconButton.styleFrom(
                          minimumSize: const Size.square(48),
                        ),
                        onPressed: () async {
                          try {
                            await ref
                                .read(mediaPlayerProvider.notifier)
                                .dismiss(item.id);
                          } catch (_) {
                            if (context.mounted) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text(
                                    'Unable to stop audio. Please try again.',
                                  ),
                                ),
                              );
                            }
                          }
                        },
                        icon: const Icon(Icons.close_rounded),
                      ),
                    ],
                  ),
                ),
                _MiniProgress(player: player),
              ],
            ),
          ),
        ),
      ),
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
      borderRadius: BorderRadius.circular(isRadio ? 10 : 8),
      child: SizedBox(
        width: isRadio ? 48 : 40,
        child: AspectRatio(
          aspectRatio: 1,
          child: ColoredBox(
            color: colors.surface,
            child: image == null
                ? fallback
                : Image(
                    image: image,
                    fit: BoxFit.contain,
                    errorBuilder: (_, _, _) => fallback,
                  ),
          ),
        ),
      ),
    );
  }
}

class _MiniProgress extends ConsumerWidget {
  const _MiniProgress({required this.player});

  final MediaPlayerState player;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (player.isRadio) {
      final radio = ref.watch(codeRadioNowPlayingProvider).value;
      final elapsed = ref.watch(codeRadioElapsedProvider).value ?? 0;
      final duration = radio?.nowPlaying.duration ?? 0;
      return _progress(context, duration <= 0 ? 0 : elapsed / duration);
    }

    final position =
        ref.watch(podcastPlaybackPositionProvider).value ??
        player.playback.position;
    final duration = player.duration;
    return _progress(
      context,
      duration == null || duration.inMilliseconds <= 0
          ? 0
          : position.inMilliseconds / duration.inMilliseconds,
    );
  }

  Widget _progress(BuildContext context, double value) {
    final colors = Theme.of(context).colorScheme;
    return LinearProgressIndicator(
      value: value.clamp(0, 1),
      minHeight: 3,
      color: colors.primary,
      backgroundColor: colors.outlineVariant,
      semanticsLabel: player.isRadio
          ? 'Live song progress'
          : 'Episode progress',
    );
  }
}

class _PodcastTime extends ConsumerWidget {
  const _PodcastTime({required this.player});
  final MediaPlayerState player;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final duration = player.duration;
    var position =
        ref.watch(podcastPlaybackPositionProvider).value ??
        player.playback.position;
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
        fontSize: 13,
      ),
    );
  }

  String _clock(Duration duration) {
    final seconds = (duration.inSeconds % 60).toString().padLeft(2, '0');
    if (duration.inHours > 0) {
      return '${duration.inHours}:${(duration.inMinutes % 60).toString().padLeft(2, '0')}:$seconds';
    }
    return '${duration.inMinutes}:$seconds';
  }
}
