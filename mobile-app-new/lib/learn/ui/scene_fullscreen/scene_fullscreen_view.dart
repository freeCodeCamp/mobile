import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:mobile_app_new/fcc_theme.dart';
import 'package:mobile_app_new/learn/models/challenge_model.dart';
import 'package:mobile_app_new/learn/ui/challenge/widgets/scene/scene_canvas.dart';
import 'package:mobile_app_new/learn/ui/challenge/widgets/scene/scene_controls.dart';

class SceneFullscreenView extends StatefulWidget {
  const SceneFullscreenView({
    super.key,
    required this.scene,
    required this.title,
  });

  final Scene scene;
  final String title;

  @override
  State<SceneFullscreenView> createState() => _SceneFullscreenViewState();
}

class _SceneFullscreenViewState extends State<SceneFullscreenView> {
  final _controlsKey = GlobalKey();
  double _controlsHeight = 0;

  @override
  void initState() {
    super.initState();
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final box = _controlsKey.currentContext?.findRenderObject() as RenderBox?;
      if (mounted && box != null && box.hasSize) {
        setState(() => _controlsHeight = box.size.height);
      }
    });
  }

  @override
  void dispose() {
    SystemChrome.setPreferredOrientations([]);
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
            child: SceneCanvas(
              scene: widget.scene,
              title: widget.title,
              captionsBottom: _controlsHeight,
            ),
          ),
          Positioned(
            top: 16,
            right: 16,
            child: DecoratedBox(
              decoration: BoxDecoration(
                color: Colors.black54,
                borderRadius: BorderRadius.circular(4),
              ),
              child: IconButton(
                tooltip: 'Exit fullscreen',
                icon: const Icon(
                  Icons.fullscreen_exit,
                  color: FccColors.gray00,
                  size: 32,
                ),
                onPressed: () => context.pop(),
              ),
            ),
          ),
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: SceneControls(
              key: _controlsKey,
              scene: widget.scene,
              title: widget.title,
              fullscreen: true,
            ),
          ),
        ],
      ),
    );
  }
}
