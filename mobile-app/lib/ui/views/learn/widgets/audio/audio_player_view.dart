import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:freecodecamp/models/learn/challenge_model.dart';
import 'package:freecodecamp/ui/views/learn/widgets/audio/audio_player_viewmodel.dart';
import 'package:just_audio/just_audio.dart';
import 'package:stacked/stacked.dart';

class AudioPlayerView extends StatelessWidget {
  const AudioPlayerView({Key? key, required this.audio}) : super(key: key);

  final EnglishAudio audio;

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<AudioPlayerViewmodel>.reactive(
      viewModelBuilder: () => AudioPlayerViewmodel(),
      onViewModelReady: (model) => model.loadAudio(audio),
      onDispose: (viewModel) => viewModel.player.dispose(),
      builder: (context, model, child) => Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
        child: StreamBuilder(
          stream: model.player.playerStateStream,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              final playerState = snapshot.data as PlayerState;

              List<ProcessingState> validStates = [
                ProcessingState.completed,
                ProcessingState.ready,
                ProcessingState.buffering,
              ];

              if (validStates.contains(playerState.processingState)) {
                return InnerAudioWidget(
                  model: model,
                  audio: audio,
                  playerState: playerState,
                );
              }
            }

            return const CircularProgressIndicator();
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
  final EnglishAudio audio;
  final PlayerState playerState;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<Object>(
      stream: model.player.positionStream,
      builder: (context, snapshot) {
        if (snapshot.data == null) {
          return const CircularProgressIndicator();
        }

        if (snapshot.hasData) {
          final position = snapshot.data as Duration;

          bool canSeekForward = model.canSeek(
            true,
            position.inSeconds,
            audio,
          );

          bool canSeekBackward = model.canSeek(
            false,
            position.inSeconds,
            audio,
          );

          return Column(
            children: [
              LinearProgressIndicator(
                value: position.inMilliseconds /
                    model.player.duration!.inMilliseconds,
                minHeight: 8,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(
                    onPressed: canSeekBackward
                        ? () {
                            model.player.seek(
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
                      log('playerState: $playerState');
                      if (playerState.playing &&
                          playerState.processingState !=
                              ProcessingState.completed) {
                        model.player.pause();
                        log('Paused');
                      } else if (playerState.processingState ==
                          ProcessingState.completed) {
                        model.player.seek(
                          model.searchTimeStamp(
                            false,
                            position.inSeconds,
                            audio,
                          ),
                        );
                        model.player.play();
                      } else {
                        model.player.play();
                      }
                    },
                    icon: playerState.playing &&
                            playerState.processingState !=
                                ProcessingState.completed
                        ? const Icon(Icons.pause)
                        : const Icon(Icons.play_arrow),
                  ),
                  IconButton(
                    onPressed: canSeekForward
                        ? () {
                            model.player.seek(
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
