import 'package:audio_service/audio_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
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
    final colors = Theme.of(context).colorScheme;
    final handler = ref.watch(audioHandlerProvider);
    final notifier = ref.read(sceneProvider(scene, title).notifier);
    final sceneState = ref.watch(sceneProvider(scene, title));
    final showCaptions = sceneState.showCaptions;
    final active = sceneState.isActive;
    final foreground = fullscreen ? const Color(0xFFFFF8EC) : colors.onSurface;

    return StreamBuilder<PlaybackState>(
      stream: handler.playbackState,
      builder: (context, snapshot) {
        final state = snapshot.data ?? PlaybackState();
        final completed =
            active && state.processingState == AudioProcessingState.completed;
        final playing = active && state.playing && !completed;

        return Container(
          color: fullscreen ? Colors.black54 : colors.surfaceContainerLowest,
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              if (sceneState.error != null)
                Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: Semantics(
                    liveRegion: true,
                    child: Text(
                      sceneState.error!,
                      style: TextStyle(
                        color: fullscreen
                            ? const Color(0xFFFF8FA8)
                            : colors.error,
                      ),
                    ),
                  ),
                ),
              Row(
                children: [
                  IconButton.filled(
                    tooltip: sceneState.isLoading
                        ? 'Loading dialogue'
                        : sceneState.error != null
                        ? 'Retry dialogue'
                        : completed
                        ? 'Replay'
                        : (playing ? 'Pause' : 'Play'),
                    style: IconButton.styleFrom(
                      backgroundColor: colors.primary,
                      foregroundColor: colors.onPrimary,
                      shape: const CircleBorder(),
                    ),
                    onPressed: sceneState.isLoading
                        ? null
                        : playing
                        ? notifier.pause
                        : notifier.play,
                    icon: sceneState.isLoading
                        ? SizedBox(
                            width: 26,
                            height: 26,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: colors.onPrimary,
                              semanticsLabel: 'Loading dialogue',
                            ),
                          )
                        : Icon(
                            sceneState.error != null || completed
                                ? Icons.replay
                                : playing
                                ? Icons.pause
                                : Icons.play_arrow,
                            size: 26,
                          ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: StreamBuilder<Duration>(
                      stream: handler.positionStream,
                      builder: (context, position) {
                        final total = handler.duration?.inMilliseconds ?? 0;
                        final current = active
                            ? position.data ?? Duration.zero
                            : Duration.zero;
                        return Row(
                          children: [
                            Expanded(
                              child: LinearProgressIndicator(
                                backgroundColor: fullscreen
                                    ? Colors.white24
                                    : colors.outlineVariant,
                                color: colors.primary,
                                value: !active || total == 0
                                    ? 0
                                    : (current.inMilliseconds / total).clamp(
                                        0.0,
                                        1.0,
                                      ),
                                minHeight: 6,
                                borderRadius: BorderRadius.circular(8),
                                semanticsLabel: 'Dialogue playback progress',
                              ),
                            ),
                            const SizedBox(width: 10),
                            Text(
                              '${current.inMinutes}:${(current.inSeconds % 60).toString().padLeft(2, '0')}',
                              style: TextStyle(
                                fontFamily: 'monospace',
                                fontSize: 12,
                                color: foreground,
                              ),
                            ),
                          ],
                        );
                      },
                    ),
                  ),
                  const SizedBox(width: 10),
                  IconButton(
                    tooltip: showCaptions ? 'Hide captions' : 'Show captions',
                    isSelected: showCaptions,
                    style: IconButton.styleFrom(
                      backgroundColor: showCaptions
                          ? colors.primary
                          : Colors.transparent,
                      foregroundColor: showCaptions
                          ? colors.onPrimary
                          : foreground,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    onPressed: notifier.toggleCaptions,
                    icon: const Icon(Icons.closed_caption_outlined),
                    selectedIcon: const Icon(Icons.closed_caption),
                  ),
                  if (!fullscreen) ...[
                    const SizedBox(width: 6),
                    IconButton.outlined(
                      tooltip: 'Fullscreen',
                      style: IconButton.styleFrom(
                        foregroundColor: foreground,
                        side: BorderSide(color: colors.outlineVariant),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      onPressed: onFullscreen,
                      icon: const Icon(Icons.fullscreen),
                    ),
                  ],
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}
