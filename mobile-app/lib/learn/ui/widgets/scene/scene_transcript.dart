import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:freecodecamp/fcc_theme.dart';
import 'package:freecodecamp/learn/controllers/scene_controller.dart';
import 'package:freecodecamp/learn/models/challenge_model.dart';

class SceneTranscript extends ConsumerWidget {
  const SceneTranscript({super.key, required this.scene, required this.title});

  final Scene scene;
  final String title;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final activeLine = ref.watch(
      sceneProvider(scene, title).select((state) => state.line),
    );
    final colors = Theme.of(context).colorScheme;
    final accent = FccDesignColors.of(context).accentText;

    return Column(
      spacing: 8,
      children: [
        for (final command in scene.commands)
          if (command.dialogue case final line?)
            AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              curve: Curves.easeOut,
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                color:
                    activeLine?.character == command.character &&
                        activeLine?.text == line.text
                    ? accent.withValues(alpha: 0.18)
                    : Colors.transparent,
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.baseline,
                textBaseline: TextBaseline.alphabetic,
                children: [
                  SizedBox(
                    width: 46,
                    child: Text(
                      command.character,
                      style: TextStyle(
                        fontSize: 14,
                        height: 1.4,
                        color: accent,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      line.text.replaceAll(RegExp('<[^>]*>'), ''),
                      style: TextStyle(
                        fontSize: 14,
                        height: 1.4,
                        color: colors.onSurface,
                      ),
                    ),
                  ),
                ],
              ),
            ),
      ],
    );
  }
}
