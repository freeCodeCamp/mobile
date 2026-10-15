import 'package:audio_service/audio_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mobile_app_new/fcc_theme.dart';
import 'package:mobile_app_new/learn/models/challenge_model.dart';
import 'package:mobile_app_new/learn/ui/challenge/widgets/challenge_card.dart';
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
    setState(() => _loading = true);

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
    if (_failed) {
      return const Padding(
        padding: EdgeInsets.all(16),
        child: Center(child: Text('Error loading audio')),
      );
    }

    final handler = _handler;

    return Column(
      children: [
        StreamBuilder<PlaybackState>(
          stream: handler.playbackState,
          builder: (context, snapshot) {
            final state = snapshot.data ?? PlaybackState();
            final isActive = handler.curriculumClipId == _clip.id;
            final completed =
                state.processingState == AudioProcessingState.completed;
            final playing = isActive && state.playing && !completed;

            return Column(
              children: [
                StreamBuilder<Duration>(
                  stream: handler.positionStream,
                  builder: (context, position) => _Progress(
                    position: isActive ? position.data : null,
                    total: isActive ? handler.duration : null,
                  ),
                ),
                if (_loading)
                  const Padding(
                    padding: EdgeInsets.all(8),
                    child: SizedBox.square(
                      dimension: 24,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    ),
                  )
                else
                  IconButton(
                    tooltip: playing ? 'Pause' : 'Play',
                    icon: Icon(playing ? Icons.pause : Icons.play_arrow),
                    onPressed: () async {
                      if (!isActive) return _loadAndPlay();
                      if (playing) return handler.pause();
                      if (completed) await handler.seek(Duration.zero);
                      await handler.play();
                    },
                  ),
              ],
            );
          },
        ),
        if (widget.audioData.transcript.isNotEmpty) ...[
          const SizedBox(height: 8),
          ChallengeCard(
            title: 'Transcript',
            child: ExpansionTile(
              title: const Text(
                'Show transcript',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              shape: const Border(),
              collapsedShape: const Border(),
              expandedCrossAxisAlignment: CrossAxisAlignment.start,
              children: [
                for (final line in widget.audioData.transcript)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: Text.rich(
                      TextSpan(
                        style: const TextStyle(
                          fontSize: 14,
                          color: FccColors.gray05,
                        ),
                        children: [
                          TextSpan(
                            text: '${line.character}: ',
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                          TextSpan(text: line.text),
                        ],
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ],
      ],
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

    return LinearProgressIndicator(
      backgroundColor: FccColors.gray75,
      valueColor: const AlwaysStoppedAnimation<Color>(FccColors.blue50),
      value: totalMs == 0 ? 0 : (positionMs / totalMs).clamp(0.0, 1.0),
      minHeight: 8,
    );
  }
}
