import 'dart:math' as math;

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mobile_app_new/code_radio/models/code_radio_model.dart';
import 'package:mobile_app_new/code_radio/ui/player/player_viewmodel.dart';
import 'package:mobile_app_new/widgets/app_bottom_navigation.dart';
import 'package:mobile_app_new/widgets/error_retry.dart';
import 'package:mobile_app_new/widgets/listen_tabs.dart';
import 'package:mobile_app_new/widgets/app_page_title.dart';
import 'package:mobile_app_new/fcc_theme.dart';

class CodeRadioPlayerView extends ConsumerWidget {
  const CodeRadioPlayerView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final nowPlaying = ref.watch(codeRadioNowPlayingProvider);

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            automaticallyImplyLeading: false,
            centerTitle: false,
            toolbarHeight: AppPageTitle.toolbarHeight(context),
            title: const AppPageTitle('Listen'),
          ),
          const SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.fromLTRB(16, 8, 16, 0),
              child: ListenTabs(isRadio: true),
            ),
          ),
          switch (nowPlaying) {
            AsyncData(:final value) => SliverToBoxAdapter(
              child: _Player(radio: value),
            ),
            AsyncError() => SliverFillRemaining(
              hasScrollBody: false,
              child: ErrorRetry(
                message: 'Unable to load Code Radio.\nPlease try again.',
                onRetry: () => ref.invalidate(codeRadioNowPlayingProvider),
              ),
            ),
            AsyncLoading() => const SliverFillRemaining(
              hasScrollBody: false,
              child: Center(child: CircularProgressIndicator()),
            ),
          },
        ],
      ),
      bottomNavigationBar: const AppNavigationFooter(
        selected: AppDestination.listen,
        hideRadioPlayer: true,
      ),
    );
  }
}

class _Player extends StatelessWidget {
  const _Player({required this.radio});

  final CodeRadio radio;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 24, 16, 24),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 560),
          child: Column(
            children: [
              CodeRadioAlbumArt(radio: radio),
              const SizedBox(height: 18),
              CodeRadioNowPlaying(radio: radio),
              const SizedBox(height: 20),
              const CodeRadioPlayPauseButton(),
              const SizedBox(height: 20),
              CodeRadioNextSong(song: radio.playingNext.song),
            ],
          ),
        ),
      ),
    );
  }
}

class CodeRadioAlbumArt extends StatelessWidget {
  const CodeRadioAlbumArt({super.key, required this.radio});

  final CodeRadio radio;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final size = math.min(240.0, MediaQuery.sizeOf(context).width * 0.58);

    return Container(
      width: size,
      height: size,
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        color: colors.surfaceContainerLow,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: colors.outlineVariant),
        boxShadow: [
          BoxShadow(
            color: colors.primary.withValues(alpha: 0.15),
            blurRadius: 24,
            offset: const Offset(0, 12),
          ),
        ],
      ),
      child: _RadioArtwork(url: radio.nowPlaying.song.art, iconSize: 64),
    );
  }
}

class CodeRadioNowPlaying extends StatelessWidget {
  const CodeRadioNowPlaying({super.key, required this.radio});

  final CodeRadio radio;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return Column(
      children: [
        Text(
          radio.nowPlaying.song.title,
          textAlign: TextAlign.center,
          style: Theme.of(
            context,
          ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w800),
        ),
        const SizedBox(height: 6),
        Wrap(
          alignment: WrapAlignment.center,
          crossAxisAlignment: WrapCrossAlignment.center,
          spacing: 6,
          runSpacing: 4,
          children: [
            Text(
              '${radio.nowPlaying.song.artist} ·',
              style: TextStyle(color: colors.onSurfaceVariant),
            ),
            Icon(
              Icons.circle,
              color: FccDesignColors.of(context).success,
              size: 8,
            ),
            Text(
              'Live · ${radio.listeners.total} listening',
              style: TextStyle(color: colors.onSurfaceVariant),
            ),
          ],
        ),
        const SizedBox(height: 24),
        CodeRadioProgressBar(duration: radio.nowPlaying.duration),
      ],
    );
  }
}

class CodeRadioProgressBar extends ConsumerWidget {
  const CodeRadioProgressBar({super.key, required this.duration});

  final int duration;

  static String _format(int seconds) {
    final clamped = math.max(0, seconds);
    return '${clamped ~/ 60}:${(clamped % 60).toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = Theme.of(context).colorScheme;
    final elapsed = ref.watch(codeRadioElapsedProvider).value ?? 0;
    final current = elapsed.clamp(0, math.max(0, duration)).toInt();

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: Column(
        children: [
          LinearProgressIndicator(
            value: duration <= 0 ? 0 : current / duration,
            minHeight: 6,
            borderRadius: BorderRadius.circular(6),
            color: colors.primary,
            backgroundColor: colors.outlineVariant,
            semanticsLabel: 'Live song progress',
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                _format(current),
                style: TextStyle(color: colors.onSurfaceVariant),
              ),
              Text(
                duration > 0 ? '-${_format(duration - current)}' : 'Live',
                style: TextStyle(color: colors.onSurfaceVariant),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class CodeRadioNextSong extends StatelessWidget {
  const CodeRadioNextSong({super.key, required this.song});

  final Song song;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: colors.outlineVariant),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Up next',
            style: Theme.of(
              context,
            ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: SizedBox.square(
                  dimension: 48,
                  child: ColoredBox(
                    color: colors.surfaceContainerLow,
                    child: _RadioArtwork(url: song.art),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      song.title,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(fontWeight: FontWeight.w700),
                    ),
                    Text(
                      song.artist,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(color: colors.onSurfaceVariant),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class CodeRadioPlayPauseButton extends ConsumerStatefulWidget {
  const CodeRadioPlayPauseButton({super.key});

  @override
  ConsumerState<CodeRadioPlayPauseButton> createState() =>
      _CodeRadioPlayPauseButtonState();
}

class _CodeRadioPlayPauseButtonState
    extends ConsumerState<CodeRadioPlayPauseButton> {
  bool _busy = false;
  Future<void> _toggle() async {
    setState(() => _busy = true);
    try {
      await ref.read(codeRadioPlayerProvider.notifier).toggle();
    } catch (_) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Could not play Code Radio. Please try again.'),
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final isPlaying = ref.watch(codeRadioPlayerProvider);

    return DecoratedBox(
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: colors.secondary.withValues(alpha: 0.25),
            blurRadius: 20,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: IconButton.filled(
        tooltip: isPlaying ? 'Pause Code Radio' : 'Play Code Radio',
        onPressed: _busy ? null : _toggle,
        style: IconButton.styleFrom(
          backgroundColor: colors.secondary,
          foregroundColor: colors.onSecondary,
          fixedSize: const Size.square(76),
        ),
        icon: Icon(
          isPlaying ? Icons.pause_rounded : Icons.play_arrow_rounded,
          size: 38,
        ),
      ),
    );
  }
}

class _RadioArtwork extends StatelessWidget {
  const _RadioArtwork({required this.url, this.iconSize = 24});

  final String url;
  final double iconSize;

  @override
  Widget build(BuildContext context) {
    final fallback = Icon(
      Icons.music_note_rounded,
      size: iconSize,
      color: Theme.of(context).colorScheme.primary,
    );

    return url.isEmpty
        ? fallback
        : CachedNetworkImage(
            imageUrl: url,
            fit: BoxFit.cover,
            placeholder: (context, url) => fallback,
            errorWidget: (context, url, error) => fallback,
          );
  }
}
