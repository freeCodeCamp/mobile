import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mobile_app_new/fcc_theme.dart';
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
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
      child: Column(
        children: [
          AspectRatio(
            aspectRatio: 16 / 9,
            child: DecoratedBox(
              decoration: BoxDecoration(
                color: Colors.black,
                border: Border.all(color: FccColors.gray75, width: 2),
              ),
              child: SceneCanvas(scene: widget.scene, title: widget.title),
            ),
          ),
          const SizedBox(height: 16),
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
