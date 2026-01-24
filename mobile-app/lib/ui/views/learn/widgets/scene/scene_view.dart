import 'dart:async';

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
      onViewModelReady: (model) {
        model.initPositionListener();
        model.audioService.loadEnglishAudio(scene.setup.audio);
        model.initScene(scene);
      },
      onDispose: (model) => model.onDispose(),
      builder: (context, model, child) => Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
        child: Column(
          children: [
            AspectRatio(
              aspectRatio: 16 / 9,
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.black,
                  border: Border.all(color: FccColors.gray75, width: 2),
                ),
                child: Stack(
                  children: [
                    if (model.currentBackground != null)
                      Positioned.fill(
                        child: CachedNetworkImage(
                          imageUrl: model.getBackgroundUrl(model.currentBackground!),
                          fit: BoxFit.cover,
                          placeholder: (context, url) => Container(color: FccColors.gray75),
                          errorWidget: (context, url, error) => Container(
                            color: FccColors.gray75,
                            child: const Center(
                              child: Icon(Icons.broken_image, size: 48),
                            ),
                          ),
                        ),
                      ),
                    Positioned.fill(
                      child: _CharactersContainer(
                        model: model,
                        visibleStream: model.charactersVisibleStream,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            _AudioControls(scene: scene, model: model),
          ],
        ),
      ),
    );
  }
}

class _CharactersContainer extends StatefulWidget {
  const _CharactersContainer({
    required this.model,
    required this.visibleStream,
  });

  final SceneViewModel model;
  final Stream<bool> visibleStream;

  @override
  State<_CharactersContainer> createState() => _CharactersContainerState();
}

class _CharactersContainerState extends State<_CharactersContainer>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _fade;
  StreamSubscription<bool>? _sub;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
      value: 0.0,
    );
    _fade = CurvedAnimation(parent: _controller, curve: Curves.easeInOut);

    _sub = widget.visibleStream.listen((visible) {
      if (!mounted) return;
      if (visible) {
        _controller.forward(from: 0.0);
      } else {
        _controller.reverse(from: 1.0);
      }
    });
  }

  @override
  void didUpdateWidget(covariant _CharactersContainer oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.visibleStream != widget.visibleStream) {
      _sub?.cancel();
      _sub = widget.visibleStream.listen((visible) {
        if (!mounted) return;
        visible ? _controller.forward() : _controller.reverse();
      });
    }
  }

  @override
  void dispose() {
    _sub?.cancel();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final characters = widget.model.visibleCharacters;

    return LayoutBuilder(
      builder: (context, constraints) {
        final canvasWidth = constraints.maxWidth;
        final canvasHeight = constraints.maxHeight;

        return FadeTransition(
          opacity: _fade,
          child: Stack(
            children: [
              for (final character in characters)
                _CharacterSlot(
                  key: ValueKey('slot_${character.characterName}'),
                  state: character,
                  model: widget.model,
                  canvasWidth: canvasWidth,
                  canvasHeight: canvasHeight,
                ),
            ],
          ),
        );
      },
    );
  }
}

class _CharacterSlot extends StatelessWidget {
  const _CharacterSlot({
    super.key,
    required this.state,
    required this.model,
    required this.canvasWidth,
    required this.canvasHeight,
  });

  final CharacterState state;
  final SceneViewModel model;
  final double canvasWidth;
  final double canvasHeight;

  @override
  Widget build(BuildContext context) {
    final scale = state.position.z.toDouble();
    final characterHeight = canvasHeight * scale;
    final characterWidth = characterHeight * (2 / 3);

    final xPercent = state.position.x.toDouble() / 100;
    final yPercent = state.position.y.toDouble() / 100;

    final leftPos = (xPercent * canvasWidth) - (characterWidth / 2);
    final bottomPos = yPercent * canvasHeight;

    return Positioned(
      left: leftPos,
      bottom: bottomPos,
      child: SizedBox(
        width: characterWidth,
        height: characterHeight,
        child: _CharacterSpriteBody(
          characterState: state,
          model: model,
        ),
      ),
    );
  }
}

