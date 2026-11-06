import 'dart:math' as math;

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:freecodecamp/code_radio/controllers/player_controller.dart';
import 'package:freecodecamp/code_radio/models/code_radio_model.dart';
import 'package:freecodecamp/code_radio/ui/player/player_viewmodel.dart';
import 'package:freecodecamp/fcc_theme.dart';
import 'package:freecodecamp/widgets/app_bottom_navigation.dart';
import 'package:freecodecamp/widgets/error_retry.dart';
import 'package:freecodecamp/widgets/listen_header.dart';

const _radioSecondaryText = Color(0xFFE3DDFF);
const _radioYellow = Color(0xFFFFC83D);

class CodeRadioPlayerView extends ConsumerWidget {
  const CodeRadioPlayerView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final nowPlaying = ref.watch(codeRadioNowPlayingProvider);

    return Scaffold(
      body: AnnotatedRegion<SystemUiOverlayStyle>(
        value: const SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
          statusBarIconBrightness: Brightness.light,
          statusBarBrightness: Brightness.dark,
        ),
        child: DecoratedBox(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Color(0xFF5148C8), Color(0xFF3E329C), Color(0xFF241B52)],
            ),
          ),
          child: SafeArea(
            bottom: false,
            child: CustomScrollView(
              slivers: [
                const SliverToBoxAdapter(child: ListenHeader(isRadio: true)),
                switch (nowPlaying) {
                  AsyncData(:final value) => SliverToBoxAdapter(
                    child: _Player(radio: value),
                  ),
                  AsyncError() => SliverFillRemaining(
                    hasScrollBody: false,
                    child: ErrorRetry(
                      message: 'Unable to load Code Radio.\nPlease try again.',
                      onRetry: () =>
                          ref.invalidate(codeRadioNowPlayingProvider),
                    ),
                  ),
                  AsyncLoading() => const SliverToBoxAdapter(
                    child: CodeRadioSkeleton(),
                  ),
                },
              ],
            ),
          ),
        ),
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
      padding: const EdgeInsets.all(24),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 340),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              CodeRadioAlbumArt(radio: radio),
              const SizedBox(height: 24),
              CodeRadioNowPlaying(radio: radio),
              const SizedBox(height: 24),
              CodeRadioProgressBar(duration: radio.nowPlaying.duration),
              const SizedBox(height: 24),
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
    return LayoutBuilder(
      builder: (context, constraints) {
        final size = math.min(340.0, constraints.maxWidth);
        return Container(
          width: size,
          clipBehavior: Clip.antiAlias,
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: .12),
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: .25),
                blurRadius: 28,
                offset: const Offset(0, 12),
              ),
            ],
          ),
          child: _RadioArtwork(
            url: radio.nowPlaying.song.art,
            size: size,
            iconSize: 64,
          ),
        );
      },
    );
  }
}

class CodeRadioNowPlaying extends StatelessWidget {
  const CodeRadioNowPlaying({super.key, required this.radio});

