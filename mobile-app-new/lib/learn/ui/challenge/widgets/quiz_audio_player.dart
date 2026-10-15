import 'package:audio_service/audio_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mobile_app_new/learn/models/challenge_model.dart';
import 'package:mobile_app_new/services/audio_service.dart';

class QuizAudioPlayer extends ConsumerStatefulWidget {
  const QuizAudioPlayer({super.key, required this.audioData});

  final QuizAudioData audioData;

  @override
  ConsumerState<QuizAudioPlayer> createState() => _QuizAudioPlayerState();
}

class _QuizAudioPlayerState extends ConsumerState<QuizAudioPlayer> {
  bool _loading = false;
  bool _failed = false;

  late final _handler = ref.read(audioHandlerProvider);

  AudioClip get _clip => widget.audioData.audio;

  @override
  void dispose() {
    if (_handler.curriculumClipId == _clip.id) _handler.stop();
    super.dispose();
  }

  Future<void> _loadAndPlay() async {
    setState(() {
      _loading = true;
      _failed = false;
    });

    final loaded = await _handler.loadCurriculumAudio(
      _clip.url,
      clipId: _clip.id,
      title: 'Quiz audio',
      start: _clip.start,
      end: _clip.end,
    );

    if (!mounted) return;
    setState(() {
      _loading = false;
      _failed = !loaded;
    });
    if (loaded) await _handler.play();
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final handler = _handler;

    return Card(
      clipBehavior: Clip.antiAlias,
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12),
            child: _failed
                ? Row(
                    children: [
                      Icon(Icons.error_outline, color: colors.error),
                      const SizedBox(width: 12),
                      const Expanded(
                        child: Text("We couldn't load this audio."),
                      ),
                      TextButton(
                        onPressed: _loadAndPlay,
                        child: const Text('Try again'),
                      ),
                    ],
                  )
                : StreamBuilder<PlaybackState>(
                    stream: handler.playbackState,
                    builder: (context, snapshot) {
                      final state = snapshot.data ?? PlaybackState();
                      final isActive = handler.curriculumClipId == _clip.id;
                      final completed =
                          state.processingState ==
                          AudioProcessingState.completed;
                      final playing = isActive && state.playing && !completed;

                      return Row(
                        children: [
                          if (_loading)
                            const SizedBox.square(
                              dimension: 48,
                              child: Padding(
                                padding: EdgeInsets.all(12),
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  semanticsLabel: 'Loading audio',
                                ),
                              ),
                            )
                          else
                            IconButton.filled(
                              tooltip: playing ? 'Pause audio' : 'Play audio',
                              style: IconButton.styleFrom(
                                backgroundColor: colors.primary,
                                foregroundColor: colors.onPrimary,
                                shape: const CircleBorder(),
                              ),
                              icon: Icon(
                                playing ? Icons.pause : Icons.play_arrow,
                              ),
                              onPressed: () async {
                                if (!isActive) return _loadAndPlay();
                                if (playing) return handler.pause();
                                if (completed) {
                                  await handler.seek(Duration.zero);
                                }
                                await handler.play();
                              },
                            ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Listen to the audio',
                                  style: Theme.of(
                                    context,
                                  ).textTheme.titleMedium,
                                ),
                                const SizedBox(height: 8),
                                StreamBuilder<Duration>(
                                  stream: handler.positionStream,
                                  builder: (context, position) => _Progress(
                                    position: isActive ? position.data : null,
                                    total: isActive ? handler.duration : null,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      );
                    },
                  ),
          ),
          if (widget.audioData.transcript.isNotEmpty) ...[
            const Divider(),
            ExpansionTile(
              title: const Text('Transcript'),
              tilePadding: const EdgeInsets.symmetric(horizontal: 16),
              childrenPadding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
              textColor: colors.onSurface,
              collapsedTextColor: colors.onSurface,
              iconColor: colors.primary,
              collapsedIconColor: colors.onSurfaceVariant,
              shape: const Border(),
              collapsedShape: const Border(),
              expandedCrossAxisAlignment: CrossAxisAlignment.start,
              expandedAlignment: Alignment.centerLeft,
              children: [
                for (final (index, line) in widget.audioData.transcript.indexed)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: Text.rich(
                      TextSpan(
                        children: [
                          TextSpan(
                            text: '${line.character}: ',
                            style: TextStyle(
                              fontWeight: FontWeight.w700,
                              color: index.isEven
                                  ? colors.tertiary
                                  : colors.primary,
                            ),
                          ),
                          TextSpan(text: line.text),
                        ],
                      ),
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                  ),
              ],
            ),
          ],
        ],
      ),
    );
  }
}

class _Progress extends StatelessWidget {
  const _Progress({required this.position, required this.total});

  final Duration? position;
  final Duration? total;

  @override
  Widget build(BuildContext context) {
    final totalMs = total?.inMilliseconds ?? 0;
    final positionMs = position?.inMilliseconds ?? 0;
    final colors = Theme.of(context).colorScheme;

    return LinearProgressIndicator(
      backgroundColor: colors.outlineVariant,
      color: colors.primary,
      value: totalMs == 0 ? 0 : (positionMs / totalMs).clamp(0.0, 1.0),
      minHeight: 6,
      borderRadius: BorderRadius.circular(8),
      semanticsLabel: 'Audio playback progress',
    );
  }
}
