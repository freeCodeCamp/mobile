import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:freecodecamp/learn/models/challenge_model.dart';
import 'package:freecodecamp/learn/ui/challenge/widgets/parsed_html.dart';
import 'package:freecodecamp/learn/ui/challenge/widgets/tool_button.dart';
import 'package:freecodecamp/learn/ui/widgets/scene/scene_transcript.dart';

bool hasTranscript(Challenge challenge) =>
    challenge.transcript.isNotEmpty || challenge.scene != null;

class TranscriptPanel extends StatefulWidget {
  const TranscriptPanel({
    super.key,
    required this.challenge,
    required this.availableHeight,
    required this.visible,
    required this.onClose,
  });
  final Challenge challenge;
  final double availableHeight;
  final bool visible;
  final VoidCallback onClose;

  @override
  State<TranscriptPanel> createState() => _TranscriptPanelState();
}

class _TranscriptPanelState extends State<TranscriptPanel> {
  double? _height;
  var _hidden = true;

  @override
  void didUpdateWidget(TranscriptPanel oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.visible && !oldWidget.visible) {
      _height = null;
      _hidden = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    final reduceMotion = MediaQuery.disableAnimationsOf(context);
    // Offstage once the slide ends, so the panel shadow never peeks out.
    return Offstage(
      offstage: !widget.visible && (reduceMotion || _hidden),
      child: IgnorePointer(
        ignoring: !widget.visible,
        child: ExcludeSemantics(
          excluding: !widget.visible,
          child: AnimatedSlide(
            offset: widget.visible || reduceMotion
                ? Offset.zero
                : const Offset(0, 1),
            duration: reduceMotion
                ? Duration.zero
                : const Duration(milliseconds: 280),
            curve: Curves.easeOutCubic,
            onEnd: () {
              if (!widget.visible && !_hidden) {
                setState(() => _hidden = true);
              }
            },
            child: _panel(context),
          ),
        ),
      ),
    );
  }

  Widget _panel(BuildContext context) {
    final challenge = widget.challenge;
    final colors = Theme.of(context).colorScheme;
    final scale = MediaQuery.textScalerOf(context).scale(1);
    final maxHeight = widget.availableHeight;
    final minHeight = math.min(180.0 * math.min(scale, 1.4), maxHeight);
    final height = (_height ?? minHeight).clamp(minHeight, maxHeight);
    return Container(
      key: const ValueKey('transcript-panel'),
      height: height,
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
        boxShadow: [
          BoxShadow(
            color: colors.shadow.withValues(alpha: .15),
            blurRadius: 24,
            offset: const Offset(0, -6),
          ),
        ],
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        children: [
          GestureDetector(
            behavior: HitTestBehavior.opaque,
            onVerticalDragUpdate: (details) => setState(
              () => _height = (height - details.delta.dy).clamp(
                minHeight,
                maxHeight,
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 10),
              child: Center(
                child: Container(
                  width: 36,
                  height: 4,
                  decoration: BoxDecoration(
                    color: colors.outlineVariant,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 16, right: 4),
            child: Row(
              children: [
                const Expanded(
                  child: Text(
                    'Transcript',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w900),
                  ),
                ),
                IconButton(
                  tooltip: 'Hide panel',
                  onPressed: widget.onClose,
                  icon: const Icon(Icons.keyboard_arrow_down_rounded),
                ),
              ],
            ),
          ),
          Divider(height: 1, color: colors.outlineVariant),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: challenge.transcript.isNotEmpty
                  ? ParsedHtml(challenge.transcript)
                  : SceneTranscript(
                      scene: challenge.scene!,
                      title: challenge.title,
                    ),
            ),
          ),
        ],
      ),
    );
  }
}

class TranscriptFooter extends StatelessWidget {
  const TranscriptFooter({
    super.key,
    required this.challenge,
    required this.active,
    required this.onToggle,
    required this.child,
  });
  final Challenge challenge;
  final bool active;
  final VoidCallback onToggle;
  final Widget child;

  @override
  Widget build(BuildContext context) => hasTranscript(challenge)
      ? Row(
          children: [
            ToolButton(
              label: 'Transcript',
              icon: Icons.subtitles_outlined,
              selectedIcon: Icons.subtitles,
              active: active,
              onPressed: onToggle,
            ),
            const SizedBox(width: 8),
            Expanded(child: child),
          ],
        )
      : child;
}
