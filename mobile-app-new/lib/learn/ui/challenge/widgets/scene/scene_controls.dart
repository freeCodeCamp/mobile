import 'package:audio_service/audio_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mobile_app_new/fcc_theme.dart';
import 'package:mobile_app_new/learn/models/challenge_model.dart';
import 'package:mobile_app_new/learn/ui/challenge/widgets/scene/scene_viewmodel.dart';
import 'package:mobile_app_new/services/audio_service.dart';

class SceneControls extends ConsumerWidget {
  const SceneControls({
    super.key,
    required this.scene,
    required this.title,
    this.onFullscreen,
    this.fullscreen = false,
  });

  final Scene scene;
  final String title;
  final VoidCallback? onFullscreen;
  final bool fullscreen;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final handler = ref.watch(audioHandlerProvider);
    final notifier = ref.read(sceneProvider(scene, title).notifier);
    final showCaptions = ref.watch(
      sceneProvider(scene, title).select((s) => s.showCaptions),
    );
    final active = ref.watch(
      sceneProvider(scene, title).select((s) => s.isActive),
    );
    final iconColor = fullscreen ? FccColors.gray00 : null;

    return StreamBuilder<PlaybackState>(
      stream: handler.playbackState,
      builder: (context, snapshot) {
        final state = snapshot.data ?? PlaybackState();
        final completed =
            active && state.processingState == AudioProcessingState.completed;
        final playing = active && state.playing && !completed;

        final progress = StreamBuilder<Duration>(
          stream: handler.positionStream,
          builder: (context, position) {
            final total = handler.duration?.inMilliseconds ?? 0;
            final current = position.data?.inMilliseconds ?? 0;

            return LinearProgressIndicator(
              backgroundColor: FccColors.gray75,
              valueColor: const AlwaysStoppedAnimation<Color>(FccColors.blue50),
              value: !active || total == 0
                  ? 0
                  : (current / total).clamp(0.0, 1.0),
              minHeight: fullscreen ? 6 : 8,
            );
          },
        );

        final play = IconButton(
          tooltip: completed ? 'Replay' : (playing ? 'Pause' : 'Play'),
          onPressed: playing ? notifier.pause : notifier.play,
          icon: Icon(
            completed
                ? Icons.replay
                : (playing ? Icons.pause : Icons.play_arrow),
            color: iconColor,
            size: fullscreen ? 32 : null,
          ),
        );

        final captions = IconButton(
          tooltip: showCaptions ? 'Hide captions' : 'Show captions',
          onPressed: notifier.toggleCaptions,
          icon: Icon(
            showCaptions ? Icons.closed_caption : Icons.closed_caption_off,
            color: iconColor,
            size: fullscreen ? 28 : null,
          ),
        );

        if (fullscreen) {
          return Container(
            color: Colors.black54,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              children: [
                play,
                const SizedBox(width: 12),
                Expanded(child: progress),
                const SizedBox(width: 12),
                captions,
              ],
            ),
          );
        }

        return Column(
          children: [
            progress,
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                play,
                captions,
                IconButton(
                  tooltip: 'Fullscreen',
                  onPressed: onFullscreen,
                  icon: const Icon(Icons.fullscreen),
                ),
              ],
            ),
          ],
        );
      },
    );
  }
}
