import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mobile_app_new/fcc_theme.dart';
import 'package:mobile_app_new/podcasts/constants.dart';
import 'package:mobile_app_new/podcasts/controllers/player_controller.dart';
import 'package:mobile_app_new/podcasts/models/episode_model.dart';
import 'package:mobile_app_new/podcasts/models/podcast_model.dart';
import 'package:mobile_app_new/podcasts/ui/widgets/download_button.dart';
import 'package:mobile_app_new/widgets/html_handler/html_handler.dart';

class PodcastEpisodeView extends StatefulWidget {
  const PodcastEpisodeView({
    super.key,
    required this.podcast,
    required this.episode,
  });

  final Podcast podcast;
  final Episode episode;

  @override
  State<PodcastEpisodeView> createState() => _PodcastEpisodeViewState();
}

class _PodcastEpisodeViewState extends State<PodcastEpisodeView> {
  List<Widget>? _description;

  bool _isScrubbing = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: ListView(
        physics: _isScrubbing ? const NeverScrollableScrollPhysics() : null,
        children: [
          _Artwork(imageUrl: widget.podcast.imageLink),
          Padding(
            padding: const EdgeInsets.all(8),
            child: Text(
              widget.episode.title,
              textAlign: TextAlign.center,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
            ),
          ),
          Text(
            widget.podcast.title,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 16),
          ),
          _Scrubber(
            episode: widget.episode,
            onScrubbingChanged: (value) => setState(() => _isScrubbing = value),
          ),
          _Controls(podcast: widget.podcast, episode: widget.episode),
          Padding(
            padding: const EdgeInsets.fromLTRB(8, 16, 8, 8),
            child: Column(children: _parsedDescription()),
          ),
        ],
      ),
    );
  }

  List<Widget> _parsedDescription() {
    if (widget.episode.description.isEmpty) return const [];

    return _description ??= HTMLParser(
      context: context,
    ).parse('<p>${widget.episode.description}</p>');
  }
}

class _Artwork extends StatelessWidget {
  const _Artwork({required this.imageUrl});

  final String imageUrl;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8),
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxHeight: MediaQuery.sizeOf(context).height * 0.4,
        ),
        child: AspectRatio(
          aspectRatio: 1,
          child: DecoratedBox(
            decoration: BoxDecoration(
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.3),
                  blurRadius: 10,
                  spreadRadius: 5,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: imageUrl.isEmpty
                ? const ColoredBox(color: FccColors.gray80)
                : CachedNetworkImage(imageUrl: imageUrl, fit: BoxFit.cover),
          ),
        ),
      ),
    );
  }
}

class _Scrubber extends ConsumerStatefulWidget {
  const _Scrubber({required this.episode, required this.onScrubbingChanged});

  final Episode episode;
  final ValueChanged<bool> onScrubbingChanged;

  @override
  ConsumerState<_Scrubber> createState() => _ScrubberState();
}

class _ScrubberState extends ConsumerState<_Scrubber> {
  Duration? _scrubbing;

  static String _format(Duration value) {
    final seconds = value.inSeconds;
    final hours = seconds ~/ 3600;
    final minutes = (seconds % 3600) ~/ 60;
    final rest = seconds % 60;
    String two(int n) => n.toString().padLeft(2, '0');

    return hours > 0
        ? '$hours:${two(minutes)}:${two(rest)}'
        : '$minutes:${two(rest)}';
  }

  @override
  Widget build(BuildContext context) {
    final player = ref.watch(
      podcastPlayerProvider.select((state) {
        final isCurrent = state.isCurrent(widget.episode.id);

        return (
          isCurrent: isCurrent,
          duration: isCurrent
              ? state.duration ?? widget.episode.duration
              : widget.episode.duration,
        );
      }),
    );

    final livePosition = player.isCurrent
        ? ref.watch(podcastPlaybackPositionProvider).value ?? Duration.zero
        : Duration.zero;

    final position = _scrubbing ?? livePosition;
    final total = player.duration;
    final isSeekable = total != null && total > Duration.zero;
    final elapsed = isSeekable && position > total ? total : position;

    return Column(
      children: [
        Listener(
          onPointerDown: (_) => widget.onScrubbingChanged(true),
          onPointerUp: (_) => widget.onScrubbingChanged(false),
          onPointerCancel: (_) => widget.onScrubbingChanged(false),
          child: Slider(
            value: isSeekable
                ? elapsed.inMilliseconds / total.inMilliseconds
                : 0,
            onChanged: isSeekable
                ? (value) => setState(() => _scrubbing = total * value)
                : null,
            onChangeEnd: isSeekable
                ? (value) {
                    ref
                        .read(podcastPlayerProvider.notifier)
                        .seek(total * value);
                    setState(() => _scrubbing = null);
                  }
                : null,
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(_format(elapsed), style: const TextStyle(fontSize: 16)),
              Text(
                isSeekable ? '-${_format(total - elapsed)}' : '--:--',
                style: const TextStyle(fontSize: 16),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _Controls extends ConsumerWidget {
  const _Controls({required this.podcast, required this.episode});

  final Podcast podcast;
  final Episode episode;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final status = ref.watch(
      podcastPlayerProvider.select(
        (state) => (
          isPlaying: state.isPlayingEpisode(episode.id),
          isBusy: state.isBusyWith(episode.id),
          speed: state.speed,
        ),
      ),
    );

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        DropdownButtonHideUnderline(
          child: DropdownButton<double>(
            value: podcastSpeedOptions.contains(status.speed)
                ? status.speed
                : 1.0,
            dropdownColor: FccColors.gray90,
            icon: const SizedBox.shrink(),
            onChanged: (value) {
              if (value != null) {
                ref.read(podcastPlayerProvider.notifier).setSpeed(value);
              }
            },
            items: [
              for (final option in podcastSpeedOptions)
                DropdownMenuItem(
                  value: option,
                  child: Text(
                    '${option}x',
                    style: const TextStyle(color: Colors.white),
                  ),
                ),
            ],
          ),
        ),
        const SizedBox(width: 8),
        IconButton(
          iconSize: 45,
          icon: const Icon(Icons.replay_10_rounded),
          onPressed: () => ref.read(podcastPlayerProvider.notifier).rewind(),
        ),
        IconButton(
          iconSize: 80,
          onPressed: () =>
              ref.read(podcastPlayerProvider.notifier).toggle(podcast, episode),
          icon: status.isBusy
              ? const SizedBox.square(
                  dimension: 80,
                  child: Padding(
                    padding: EdgeInsets.all(8),
                    child: CircularProgressIndicator(
                      color: FccColors.gray00,
                      strokeWidth: 2,
                    ),
                  ),
                )
              : Icon(status.isPlaying ? Icons.pause : Icons.play_arrow_rounded),
        ),
        IconButton(
          iconSize: 45,
          icon: const Icon(Icons.forward_30_rounded),
          onPressed: () =>
              ref.read(podcastPlayerProvider.notifier).fastForward(),
        ),
        PodcastDownloadButton(podcast: podcast, episode: episode, size: 45),
      ],
    );
  }
}
