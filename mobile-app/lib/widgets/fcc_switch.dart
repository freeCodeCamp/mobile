import 'package:flutter/material.dart';
import 'package:freecodecamp/fcc_theme.dart';

class FccSwitch extends StatefulWidget {
  const FccSwitch({
    super.key,
    required this.value,
    required this.onChanged,
    this.semanticLabel,
  });

  final bool value;
  final ValueChanged<bool>? onChanged;
  final String? semanticLabel;

  @override
  State<FccSwitch> createState() => _FccSwitchState();
}

class _FccSwitchState extends State<FccSwitch> {
  static const _duration = Duration(milliseconds: 200);

  final _focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    _focusNode.addListener(_focusChanged);
  }

  void _focusChanged() => setState(() {});

  @override
  void dispose() {
    _focusNode.removeListener(_focusChanged);
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;
    final enabled = widget.onChanged != null;
    final on = widget.value;
    final states = {
      if (on) WidgetState.selected,
      if (!enabled) WidgetState.disabled,
    };
    final switchTheme = theme.switchTheme;
    // The off state keeps its own colors. The on state follows the switch theme.
    final trackColor = on
        ? switchTheme.trackColor?.resolve(states) ?? colors.primary
        : colors.surfaceContainer;
    final outlineColor = on
        ? switchTheme.trackOutlineColor?.resolve(states) ?? colors.primary
        : colors.outline;
    final thumbColor = on
        ? switchTheme.thumbColor?.resolve(states) ?? colors.onPrimary
        : enabled
        ? colors.onSurfaceVariant
        : colors.outline;
    final duration = MediaQuery.disableAnimationsOf(context)
        ? Duration.zero
        : _duration;
    void toggle() => widget.onChanged?.call(!on);
    return Semantics(
      label: widget.semanticLabel,
      toggled: on,
      enabled: enabled,
      onTap: enabled ? toggle : null,
      child: InkWell(
        excludeFromSemantics: true,
        focusNode: _focusNode,
        onTap: enabled ? toggle : null,
        focusColor: Colors.transparent,
        borderRadius: BorderRadius.circular(24),
        child: SizedBox(
          width: 60,
          height: 48,
          child: Center(
            // The ring stays outside the animated track: FocusRingBorder
            // ignores its ring in ==, so an implicit animation never updates it.
            child: Container(
              width: 48,
              height: 28,
              foregroundDecoration: ShapeDecoration(
                shape: FccTheme.focusShape(context, radius: 14).resolve({
                  if (_focusNode.hasFocus) WidgetState.focused,
                  if (!enabled) WidgetState.disabled,
                })!,
              ),
              child: AnimatedContainer(
                duration: duration,
                curve: Curves.easeInOut,
                padding: const EdgeInsets.symmetric(horizontal: 2),
                alignment: on
                    ? AlignmentDirectional.centerEnd
                    : AlignmentDirectional.centerStart,
                decoration: BoxDecoration(
                  color: trackColor,
                  border: Border.all(color: outlineColor),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: AnimatedContainer(
                  duration: duration,
                  curve: Curves.easeInOut,
                  width: 22,
                  height: 22,
                  decoration: BoxDecoration(
                    color: thumbColor,
                    shape: BoxShape.circle,
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
