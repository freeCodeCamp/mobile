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
    // Preserve the existing Material on state; its off geometry is not configurable.
    if (widget.value) {
      return Semantics(
        label: widget.semanticLabel,
        child: Switch(
          value: true,
          onChanged: widget.onChanged,
          focusNode: _focusNode,
        ),
      );
    }
    final colors = Theme.of(context).colorScheme;
    final enabled = widget.onChanged != null;
    void toggle() => widget.onChanged?.call(true);
    return Semantics(
      label: widget.semanticLabel,
      toggled: false,
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
            child: Container(
              width: 48,
              height: 28,
              padding: const EdgeInsets.symmetric(horizontal: 2),
              alignment: AlignmentDirectional.centerStart,
              foregroundDecoration: ShapeDecoration(
                shape: FccTheme.focusShape(context, radius: 14).resolve({
                  if (_focusNode.hasFocus) WidgetState.focused,
                  if (!enabled) WidgetState.disabled,
                })!,
              ),
              decoration: BoxDecoration(
                color: colors.surfaceContainer,
                border: Border.all(color: colors.outline),
                borderRadius: BorderRadius.circular(14),
              ),
              child: Container(
                width: 22,
                height: 22,
                decoration: BoxDecoration(
                  color: enabled ? colors.onSurfaceVariant : colors.outline,
                  shape: BoxShape.circle,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
