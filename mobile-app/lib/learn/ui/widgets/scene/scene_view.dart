import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:freecodecamp/learn/controllers/scene_controller.dart';
import 'package:freecodecamp/learn/models/challenge_model.dart';
import 'package:freecodecamp/learn/models/scene_assets_model.dart';
import 'package:freecodecamp/learn/ui/widgets/scene/scene_canvas.dart';
import 'package:freecodecamp/learn/ui/widgets/scene/scene_controls.dart';
import 'package:freecodecamp/routing/learn.dart';

class SceneView extends ConsumerStatefulWidget {
  const SceneView({
    super.key,
    required this.scene,
    required this.title,
    this.edgeToEdge = false,
  });

  final Scene scene;
  final String title;
  final bool edgeToEdge;

  @override
  ConsumerState<SceneView> createState() => _SceneViewState();
}

class _SceneViewState extends ConsumerState<SceneView> {
  bool _precached = false;

  void _precache(SceneAssets assets) {
    _precached = true;
    final backgrounds = {
      widget.scene.setup.background,
      for (final c in widget.scene.commands) ?c.background,
    };
    for (final bg in backgrounds) {
      precacheImage(
        CachedNetworkImageProvider(sceneBackgroundUrl(assets, bg)),
        context,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final assets = ref.watch(sceneAssetsProvider).value;
    if (assets != null && !_precached) _precache(assets);

    final colors = Theme.of(context).colorScheme;
    return Container(
      margin: widget.edgeToEdge
          ? EdgeInsets.zero
          : const EdgeInsets.symmetric(vertical: 16),
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: widget.edgeToEdge
            ? BorderRadius.zero
            : BorderRadius.circular(16),
        border: widget.edgeToEdge
            ? null
            : Border.all(color: colors.outlineVariant),
      ),
      child: Column(
        children: [
          AspectRatio(
            aspectRatio: 16 / 9,
            child: ColoredBox(
              color: Colors.black,
              child: SceneCanvas(scene: widget.scene, title: widget.title),
            ),
          ),
          SceneControls(
            scene: widget.scene,
            title: widget.title,
            onFullscreen: () => LearnSceneFullscreenRoute(
              $extra: (widget.scene, widget.title),
            ).push<void>(context),
          ),
        ],
      ),
    );
  }
}
