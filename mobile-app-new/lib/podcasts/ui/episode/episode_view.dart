import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:html/parser.dart' as html_parser;
import 'package:mobile_app_new/fcc_theme.dart';
import 'package:mobile_app_new/podcasts/constants.dart';
import 'package:mobile_app_new/podcasts/controllers/player_controller.dart';
import 'package:mobile_app_new/podcasts/models/episode_model.dart';
import 'package:mobile_app_new/podcasts/models/podcast_model.dart';
import 'package:mobile_app_new/podcasts/ui/widgets/download_button.dart';
import 'package:mobile_app_new/podcasts/ui/widgets/episode_play_button.dart';
import 'package:mobile_app_new/podcasts/ui/widgets/podcast_artwork.dart';
import 'package:mobile_app_new/podcasts/ui/widgets/podcast_format.dart';
import 'package:url_launcher/url_launcher.dart';

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
  bool _isScrubbing = false;
  bool _showAllNotes = false;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final size = MediaQuery.sizeOf(context);
    final artworkSize = math.min(
      290.0,
      math.min(size.width - 96, size.height * .34),
    );
    final description =
        html_parser.parse(widget.episode.description).body?.text.trim() ?? '';
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          tooltip: 'Close player',
          icon: const Icon(Icons.keyboard_arrow_down_rounded),
          onPressed: () => Navigator.of(context).maybePop(),
        ),
        title: Text(
          widget.podcast.title,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: colors.onSurfaceVariant,
          ),
        ),
        centerTitle: true,
        actions: [
          Builder(
            builder: (buttonContext) => IconButton(
              tooltip: 'Share episode',
              onPressed: () => sharePodcast(
                buttonContext,
                widget.episode.title,
                widget.episode.audioUrl,
              ),
              icon: const Icon(Icons.ios_share_rounded, size: 22),
            ),
          ),
        ],
      ),
      body: SafeArea(
        top: false,
        child: ListView(
          padding: const EdgeInsets.fromLTRB(24, 14, 24, 28),
          physics: _isScrubbing ? const NeverScrollableScrollPhysics() : null,
          children: [
            Center(
              child: DecoratedBox(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(24),
                  boxShadow: [
                    BoxShadow(
                      color: colors.primary.withValues(alpha: .13),
                      blurRadius: 24,
                      offset: const Offset(0, 12),
                    ),
                  ],
                ),
                child: PodcastArtwork(
                  podcast: widget.podcast,
                  size: artworkSize,
                  radius: 24,
                ),
              ),
            ),
            const SizedBox(height: 22),
            Text(
              widget.episode.title,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w700,
                height: 1.25,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              [
                if (widget.episode.publicationDate != null)
                  podcastDate(widget.episode.publicationDate!),
                if (widget.episode.duration != null)
                  podcastDuration(widget.episode.duration),
              ].join(' · '),
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 14, color: colors.onSurfaceVariant),
            ),
            const SizedBox(height: 12),
            _Scrubber(
              episode: widget.episode,
              onScrubbingChanged: (value) =>
                  setState(() => _isScrubbing = value),
            ),
            const SizedBox(height: 14),
            _Controls(podcast: widget.podcast, episode: widget.episode),
            const SizedBox(height: 20),
            if (description.isNotEmpty)
              Container(
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  color: colors.surface,
                  borderRadius: BorderRadius.circular(18),
                  border: Border.all(color: colors.outlineVariant),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Show notes',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 8),
                    if (_showAllNotes)
                      Html(
                        data: widget.episode.description,
                        style: {
                          'body': Style(
                            margin: Margins.zero,
                            padding: HtmlPaddings.zero,
                            color: colors.onSurface,
                            fontSize: FontSize(16),
                          ),
                          'a': Style(
                            color: FccDesignColors.of(context).accentText,
                          ),
                        },
                        onLinkTap: (url, _, _) {
                          final uri = url == null ? null : Uri.tryParse(url);
                          if (uri != null &&
                              const [
                                'https',
                                'http',
                                'mailto',
                              ].contains(uri.scheme)) {
                            launchUrl(uri);
                          }
                        },
                      )
                    else
                      Text(
                        description,
                        maxLines: 3,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(fontSize: 16, height: 1.5),
                      ),
                    const SizedBox(height: 10),
                    TextButton(
                      style: TextButton.styleFrom(
                        padding: EdgeInsets.zero,
                        alignment: Alignment.centerLeft,
                      ),
                      onPressed: () =>
                          setState(() => _showAllNotes = !_showAllNotes),
                      child: Text(
                        _showAllNotes ? 'Show less' : 'Read all',
                        style: const TextStyle(
                          decoration: TextDecoration.underline,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
          ],
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

  @override
  Widget build(BuildContext context) {
    final player = ref.watch(podcastPlayerProvider);
    final current = player.isCurrent(widget.episode.id);
    final livePosition = current
        ? ref.watch(podcastPlaybackPositionProvider).value ?? Duration.zero
        : Duration.zero;
    final total = (current ? player.duration : null) ?? widget.episode.duration;
    final position = current ? _scrubbing ?? livePosition : Duration.zero;
    final hasDuration = total != null && total > Duration.zero;
    final seekable =
        current && hasDuration && !player.isBusyWith(widget.episode.id);
    final elapsed = position < Duration.zero
        ? Duration.zero
        : hasDuration && position > total
        ? total
        : position;
    final colors = Theme.of(context).colorScheme;
    return Column(
      children: [
        Listener(
          onPointerDown: (_) {
            if (seekable) widget.onScrubbingChanged(true);
          },
          onPointerUp: (_) => widget.onScrubbingChanged(false),
          onPointerCancel: (_) => widget.onScrubbingChanged(false),
          child: SliderTheme(
            data: SliderTheme.of(context).copyWith(
              trackHeight: 6,
              overlayShape: const RoundSliderOverlayShape(overlayRadius: 14),
              inactiveTrackColor: colors.outlineVariant,
            ),
            child: Slider(
              padding: const EdgeInsets.symmetric(vertical: 14),
              value: hasDuration
                  ? (elapsed.inMilliseconds / total.inMilliseconds).clamp(
                      0.0,
                      1.0,
                    )
                  : 0,
              onChanged: seekable
                  ? (value) => setState(() => _scrubbing = total * value)
                  : null,
              onChangeEnd: seekable
                  ? (value) {
                      // A different source may have loaded while the finger was down.
                      if (ref
                          .read(podcastPlayerProvider)
                          .isCurrent(widget.episode.id)) {
                        ref
                            .read(podcastPlayerProvider.notifier)
                            .seek(total * value);
                      }
                      setState(() => _scrubbing = null);
                    }
                  : null,
            ),
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              podcastTimestamp(elapsed),
              style: TextStyle(
                fontFamily: 'monospace',
                fontSize: 13,
                color: colors.onSurfaceVariant,
              ),
            ),
            Text(
              hasDuration ? '-${podcastTimestamp(total - elapsed)}' : '--:--',
              style: TextStyle(
                fontFamily: 'monospace',
                fontSize: 13,
                color: colors.onSurfaceVariant,
              ),
            ),
          ],
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
    final colors = Theme.of(context).colorScheme;
    final player = ref.watch(podcastPlayerProvider);
    final canControl =
        player.isCurrent(episode.id) && !player.isBusyWith(episode.id);
    final speed = canControl ? player.speed : 1.0;
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Flexible(
          child: OutlinedButton(
            style: OutlinedButton.styleFrom(
              backgroundColor: colors.surface,
              minimumSize: const Size(52, 48),
              padding: const EdgeInsets.symmetric(horizontal: 6),
              foregroundColor: colors.onSurface,
            ),
            onPressed: canControl
                ? () => _speedSheet(context, ref, speed)
                : null,
            child: FittedBox(
              child: Text(
                '${speed.toString().replaceFirst(RegExp(r'\.0$'), '')}×',
                style: const TextStyle(fontWeight: FontWeight.w700),
              ),
            ),
          ),
        ),
        Flexible(
          child: IconButton(
            tooltip: 'Rewind 10 seconds',
            iconSize: 30,
            icon: const Icon(Icons.replay_10_rounded),
            onPressed: canControl
                ? () {
                    if (ref.read(podcastPlayerProvider).isCurrent(episode.id)) {
                      ref.read(podcastPlayerProvider.notifier).rewind();
                    }
                  }
                : null,
          ),
        ),
        EpisodePlayButton(podcast: podcast, episode: episode, prominent: true),
        Flexible(
          child: IconButton(
            tooltip: 'Forward 30 seconds',
            iconSize: 30,
            icon: const Icon(Icons.forward_30_rounded),
            onPressed: canControl
                ? () {
                    if (ref.read(podcastPlayerProvider).isCurrent(episode.id)) {
                      ref.read(podcastPlayerProvider.notifier).fastForward();
                    }
                  }
                : null,
          ),
        ),
        Flexible(
          child: PodcastDownloadButton(
            podcast: podcast,
            episode: episode,
            outlined: true,
          ),
        ),
      ],
    );
  }

  Future<void> _speedSheet(
    BuildContext context,
    WidgetRef ref,
    double speed,
  ) async {
    final value = await showModalBottomSheet<double>(
      context: context,
      showDragHandle: true,
      builder: (context) {
        final colors = Theme.of(context).colorScheme;
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(22, 0, 22, 20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Playback speed',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
                ),
                const SizedBox(height: 16),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    for (final option in podcastSpeedOptions)
                      Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          ChoiceChip(
                            selected: speed == option,
                            showCheckmark: false,
                            selectedColor: colors.primary,
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 14,
                            ),
                            label: Text(
                              '${option.toString().replaceFirst(RegExp(r'\.0$'), '')}×',
                              style: TextStyle(
                                color: speed == option
                                    ? colors.onPrimary
                                    : colors.onSurface,
                                fontWeight: FontWeight.w700,
                                fontSize: 16,
                              ),
                            ),
                            onSelected: (_) =>
                                Navigator.of(context).pop(option),
                          ),
                          if (option == 1.0)
                            Padding(
                              padding: const EdgeInsets.only(top: 4),
                              child: Text(
                                'Normal',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: colors.onSurfaceVariant,
                                ),
                              ),
                            ),
                        ],
                      ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
    if (!context.mounted || value == null) return;
    if (ref.read(podcastPlayerProvider).isCurrent(episode.id)) {
      await ref.read(podcastPlayerProvider.notifier).setSpeed(value);
    }
  }
}
