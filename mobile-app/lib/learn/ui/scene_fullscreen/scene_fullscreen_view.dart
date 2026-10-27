import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:freecodecamp/learn/models/challenge_model.dart';
import 'package:freecodecamp/learn/ui/widgets/scene/scene_canvas.dart';
import 'package:freecodecamp/learn/ui/widgets/scene/scene_controls.dart';
import 'package:go_router/go_router.dart';

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
  @override
  void initState() {
    super.initState();
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
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
      extendBody: true,
      bottomNavigationBar: SceneControls(
        scene: widget.scene,
        title: widget.title,
        fullscreen: true,
      ),
      body: Stack(
        children: [
          Positioned.fill(
            child: SceneCanvas(scene: widget.scene, title: widget.title),
          ),
          Positioned(
            top: 16,
            right: 16,
            child: DecoratedBox(
              decoration: BoxDecoration(
                color: Colors.black54,
                borderRadius: BorderRadius.circular(12),
              ),
              child: IconButton(
                tooltip: 'Exit fullscreen',
                icon: const Icon(
                  Icons.fullscreen_exit,
                  color: Color(0xFFFFF8EC),
                  size: 32,
                ),
                onPressed: () => context.pop(),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
