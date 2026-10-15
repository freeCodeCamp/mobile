import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mobile_app_new/learn/models/challenge_model.dart';
import 'package:mobile_app_new/learn/ui/challenge/widgets/scene/scene_canvas.dart';
import 'package:mobile_app_new/learn/ui/challenge/widgets/scene/scene_controls.dart';
import 'package:mobile_app_new/learn/ui/challenge/widgets/scene/scene_viewmodel.dart';
import 'package:mobile_app_new/routing/learn.dart';

class SceneView extends ConsumerStatefulWidget {
  const SceneView({super.key, required this.scene, required this.title});

  final Scene scene;
  final String title;

  @override
  ConsumerState<SceneView> createState() => _SceneViewState();
}

class _SceneViewState extends ConsumerState<SceneView> {
  bool _precached = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_precached) return;
    _precached = true;

    final assets = ref.read(sceneAssetsProvider).value;
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
    final colors = Theme.of(context).colorScheme;
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 16),
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: colors.outlineVariant),
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