  final CodeRadio radio;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                radio.nowPlaying.song.title,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 22,
                  fontWeight: FontWeight.w900,
                  height: 1.2,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                '${radio.nowPlaying.song.artist} · ${radio.listeners.total} listening',
                style: const TextStyle(
                  fontSize: 13,
                  color: _radioSecondaryText,
                  height: 1.4,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(width: 16),
        const CodeRadioPlayPauseButton(),
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
    final elapsed = ref.watch(codeRadioElapsedProvider).value ?? 0;
    final current = elapsed.clamp(0, math.max(0, duration)).toInt();

    return Column(
      children: [
        LinearProgressIndicator(
          value: duration <= 0 ? 0 : current / duration,
          minHeight: 6,
          borderRadius: BorderRadius.circular(6),
          color: Colors.white,
          backgroundColor: Colors.white.withValues(alpha: .25),
          semanticsLabel: 'Song progress',
        ),
        const SizedBox(height: 12),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              _format(current),
              style: const TextStyle(
                fontFamily: 'JetBrains Mono',
                fontSize: 12,
                fontWeight: FontWeight.w400,
                color: Colors.white,
              ),
            ),
            Text(
              '-${_format(duration - current)}',
              style: const TextStyle(
                fontFamily: 'JetBrains Mono',
                fontSize: 12,
                fontWeight: FontWeight.w400,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class CodeRadioNextSong extends StatelessWidget {
  const CodeRadioNextSong({super.key, required this.song});

  final Song song;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.only(top: 20),
      decoration: BoxDecoration(
        border: Border(
          top: BorderSide(color: Colors.white.withValues(alpha: .18)),
        ),
      ),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: SizedBox(
              width: 48,
              child: ColoredBox(
                color: Colors.white.withValues(alpha: .12),
                child: _RadioArtwork(url: song.art, size: 48),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Up next',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    color: _radioSecondaryText,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  song.title,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  song.artist,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 13,
                    color: _radioSecondaryText,
                  ),
                ),
              ],
            ),
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
    final isPlaying = ref.watch(codeRadioPlayerProvider);

    return DecoratedBox(
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: .16),
            blurRadius: 20,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: IconButton.filled(
        tooltip: isPlaying ? 'Pause Code Radio' : 'Play Code Radio',
        onPressed: _busy ? null : _toggle,
        style:
            IconButton.styleFrom(
              backgroundColor: _radioYellow,
              foregroundColor: const Color(0xFF241B52),
              disabledBackgroundColor: _radioYellow.withValues(alpha: .6),
              disabledForegroundColor: const Color(0xFF241B52),
              fixedSize: const Size.square(64),
            ).copyWith(
              backgroundColor: WidgetStateProperty.resolveWith((states) {
                if (states.contains(WidgetState.disabled)) {
                  return _radioYellow.withValues(alpha: .6);
                }
                if (states.contains(WidgetState.pressed)) {
                  return FccDesignColors.of(context).primaryPressed;
                }
                return _radioYellow;
              }),
              shape: FccTheme.focusShape(context, radius: 999),
            ),
        icon: Icon(
          isPlaying ? Icons.pause_rounded : Icons.play_arrow_rounded,
          size: 30,
        ),
      ),
    );
  }
}

class _RadioArtwork extends StatelessWidget {
  const _RadioArtwork({
    required this.url,
    required this.size,
    this.iconSize = 24,
  });

  final String url;
  final double size;
  final double iconSize;

  @override
  Widget build(BuildContext context) {
    final fallback = Icon(
      Icons.music_note_rounded,
      size: iconSize,
      color: Colors.white,
    );

    return AspectRatio(
      aspectRatio: 1,
      child: url.isEmpty
          ? fallback
          : CachedNetworkImage(
              imageUrl: url,
              width: size,
              height: size,
              fit: BoxFit.contain,
              placeholder: (context, url) => fallback,
              errorWidget: (context, url, error) => fallback,
            ),
    );
  }
}

class CodeRadioSkeleton extends StatelessWidget {
  const CodeRadioSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    Widget placeholder({
      double? width,
      required double height,
      double radius = 8,
    }) => Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: .12),
        borderRadius: BorderRadius.circular(radius),
      ),
    );
    return ExcludeSemantics(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 340),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                AspectRatio(
                  aspectRatio: 1,
                  child: placeholder(height: 340, radius: 20),
                ),
                const SizedBox(height: 24),
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          placeholder(height: 26),
                          const SizedBox(height: 8),
                          FractionallySizedBox(
                            alignment: Alignment.centerLeft,
                            widthFactor: .8,
                            child: placeholder(height: 18),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 16),
                    placeholder(width: 64, height: 64, radius: 32),
                  ],
                ),
                const SizedBox(height: 24),
                placeholder(height: 6),
                const SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    placeholder(width: 36, height: 14),
                    placeholder(width: 36, height: 14),
                  ],
                ),
                const SizedBox(height: 24),
                Divider(color: Colors.white.withValues(alpha: .18), height: 1),
                const SizedBox(height: 20),
                Row(
                  children: [
                    placeholder(width: 48, height: 48, radius: 10),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          placeholder(width: 48, height: 12),
                          const SizedBox(height: 6),
                          placeholder(height: 18),
                          const SizedBox(height: 6),
                          placeholder(height: 14),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
