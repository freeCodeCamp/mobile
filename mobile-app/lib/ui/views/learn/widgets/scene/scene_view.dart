import 'dart:developer' as developer;

import 'package:audio_service/audio_service.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:freecodecamp/models/learn/challenge_model.dart';
import 'package:freecodecamp/ui/theme/fcc_theme.dart';
import 'package:freecodecamp/ui/views/learn/widgets/scene/scene_viewmodel.dart';
import 'package:stacked/stacked.dart';

class SceneView extends StatelessWidget {
  const SceneView({
    super.key,
    required this.scene,
  });

  final Scene scene;

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<SceneViewModel>.reactive(
      viewModelBuilder: () => SceneViewModel(),
      onViewModelReady: (model) => {
        model.initPositionListener(),
        model.audioService.loadEnglishAudio(scene.setup.audio),
        model.initScene(scene),
      },
      onDispose: (model) => model.onDispose(),
      builder: (context, model, child) => Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
        child: Column(
          children: [
            // Scene canvas area
            AspectRatio(
              aspectRatio: 16 / 9,
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.black,
                  border: Border.all(color: FccColors.gray75, width: 2),
                ),
                child: Stack(
                  children: [
                    // Background
                    if (model.currentBackground != null)
                      Positioned.fill(
                        child: CachedNetworkImage(
                          imageUrl: model.getBackgroundUrl(model.currentBackground!),
                          fit: BoxFit.cover,
                          placeholder: (context, url) => Container(
                            color: FccColors.gray75,
                          ),
                          errorWidget: (context, url, error) {
                            developer.log(
                              'Failed to load background: $url',
                              name: 'SceneView',
                              error: error,
                            );
                            return Container(
                              color: FccColors.gray75,
                              child: const Center(
                                child: Icon(Icons.broken_image, size: 48),
                              ),
                            );
                          },
                        ),
                      ),
                    // Characters
                    LayoutBuilder(
                      builder: (context, constraints) {
                        final canvasWidth = constraints.maxWidth;
                        final canvasHeight = constraints.maxHeight;

                        return Stack(
                          children: model.visibleCharacters.map((characterState) {
                            final scale = characterState.position.z.toDouble();
                            final baseHeight = canvasHeight * 0.7;
                            final characterHeight = baseHeight * scale;
                            final characterWidth = characterHeight * (2 / 3);

                            final xPercent = characterState.position.x.toDouble() / 100;
                            final yPercent = characterState.position.y.toDouble() / 100;

                            final leftPos = (xPercent * canvasWidth) - (characterWidth / 2);
                            final bottomPos = yPercent * canvasHeight;

                            return Positioned(
                              left: leftPos,
                              bottom: bottomPos,
                              child: AnimatedOpacity(
                                opacity: characterState.opacity,
                                duration: const Duration(milliseconds: 1000),
                                child: SizedBox(
                                  width: characterWidth,
                                  height: characterHeight,
                                  child: Stack(
                                    children: [
                                // Base character image
                                Positioned.fill(
                                  child: CachedNetworkImage(
                                    imageUrl: model.getCharacterBaseUrl(
                                        characterState.characterName),
                                    fit: BoxFit.contain,
                                    placeholder: (context, url) => Container(
                                      color: Colors.transparent,
                                    ),
                                    errorWidget: (context, url, error) {
                                      developer.log(
                                        'Failed to load character base: $url',
                                        name: 'SceneView',
                                        error: error,
                                      );
                                      return Container(
                                        color: FccColors.gray75,
                                        child: const Center(
                                          child: Icon(Icons.person, size: 48),
                                        ),
                                      );
                                    },
                                  ),
                                ),
                                // Eyes overlay
                                Positioned.fill(
                                  child: CachedNetworkImage(
                                    imageUrl: model.getCharacterEyesUrl(
                                        characterState.characterName),
                                    fit: BoxFit.contain,
                                    placeholder: (context, url) => const SizedBox.shrink(),
                                    errorWidget: (context, url, error) {
                                      developer.log(
                                        'Failed to load character eyes: $url',
                                        name: 'SceneView',
                                        error: error,
                                      );
                                      return const SizedBox.shrink();
                                    },
                                  ),
                                ),
                                // Mouth overlay (animated)
                                if (characterState.showMouth)
                                  Positioned.fill(
                                    child: CachedNetworkImage(
                                      imageUrl: model.getCharacterMouthUrl(
                                        characterState.characterName,
                                        characterState.mouthType,
                                      ),
                                      fit: BoxFit.contain,
                                      placeholder: (context, url) => const SizedBox.shrink(),
                                      errorWidget: (context, url, error) {
                                        developer.log(
                                          'Failed to load character mouth: $url',
                                          name: 'SceneView',
                                          error: error,
                                        );
                                        return const SizedBox.shrink();
                                      },
                                    ),
                                  ),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          }).toList(),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            // Audio controls
            StreamBuilder(
              initialData: PlaybackState(),
              stream: model.audioService.playbackState,
              builder: (context, snapshot) {
                final playerState = snapshot.data as PlaybackState;

                return StreamBuilder(
                  initialData: Duration.zero,
                  stream: model.position.stream,
                  builder: (context, positionSnapshot) {
                    if (positionSnapshot.data == null) {
                      return const CircularProgressIndicator();
                    }

                    final position = positionSnapshot.data as Duration;
                    bool canSeekForward = model.audioService.canSeek(
                      true,
                      position.inSeconds,
                      scene.setup.audio,
                    );

                    bool canSeekBackward = model.audioService.canSeek(
                      false,
                      position.inSeconds,
                      scene.setup.audio,
                    );

                    Duration? totalDuration = model.audioService.duration();
                    int handleTotal = totalDuration?.inMilliseconds ?? 0;
                    bool hasZeroValue =
                        handleTotal == 0 || position.inMilliseconds == 0;

                    return Column(
                      children: [
                        LinearProgressIndicator(
                          backgroundColor: FccColors.gray75,
                          valueColor: const AlwaysStoppedAnimation<Color>(
                            FccColors.blue50,
                          ),
                          value: hasZeroValue
                              ? 0
                              : position.inMilliseconds / handleTotal,
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
                                          scene.setup.audio,
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
                                      scene.setup.audio,
                                    ),
                                  );
                                  model.playWithFadeIn();
                                } else {
                                  model.playWithFadeIn();
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
                                          scene.setup.audio,
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
                  },
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
