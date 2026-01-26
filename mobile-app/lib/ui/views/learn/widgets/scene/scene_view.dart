import 'package:audio_service/audio_service.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
                child: _SceneCanvas(model: model),
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

void _showFullscreenOverlay(BuildContext context, SceneViewModel model) {
  Navigator.of(context).push(
    PageRouteBuilder(
      opaque: false,
      pageBuilder: (context, animation, secondaryAnimation) {
        return _FullscreenSceneOverlay(model: model);
      },
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        return FadeTransition(opacity: animation, child: child);
      },
    ),
  );
}

class _FullscreenSceneOverlay extends StatefulWidget {
  const _FullscreenSceneOverlay({required this.model});

  final SceneViewModel model;

  @override
  State<_FullscreenSceneOverlay> createState() =>
      _FullscreenSceneOverlayState();
}

class _FullscreenSceneOverlayState extends State<_FullscreenSceneOverlay> {
  final GlobalKey _controlsKey = GlobalKey();
  double _controlsHeight = 0;

  @override
  void initState() {
    super.initState();
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
    WidgetsBinding.instance.addPostFrameCallback((_) => _measureControlsHeight());
  }

  void _measureControlsHeight() {
    final renderBox =
        _controlsKey.currentContext?.findRenderObject() as RenderBox?;
    if (renderBox != null && renderBox.hasSize) {
      setState(() {
        _controlsHeight = renderBox.size.height;
      });
    }
  }

  @override
  void dispose() {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          Positioned.fill(
            child: _SceneCanvas(
              model: widget.model,
              dialogueBottomPadding: _controlsHeight,
            ),
          ),
          Positioned(
            top: 16,
            right: 16,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.black54,
                borderRadius: BorderRadius.circular(4),
              ),
              child: IconButton(
                icon: const Icon(Icons.fullscreen_exit,
                    color: Colors.white, size: 32),
                onPressed: () => Navigator.of(context).pop(),
                padding: const EdgeInsets.all(8),
                constraints: const BoxConstraints(),
              ),
            ),
          ),
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: _FullscreenControls(
              key: _controlsKey,
              model: widget.model,
            ),
          ),
        ],
      ),
    );
  }
}

