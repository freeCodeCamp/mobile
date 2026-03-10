import 'package:audio_service/audio_service.dart';
import 'package:flutter/material.dart';
import 'package:freecodecamp/models/learn/challenge_model.dart';
import 'package:freecodecamp/ui/theme/fcc_theme.dart';
import 'package:freecodecamp/ui/views/learn/widgets/audio/audio_player_viewmodel.dart';
import 'package:stacked/stacked.dart';

class AudioPlayerView extends StatelessWidget {
  const AudioPlayerView({super.key, required this.audio});

  final EnglishScene audio;

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<AudioPlayerViewmodel>.reactive(
      viewModelBuilder: () => AudioPlayerViewmodel(),
      onViewModelReady: (model) => {
        model.initPositionListener(),
        model.audioService.loadCurriculumAudio(audio)
      },
      onDispose: (model) => model.onDispose(),
      builder: (context, model, child) => Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
        child: StreamBuilder(
          initialData: PlaybackState(),
          stream: model.audioService.playbackState,
          builder: (context, snapshot) {
            final playerState = snapshot.data as PlaybackState;

            return InnerAudioWidget(
              model: model,
              audio: audio,
              playerState: playerState,
            );
          },
        ),
      ),
    );
  }
}

class InnerAudioWidget extends StatelessWidget {
  const InnerAudioWidget({
    super.key,
    required this.model,
    required this.audio,
    required this.playerState,
  });

  final AudioPlayerViewmodel model;
  final EnglishScene audio;
  final PlaybackState playerState;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      initialData: Duration.zero,
      stream: model.position.stream,
      builder: (context, snapshot) {
        if (snapshot.data == null) {
          return const CircularProgressIndicator();
        }

        if (snapshot.hasData) {
          final position = snapshot.data as Duration;

          bool canSeekForward = model.audioService.canSeek(
            true,
            position.inSeconds,
            audio,
          );

          bool canSeekBackward = model.audioService.canSeek(
            false,
            position.inSeconds,
            audio,
          );

          Duration? totalDuration = model.audioService.duration();
          int handleTotal = totalDuration?.inMilliseconds ?? 0;
          bool hasZeroValue = handleTotal == 0 || position.inMilliseconds == 0;
          return Column(
            children: [
              LinearProgressIndicator(
                backgroundColor: FccColors.gray75,
                valueColor: const AlwaysStoppedAnimation<Color>(
                  FccColors.blue50,
                ),
                value: hasZeroValue ? 0 : position.inMilliseconds / handleTotal,
                minHeight: 8,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(
                    onPressed: canSeekBackward
                        ? () {
                            model.audioService.seek(
                              model.searchTimeStamp(
                                false,
                                position.inSeconds,
                                audio,
                              ),
                            );
                          }
                        : null,
                    icon: const Icon(Icons.skip_previous),
                  ),
                  IconButton(
                    onPressed: () {
                      if (playerState.playing &&
                          playerState.processingState !=
                              AudioProcessingState.completed) {
                        model.audioService.pause();
                      } else if (playerState.processingState ==
                          AudioProcessingState.completed) {
                        model.audioService.seek(
                          model.searchTimeStamp(
                            false,
                            position.inSeconds,
                            audio,
                          ),
                        );
                        model.audioService.play();
                      } else {
                        model.audioService.play();
                      }
                    },
                    icon: playerState.playing &&
                            playerState.processingState !=
                                AudioProcessingState.completed
                        ? const Icon(Icons.pause)
                        : const Icon(Icons.play_arrow),
                  ),
                  IconButton(
                    onPressed: canSeekForward
                        ? () {
                            model.audioService.seek(
                              model.searchTimeStamp(
                                true,
                                position.inSeconds,
                                audio,
                              ),
                            );
                          }
                        : null,
                    icon: const Icon(Icons.skip_next),
                  ),
                ],
              ),
            ],
          );
        }

        return const CircularProgressIndicator();
      },
    );
  }
}
