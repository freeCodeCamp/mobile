import 'dart:developer';

import 'package:audio_service/audio_service.dart';
import 'package:flutter/material.dart';
import 'package:freecodecamp/app/app.locator.dart';
import 'package:freecodecamp/extensions/i18n_extension.dart';
import 'package:freecodecamp/models/learn/challenge_model.dart';
import 'package:freecodecamp/service/audio/audio_service.dart';
import 'package:freecodecamp/ui/theme/fcc_theme.dart';
import 'package:freecodecamp/ui/views/learn/widgets/challenge_card.dart';

class QuizAudioPlayer extends StatefulWidget {
  const QuizAudioPlayer({super.key, required this.audioData});

  final QuizAudioData audioData;

  @override
  State<QuizAudioPlayer> createState() => _QuizAudioPlayerState();
}

class _QuizAudioPlayerState extends State<QuizAudioPlayer> {
  final audioHandler = locator<AppAudioService>().audioHandler;
  bool _isLoading = false;
  bool _hasError = false;

  Future<void> _loadAndPlay() async {
    try {
      setState(() {
        _isLoading = true;
        _hasError = false;
      });

      await audioHandler.stop();
      await audioHandler.loadCurriculumAudio(widget.audioData.audio);

      if (mounted) {
        setState(() {
          _isLoading = false;
        });
        audioHandler.play();
      }
    } catch (e) {
      if (mounted) {
        log('QuizAudioPlayer: Error loading audio: $e');
        setState(() {
          _isLoading = false;
          _hasError = true;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_hasError) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Text(context.t.audio_load_error),
        ),
      );
    }

    return Column(
      children: [
        StreamBuilder<PlaybackState>(
          initialData: PlaybackState(),
          stream: audioHandler.playbackState,
          builder: (context, snapshot) {
            final playerState = snapshot.data as PlaybackState;
            final isActive = audioHandler.curriculumAudioFile ==
                widget.audioData.audio.fileName;

            return StreamBuilder<Duration>(
              initialData: Duration.zero,
              stream: AudioService.position,
              builder: (context, positionSnapshot) {
                final currentPosition =
                    isActive ? (positionSnapshot.data ?? Duration.zero) : Duration.zero;
                final totalDuration =
                    isActive ? (audioHandler.duration() ?? Duration.zero) : Duration.zero;
                final hasZeroValue = totalDuration.inMilliseconds == 0 ||
                    currentPosition.inMilliseconds == 0;

                return Column(
                  children: [
                    LinearProgressIndicator(
                      backgroundColor: FccColors.gray75,
                      valueColor: const AlwaysStoppedAnimation<Color>(
                        FccColors.blue50,
                      ),
                      value: hasZeroValue
                          ? 0
                          : currentPosition.inMilliseconds /
                              totalDuration.inMilliseconds,
                      minHeight: 8,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        if (_isLoading)
                          const Padding(
                            padding: EdgeInsets.all(8.0),
                            child: SizedBox(
                              width: 24,
                              height: 24,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            ),
                          )
                        else
                          IconButton(
                            onPressed: () {
                              if (!isActive) {
                                _loadAndPlay();
                              } else if (playerState.playing &&
                                  playerState.processingState !=
                                      AudioProcessingState.completed) {
                                audioHandler.pause();
                              } else if (playerState.processingState ==
                                  AudioProcessingState.completed) {
                                audioHandler.seek(Duration.zero);
                                audioHandler.play();
                              } else {
                                audioHandler.play();
                              }
                            },
                            icon: isActive &&
                                    playerState.playing &&
                                    playerState.processingState !=
                                        AudioProcessingState.completed
                                ? const Icon(Icons.pause)
                                : const Icon(Icons.play_arrow),
                          ),
                      ],
                    ),
                  ],
                );
              },
            );
          },
        ),
        if (widget.audioData.transcript.isNotEmpty) ...[
          const SizedBox(height: 8),
          _TranscriptWidget(transcript: widget.audioData.transcript),
        ],
      ],
    );
  }
}

class _TranscriptWidget extends StatefulWidget {
  const _TranscriptWidget({required this.transcript});

  final List<QuizTranscriptLine> transcript;

  @override
  State<_TranscriptWidget> createState() => _TranscriptWidgetState();
}

class _TranscriptWidgetState extends State<_TranscriptWidget> {
  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    return ChallengeCard(
      title: context.t.challenge_card_transcript,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          InkWell(
            onTap: () {
              setState(() {
                _isExpanded = !_isExpanded;
              });
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  context.t.show_transcript,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Icon(
                  _isExpanded ? Icons.expand_less : Icons.expand_more,
                ),
              ],
            ),
          ),
          if (_isExpanded) ...[
            const SizedBox(height: 12),
            ...widget.transcript.map((line) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 8.0),
                child: RichText(
                  text: TextSpan(
                    style: const TextStyle(
                      fontSize: 14,
                      color: FccColors.gray05,
                    ),
                    children: [
                      TextSpan(
                        text: '${line.character}: ',
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      TextSpan(text: line.text),
                    ],
                  ),
                ),
              );
            }),
          ],
        ],
      ),
    );
  }
}