class _FullscreenControls extends StatelessWidget {
  const _FullscreenControls({super.key, required this.model});

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
              return const SizedBox.shrink();
            }

            final position = positionSnapshot.data as Duration;
            final totalDuration = model.audioService.duration();
            final totalMs = totalDuration?.inMilliseconds ?? 0;

            final hasZeroValue = totalMs == 0 || position.inMilliseconds == 0;
            final progress =
                hasZeroValue ? 0.0 : position.inMilliseconds / totalMs;

            final isPlaying = playerState.playing &&
                playerState.processingState != AudioProcessingState.completed;
            final isCompleted =
                playerState.processingState == AudioProcessingState.completed;

            return Container(
              color: Colors.black54,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Row(
                children: [
                  IconButton(
                    onPressed: () {
                      if (isPlaying) {
                        model.audioService.pause();
                      } else {
                        model.onPlay();
                      }
                    },
                    icon: Icon(
                      isCompleted
                          ? Icons.replay
                          : isPlaying
                              ? Icons.pause
                              : Icons.play_arrow,
                      color: Colors.white,
                      size: 32,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: LinearProgressIndicator(
                      backgroundColor: FccColors.gray75,
                      valueColor:
                          const AlwaysStoppedAnimation<Color>(FccColors.blue50),
                      value: progress.clamp(0.0, 1.0),
                      minHeight: 6,
                    ),
                  ),
                  const SizedBox(width: 12),
                  IconButton(
                    onPressed: () => model.toggleCaptions(),
                    icon: Icon(
                      model.showCaptions
                          ? Icons.closed_caption
                          : Icons.closed_caption_off,
                      color: Colors.white,
                      size: 28,
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }
}

class _SceneCanvas extends StatelessWidget {
  const _SceneCanvas({required this.model, this.dialogueBottomPadding = 0});

  final SceneViewModel model;
  final double dialogueBottomPadding;

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: model,
      builder: (context, child) {
        return Stack(
          children: [
            if (model.currentBackground != null)
              Positioned.fill(
                child: CachedNetworkImage(
                  imageUrl: model.getBackgroundUrl(model.currentBackground!),
                  fit: BoxFit.cover,
                  placeholder: (context, url) =>
                      Container(color: FccColors.gray75),
                  errorWidget: (context, url, error) => Container(
                    color: FccColors.gray75,
                    child: const Center(
                      child: Icon(Icons.broken_image, size: 48),
                    ),
                  ),
                ),
              ),
            Positioned.fill(
              child: _CharactersContainer(model: model),
            ),
            if (model.showCaptions && model.currentDialogueText != null)
              Positioned(
                left: 0,
                right: 0,
                bottom: dialogueBottomPadding,
                child: _DialogueOverlay(
                  character: model.currentDialogueCharacter ?? '',
                  text: model.currentDialogueText!,
                  align: model.currentDialogueAlign ?? 'left',
                ),
              ),
          ],
        );
      },
    );
  }
}

class _DialogueOverlay extends StatelessWidget {
  const _DialogueOverlay({
    required this.character,
    required this.text,
    required this.align,
  });

  final String character;
  final String text;
  final String align;

  @override
  Widget build(BuildContext context) {
    final crossAxisAlignment =
        align == 'right' ? CrossAxisAlignment.end : CrossAxisAlignment.start;

    return Container(
      color: Colors.black.withValues(alpha: 0.7),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: crossAxisAlignment,
        children: [
          Text(
            character,
            style: const TextStyle(
              color: FccColors.blue50,
              fontWeight: FontWeight.bold,
              fontSize: 12,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            text,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }
}

class _CharactersContainer extends StatelessWidget {
  const _CharactersContainer({
    required this.model,
  });

  final SceneViewModel model;

  @override
  Widget build(BuildContext context) {
    final characters = model.visibleCharacters;

    return LayoutBuilder(
      builder: (context, constraints) {
        final canvasWidth = constraints.maxWidth;
        final canvasHeight = constraints.maxHeight;

        return Stack(
          clipBehavior: Clip.hardEdge,
          children: [
            for (final character in characters)
              _CharacterSlot(
                key: ValueKey('slot_${character.characterName}'),
                state: character,
                model: model,
                canvasWidth: canvasWidth,
                canvasHeight: canvasHeight,
              ),
          ],
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

    final xPercent = state.position.x.toDouble()  / 100;
    final yPercent = state.position.y.toDouble() / 100;

    final leftPos = (xPercent * canvasWidth) - (characterWidth / 2);

   // I have no clue why this works, but it does.
    final removeBottomYScale = characterHeight - canvasHeight;
    final handleRemoveBottomYScale = yPercent <= 0 ? removeBottomYScale / 2 : removeBottomYScale * 2;
    final bottomPos = (yPercent * canvasHeight) - handleRemoveBottomYScale;

    return AnimatedPositioned(  
      duration: const Duration(milliseconds: 500),
      curve: Curves.easeInOut,
      left: leftPos,
      bottom: bottomPos,
      child: AnimatedOpacity(
        opacity: state.opacity,
        duration: const Duration(milliseconds: 500),
        child: SizedBox(
          width: characterWidth,
          height: characterHeight,
          child: _CharacterSpriteBody(
            characterState: state,
            model: model,
          ),
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

  Widget _buildLayer(String imageUrl) {
    return Positioned.fill(
      child: CachedNetworkImage(
        imageUrl: imageUrl,
        fit: BoxFit.contain,
        placeholder: (context, url) => const SizedBox.expand(),
        errorWidget: (context, url, error) => const SizedBox.shrink(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final name = characterState.characterName;
    final glassesUrl = model.getCharacterGlassesUrl(name);

    return Stack(
      children: [
        Positioned.fill(
          child: CachedNetworkImage(
            imageUrl: model.getCharacterBaseUrl(name),
            fit: BoxFit.contain,
            placeholder: (context, url) => Container(color: FccColors.gray45),
            errorWidget: (context, url, error) => Container(
              color: FccColors.gray75,
              child: const Center(child: Icon(Icons.person, size: 48)),
            ),
          ),
        ),
        _buildLayer(model.getCharacterBrowsUrl(name)),
        _buildLayer(model.getCharacterEyesUrl(name)),
        if (glassesUrl != null) _buildLayer(glassesUrl),
        if (characterState.showMouth)
          _buildLayer(
              model.getCharacterMouthUrl(name, characterState.mouthType)),
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
            final totalDuration = model.audioService.duration();
            final totalMs = totalDuration?.inMilliseconds ?? 0;

            final hasZeroValue = totalMs == 0 || position.inMilliseconds == 0;
            final progress =
                hasZeroValue ? 0.0 : position.inMilliseconds / totalMs;

            return Column(
              children: [
                LinearProgressIndicator(
                  backgroundColor: FccColors.gray75,
                  valueColor:
                      const AlwaysStoppedAnimation<Color>(FccColors.blue50),
                  value: progress.clamp(0.0, 1.0),
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
                          model.audioService.pause();
                        } else {
                          model.onPlay();
                        }
                      },
                      icon: playerState.processingState ==
                              AudioProcessingState.completed
                          ? const Icon(Icons.replay)
                          : playerState.playing
                              ? const Icon(Icons.pause)
                              : const Icon(Icons.play_arrow),
                    ),
                    IconButton(
                      onPressed: () => model.toggleCaptions(),
                      icon: Icon(
                        model.showCaptions
                            ? Icons.closed_caption
                            : Icons.closed_caption_off,
                      ),
                    ),
                    IconButton(
                      onPressed: () => _showFullscreenOverlay(context, model),
                      icon: const Icon(Icons.fullscreen),
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
