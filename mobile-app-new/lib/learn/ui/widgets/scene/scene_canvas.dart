import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mobile_app_new/fcc_theme.dart';
import 'package:mobile_app_new/learn/models/challenge_model.dart';
import 'package:mobile_app_new/learn/controllers/scene_controller.dart';

class SceneCanvas extends ConsumerWidget {
  const SceneCanvas({super.key, required this.scene, required this.title});

  final Scene scene;
  final String title;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(sceneProvider(scene, title));
    final assets = ref.watch(sceneAssetsProvider).value;
    final colors = Theme.of(context).colorScheme;
    if (assets == null) return ColoredBox(color: colors.surfaceContainer);

    final line = state.line;
    // NOTE: Lower z is further back, so it paints first.
    final characters = [...state.characters]
      ..sort((a, b) => b.position.z.compareTo(a.position.z));

    return LayoutBuilder(
      builder: (context, constraints) => Stack(
        clipBehavior: Clip.hardEdge,
        children: [
          Positioned.fill(
            child: CachedNetworkImage(
              imageUrl: sceneBackgroundUrl(assets, state.background),
              fit: BoxFit.cover,
              placeholder: (_, _) => ColoredBox(color: colors.surfaceContainer),
              errorWidget: (_, _, _) => ColoredBox(
                color: colors.surfaceContainer,
                child: Center(
                  child: Icon(
                    Icons.broken_image,
                    size: 48,
                    color: colors.onSurfaceVariant,
                  ),
                ),
              ),
            ),
          ),
          for (final character in characters)
            if (characterSprites(assets, character) case final sprites?)
              _Character(
                key: ValueKey(character.name),
                state: character,
                sprites: sprites,
                canvas: constraints.biggest,
              ),
          if (state.showCaptions && line != null)
            Positioned(
              left: 0,
              right: 0,
              bottom: MediaQuery.paddingOf(context).bottom,
              child: _Caption(line: line),
            ),
        ],
      ),
    );
  }
}

class _Caption extends StatelessWidget {
  const _Caption({required this.line});

  final SceneLine line;

  @override
  Widget build(BuildContext context) {
    final overlay = FccTheme.themeDark;
    return Container(
      color: Colors.black.withValues(alpha: 0.7),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: line.align == 'right'
            ? CrossAxisAlignment.end
            : CrossAxisAlignment.start,
        children: [
          Text(
            line.character,
            style: TextStyle(
              color: overlay.extension<FccDesignColors>()!.accentText,
              fontWeight: FontWeight.bold,
              fontSize: 12,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            line.text,
            style: TextStyle(
              color: overlay.colorScheme.onSurface,
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }
}

// NOTE: Positions are percentages of the canvas; z scales the character and orders the stack.
class _Character extends StatelessWidget {
  const _Character({
    super.key,
    required this.state,
    required this.sprites,
    required this.canvas,
  });

  final CharacterState state;
  final CharacterSprites sprites;
  final Size canvas;

  Widget _layer(String url) => Positioned.fill(
    child: CachedNetworkImage(
      imageUrl: url,
      fit: BoxFit.contain,
      placeholder: (_, _) => const SizedBox.expand(),
      errorWidget: (_, _, _) => const SizedBox.shrink(),
    ),
  );

  @override
  Widget build(BuildContext context) {
    final height = canvas.height * state.position.z.toDouble();
    final width = height * 2 / 3;
    final left = state.position.x.toDouble() / 100 * canvas.width - width / 2;
    final bottom =
        -(height - canvas.height) / 2 -
        state.position.y.toDouble() / 100 * canvas.height;

    return AnimatedPositioned(
      duration: const Duration(milliseconds: 500),
      curve: Curves.easeInOut,
      left: left,
      bottom: bottom,
      width: width,
      height: height,
      child: AnimatedOpacity(
        opacity: state.opacity,
        duration: const Duration(milliseconds: 500),
        child: Stack(
          children: [
            _layer(sprites.base),
            _layer(sprites.brows),
            _layer(sprites.eyes),
            if (sprites.glasses case final glasses?) _layer(glasses),
            _layer(sprites.mouth),
          ],
        ),
      ),
    );
  }
}
