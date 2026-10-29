import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:freecodecamp/fcc_theme.dart';
import 'package:freecodecamp/podcasts/constants.dart';
import 'package:freecodecamp/podcasts/controllers/library_controller.dart';
import 'package:freecodecamp/podcasts/controllers/player_controller.dart';
import 'package:freecodecamp/podcasts/models/episode_model.dart';
import 'package:freecodecamp/podcasts/models/podcast_model.dart';
import 'package:freecodecamp/podcasts/ui/widgets/download_button.dart';
import 'package:freecodecamp/podcasts/ui/widgets/episode_play_button.dart';
import 'package:freecodecamp/podcasts/ui/widgets/podcast_artwork.dart';
import 'package:freecodecamp/podcasts/ui/widgets/podcast_format.dart';
import 'package:html/parser.dart' as html_parser;
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
                fontSize: 20,
                fontWeight: FontWeight.w900,
                height: 1.25,
              ),
            ),
            const SizedBox(height: 8),
            PodcastEpisodeMetadata(episode: widget.episode),
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
              thumbShape: const PodcastSeekThumb(),
              thumbColor: colors.primary,
              disabledThumbColor: colors.primary,
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
                fontFamily: 'JetBrains Mono',
                fontSize: 12,
                fontWeight: FontWeight.w700,
                color: colors.onSurfaceVariant,
              ),
            ),
            Text(
              hasDuration ? '-${podcastTimestamp(total - elapsed)}' : '--:--',
              style: TextStyle(
                fontFamily: 'JetBrains Mono',
                fontSize: 12,
                fontWeight: FontWeight.w700,
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
    final player = ref.watch(podcastPlayerProvider);
    final canControl =
        player.isCurrent(episode.id) && !player.isBusyWith(episode.id);
    final speed = canControl ? player.speed : 1.0;
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Flexible(
          child: OutlinedButton(
            style: FccTheme.compactOutlineStyle(context).copyWith(
              minimumSize: const WidgetStatePropertyAll(Size(52, 48)),
              padding: const WidgetStatePropertyAll(
                EdgeInsets.symmetric(horizontal: 6),
              ),
              shape: FccTheme.focusShape(context),
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
          child: PodcastSkipButton(
            seconds: 10,
            forward: false,
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
          child: PodcastSkipButton(
            seconds: 30,
            forward: true,
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
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 14,
                            ),
                            label: Text(
                              '${option.toString().replaceFirst(RegExp(r'\.0$'), '')}×',
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
                                  fontSize: 13,
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

class PodcastEpisodeMetadata extends ConsumerWidget {
  const PodcastEpisodeMetadata({super.key, required this.episode});
  final Episode episode;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final downloaded = ref.watch(
      podcastLibraryProvider.select(
        (library) =>
            library.value?.episodesByPodcastId[episode.podcastId]?.any(
              (saved) => saved.id == episode.id,
            ) ??
            false,
      ),
    );
    return Text(
      [
        if (episode.publicationDate != null)
          podcastDate(episode.publicationDate!),
        if (episode.duration != null) podcastDuration(episode.duration),
        if (downloaded) 'Downloaded',
      ].join(' · '),
      textAlign: TextAlign.center,
      style: TextStyle(
        fontSize: 13,
        color: Theme.of(context).colorScheme.onSurfaceVariant,
      ),
    );
  }
}

class PodcastSkipButton extends StatelessWidget {
  const PodcastSkipButton({
    super.key,
    required this.seconds,
    required this.forward,
    required this.onPressed,
  });
  final int seconds;
  final bool forward;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final label = '${forward ? 'Forward' : 'Rewind'} $seconds seconds';
    return Tooltip(
      message: label,
      child: Semantics(
        label: label,
        child: TextButton(
          onPressed: onPressed,
          style: ButtonStyle(
            foregroundColor: WidgetStateProperty.resolveWith(
              (states) => states.contains(WidgetState.disabled)
                  ? colors.outline
                  : colors.onSurface,
            ),
            minimumSize: const WidgetStatePropertyAll(Size(44, 52)),
            padding: const WidgetStatePropertyAll(EdgeInsets.all(4)),
            shape: FccTheme.focusShape(context, radius: 10),
          ),
          child: ExcludeSemantics(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Transform.flip(
                  flipX: forward,
                  child: const Icon(Icons.replay_rounded, size: 30),
                ),
                Text(
                  '$seconds',
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class PodcastSeekThumb extends SliderComponentShape {
  const PodcastSeekThumb();

  @override
  Size getPreferredSize(bool isEnabled, bool isDiscrete) => const Size(18, 18);

  @override
  void paint(
    PaintingContext context,
    Offset center, {
    required Animation<double> activationAnimation,
    required Animation<double> enableAnimation,
    required bool isDiscrete,
    required TextPainter labelPainter,
    required RenderBox parentBox,
    required SliderThemeData sliderTheme,
    required TextDirection textDirection,
    required double value,
    required double textScaleFactor,
    required Size sizeWithOverflow,
  }) {
    final circle = Path()..addOval(Rect.fromCircle(center: center, radius: 9));
    context.canvas.drawShadow(circle, Colors.black, 2, true);
    context.canvas.drawCircle(
      center,
      9,
      Paint()..color = sliderTheme.thumbColor!,
    );
    context.canvas.drawCircle(
      center,
      7.5,
      Paint()
        ..color = Colors.white
        ..style = PaintingStyle.stroke
        ..strokeWidth = 3,
    );
  }
}