class _CharacterSpriteBody extends StatelessWidget {
  const _CharacterSpriteBody({
    required this.characterState,
    required this.model,
  });

  final CharacterState characterState;
  final SceneViewModel model;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned.fill(
          child: CachedNetworkImage(
            imageUrl: model.getCharacterBaseUrl(characterState.characterName),
            fit: BoxFit.contain,
            placeholder: (context, url) => Container(color: FccColors.gray45),
            errorWidget: (context, url, error) => Container(
              color: FccColors.gray75,
              child: const Center(child: Icon(Icons.person, size: 48)),
            ),
          ),
        ),
        Positioned.fill(
          child: CachedNetworkImage(
            imageUrl: model.getCharacterBrowsUrl(characterState.characterName),
            fit: BoxFit.contain,
            placeholder: (context, url) => const SizedBox.expand(),
            errorWidget: (context, url, error) => const SizedBox.shrink(),
          ),
        ),
        Positioned.fill(
          child: CachedNetworkImage(
            imageUrl: model.getCharacterEyesUrl(characterState.characterName),
            fit: BoxFit.contain,
            placeholder: (context, url) => const SizedBox.expand(),
            errorWidget: (context, url, error) => const SizedBox.shrink(),
          ),
        ),
        if (model.getCharacterGlassesUrl(characterState.characterName) != null)
          Positioned.fill(
            child: CachedNetworkImage(
              imageUrl: model.getCharacterGlassesUrl(characterState.characterName)!,
              fit: BoxFit.contain,
              placeholder: (context, url) => const SizedBox.expand(),
              errorWidget: (context, url, error) => const SizedBox.shrink(),
            ),
          ),
        if (characterState.showMouth)
          Positioned.fill(
            child: CachedNetworkImage(
              imageUrl: model.getCharacterMouthUrl(
                characterState.characterName,
                characterState.mouthType,
              ),
              fit: BoxFit.contain,
              placeholder: (context, url) => const SizedBox.expand(),
              errorWidget: (context, url, error) => const SizedBox.shrink(),
            ),
          ),
      ],
    );
  }
}

class _AudioControls extends StatelessWidget {
  const _AudioControls({required this.scene, required this.model});

  final Scene scene;
  final SceneViewModel model;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
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

            final canSeekForward =
                model.audioService.canSeek(true, position.inSeconds, scene.setup.audio);
            final canSeekBackward =
                model.audioService.canSeek(false, position.inSeconds, scene.setup.audio);

            final totalDuration = model.audioService.duration();
            final totalMs = totalDuration?.inMilliseconds ?? 0;

            final hasZeroValue = totalMs == 0 || position.inMilliseconds == 0;
            final progress = hasZeroValue ? 0.0 : position.inMilliseconds / totalMs;

            return Column(
              children: [
                LinearProgressIndicator(
                  backgroundColor: FccColors.gray75,
                  valueColor: const AlwaysStoppedAnimation<Color>(FccColors.blue50),
                  value: progress.clamp(0.0, 1.0),
                  minHeight: 8,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    IconButton(
                      onPressed: canSeekBackward
                          ? () {
                              model.audioService.seek(
                                model.searchTimeStamp(false, position.inSeconds, scene.setup.audio),
                              );
                            }
                          : null,
                      icon: const Icon(Icons.skip_previous),
                    ),
                    IconButton(
                      onPressed: () {
                        if (playerState.playing &&
                            playerState.processingState != AudioProcessingState.completed) {
                          model.audioService.pause();
                        } else {
                          model.onPlay();
                        }
                      },
                      icon: playerState.playing &&
                              playerState.processingState != AudioProcessingState.completed
                          ? const Icon(Icons.pause)
                          : const Icon(Icons.play_arrow),
                    ),
                    IconButton(
                      onPressed: canSeekForward
                          ? () {
                              model.audioService.seek(
                                model.searchTimeStamp(true, position.inSeconds, scene.setup.audio),
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
    );
  }
}
