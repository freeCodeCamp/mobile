import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mobile_app_new/code_radio/models/code_radio_model.dart';
import 'package:mobile_app_new/code_radio/ui/player/player_viewmodel.dart';
import 'package:mobile_app_new/fcc_theme.dart';
import 'package:mobile_app_new/widgets/drawer/drawer.dart';
import 'package:mobile_app_new/widgets/error_retry.dart';

const _nextSongMinHeight = 600.0;

class CodeRadioPlayerView extends ConsumerWidget {
  const CodeRadioPlayerView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final nowPlaying = ref.watch(codeRadioNowPlayingProvider);

    return Scaffold(
      backgroundColor: FccColors.gray90,
      appBar: AppBar(title: const Text('Code Radio')),
      drawer: const DrawerWidget(),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: switch (nowPlaying) {
          AsyncData(:final value) => _Player(radio: value),
          AsyncError() => ErrorRetry(
            message: 'Unable to load Code Radio.\nPlease try again.',
            onRetry: () => ref.invalidate(codeRadioNowPlayingProvider),
          ),
          AsyncLoading() => const Center(child: CircularProgressIndicator()),
        },
      ),
    );
  }
}

class _Player extends StatelessWidget {
  const _Player({required this.radio});

  final CodeRadio radio;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CodeRadioAlbumArt(radio: radio),
        Padding(
          padding: const EdgeInsets.only(top: 16),
          child: CodeRadioNowPlaying(radio: radio),
        ),
        if (MediaQuery.sizeOf(context).height > _nextSongMinHeight)
          Padding(
            padding: const EdgeInsets.only(top: 16),
            child: CodeRadioNextSong(song: radio.playingNext.song),
          ),
        const Expanded(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Row(children: [Expanded(child: CodeRadioPlayPauseButton())]),
            ],
          ),
        ),
      ],
    );
  }
}

class CodeRadioAlbumArt extends StatelessWidget {
  const CodeRadioAlbumArt({super.key, required this.radio});

  final CodeRadio radio;

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        ConstrainedBox(
          constraints: BoxConstraints(
            maxHeight: MediaQuery.sizeOf(context).height * 0.45,
          ),
          child: AspectRatio(
            aspectRatio: 1,
            child: ColoredBox(
              color: FccColors.gray80,
              child: CachedNetworkImage(
                imageUrl: radio.nowPlaying.song.art,
                fit: BoxFit.cover,
              ),
            ),
          ),
        ),
        Text(
          '${radio.listeners.total} listening right now',
          textAlign: TextAlign.center,
          style: const TextStyle(
            color: Color.fromRGBO(1, 1, 1, 0.5),
            fontSize: 36,
            fontWeight: FontWeight.w800,
          ),
        ),
      ],
    );
  }
}

class CodeRadioNowPlaying extends StatelessWidget {
  const CodeRadioNowPlaying({super.key, required this.radio});

  final CodeRadio radio;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8),
      color: FccColors.gray80,
      child: Column(
        children: [
          Text(
            radio.nowPlaying.song.title,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              height: 1.5,
            ),
          ),
          Row(
            children: [
              Expanded(
                child: Text(
                  radio.nowPlaying.song.artist,
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 16, height: 1.5),
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.only(top: 8),
            child: CodeRadioProgressBar(duration: radio.nowPlaying.duration),
          ),
        ],
      ),
    );
  }
}

class CodeRadioProgressBar extends ConsumerWidget {
  const CodeRadioProgressBar({super.key, required this.duration});

  final int duration;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isPlaying = ref.watch(codeRadioPlayerProvider);

    if (!isPlaying) {
      return const Visibility(
        visible: false,
        maintainSize: true,
        maintainAnimation: true,
        maintainState: true,
        child: LinearProgressIndicator(value: 0),
      );
    }

    final elapsed = ref.watch(codeRadioElapsedProvider).value;

    return LinearProgressIndicator(
      value: duration == 0 ? null : (elapsed ?? 0) / duration,
    );
  }
}

class CodeRadioNextSong extends StatelessWidget {
  const CodeRadioNextSong({super.key, required this.song});

  final Song song;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: const Text('Next Song'),
      subtitle: Row(
        children: [
          Expanded(
            child: Text(
              '${song.title}\n${song.album}',
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
      tileColor: FccColors.gray80,
      isThreeLine: true,
      titleAlignment: ListTileTitleAlignment.center,
      leading: SizedBox.square(
        dimension: 56,
        child: CachedNetworkImage(imageUrl: song.art, fit: BoxFit.cover),
      ),
    );
  }
}

class CodeRadioPlayPauseButton extends ConsumerWidget {
  const CodeRadioPlayPauseButton({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isPlaying = ref.watch(codeRadioPlayerProvider);

    return ElevatedButton.icon(
      style: ElevatedButton.styleFrom(backgroundColor: FccColors.gray80),
      onPressed: () => ref.read(codeRadioPlayerProvider.notifier).toggle(),
      icon: Icon(isPlaying ? Icons.pause : Icons.play_arrow),
      label: Text(isPlaying ? 'Pause' : 'Play'),
    );
  }
}
