import 'dart:async';

import 'package:audio_service/audio_service.dart';
import 'package:flutter/material.dart';
import 'package:freecodecamp/app/app.locator.dart';
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
  final StreamController<Duration> position =
      StreamController<Duration>.broadcast();
  bool _isLoading = true;
  bool _hasError = false;

  @override
  void initState() {
    super.initState();
    _loadAudio();
  }

  Future<void> _loadAudio() async {
    try {
      setState(() {
        _isLoading = true;
        _hasError = false;
      });

      await audioHandler.stop();
      await audioHandler.loadCurriculumAudio(widget.audioData.audio);

      // Listen to position changes
      AudioService.position.listen((pos) {
        if (mounted) {
          position.add(pos);
        }
      });

      setState(() {
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
        _hasError = true;
      });
    }
  }

  @override
  void dispose() {
    position.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: CircularProgressIndicator(),
        ),
      );
    }

    if (_hasError) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Text('Error loading audio'),
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

            return StreamBuilder<Duration>(
              initialData: Duration.zero,
              stream: position.stream,
              builder: (context, positionSnapshot) {
                if (!positionSnapshot.hasData) {
                  return const CircularProgressIndicator();
                }

                final currentPosition = positionSnapshot.data!;
                final totalDuration = audioHandler.duration() ?? Duration.zero;
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
                        IconButton(
                          onPressed: () {
                            if (playerState.playing &&
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
                          icon: playerState.playing &&
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
      title: 'Transcript',
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
                const Text(
                  'Show transcript',
                  style: TextStyle(
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
