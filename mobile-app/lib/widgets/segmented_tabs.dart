import 'package:flutter/material.dart';
import 'package:freecodecamp/fcc_theme.dart';

typedef SegmentedTab<T> = ({T value, String label, IconData? icon});

class SegmentedTabs<T> extends StatelessWidget {
  const SegmentedTabs({
    super.key,
    required this.tabs,
    required this.selected,
    required this.onSelected,
    this.fontFamily = 'Lato',
    this.fontSize = 15,
    this.selectedWeight = FontWeight.w900,
    this.unselectedWeight = FontWeight.w700,
    this.backgroundColor,
    this.borderColor,
    this.selectedBackgroundColor,
    this.selectedBorderColor,
    this.selectedForegroundColor,
    this.unselectedForegroundColor,
  });

  final List<SegmentedTab<T>> tabs;
  final T selected;
  final ValueChanged<T>? onSelected;
  final String fontFamily;
  final double fontSize;
  final FontWeight selectedWeight;
  final FontWeight unselectedWeight;
  final Color? backgroundColor;
  final Color? borderColor;
  final Color? selectedBackgroundColor;
  final Color? selectedBorderColor;
  final Color? selectedForegroundColor;
  final Color? unselectedForegroundColor;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final design = FccDesignColors.of(context);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 2),
      decoration: BoxDecoration(
        color: backgroundColor ?? colors.surface,
        border: Border.all(color: borderColor ?? colors.outlineVariant),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          for (final tab in tabs)
            Expanded(
              child: _Segment(
                label: tab.label,
                icon: tab.icon,
                isSelected: tab.value == selected,
                onTap: onSelected == null
                    ? null
                    : () {
                        if (tab.value != selected) onSelected!(tab.value);
                      },
                accent: selectedBorderColor ?? design.accentText,
                selectedBackground:
                    selectedBackgroundColor ?? colors.primaryContainer,
                selectedForeground: selectedForegroundColor ?? colors.onSurface,
                unselectedForeground:
                    unselectedForegroundColor ?? colors.onSurfaceVariant,
                fontFamily: fontFamily,
                fontSize: fontSize,
                selectedWeight: selectedWeight,
                unselectedWeight: unselectedWeight,
              ),
            ),
        ],
      ),
    );
  }
}

class _Segment extends StatefulWidget {
  const _Segment({
    required this.label,
    required this.icon,
    required this.isSelected,
    required this.onTap,
    required this.accent,
    required this.selectedBackground,
    required this.selectedForeground,
    required this.unselectedForeground,
    required this.fontFamily,
    required this.fontSize,
    required this.selectedWeight,
    required this.unselectedWeight,
  });

  final String label;
  final IconData? icon;
  final bool isSelected;
  final VoidCallback? onTap;
  final Color accent;
  final Color selectedBackground;
  final Color selectedForeground;
  final Color unselectedForeground;
  final String fontFamily;
  final double fontSize;
  final FontWeight selectedWeight;
  final FontWeight unselectedWeight;

  @override
  State<_Segment> createState() => _SegmentState();
}

class _SegmentState extends State<_Segment> {
  bool _focused = false;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final enabled = widget.onTap != null;
    final foreground = !enabled
        ? colors.outline
        : widget.isSelected
        ? widget.selectedForeground
        : widget.unselectedForeground;
    final shape = FccTheme.focusShape(context, radius: 8)
        .resolve({
          if (_focused) WidgetState.focused,
          if (!enabled) WidgetState.disabled,
        })!
        .copyWith(
          side: enabled && widget.isSelected
              ? BorderSide(color: widget.accent, width: 1.5)
              : BorderSide.none,
        );
    return Semantics(
      label: widget.label,
      button: true,
      selected: widget.isSelected,
      enabled: enabled,
      focusable: enabled,
      focused: enabled ? _focused : null,
      onTap: widget.onTap,
      child: ExcludeSemantics(
        child: Material(
          type: MaterialType.transparency,
          child: InkWell(
            onTap: widget.onTap,
            onFocusChange: (focused) => setState(() => _focused = focused),
            focusColor: Colors.transparent,
            borderRadius: BorderRadius.circular(10),
            child: Padding(
              // Keep the 44px visual pill inside a full-height semantic target.
              padding: const EdgeInsets.symmetric(horizontal: 2, vertical: 4),
              child: Material(
                color: !enabled
                    ? colors.surfaceContainer
                    : widget.isSelected
                    ? widget.selectedBackground
                    : Colors.transparent,
                shape: shape,
                child: ConstrainedBox(
                  constraints: const BoxConstraints(minHeight: 44),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      vertical: 8,
                      horizontal: 4,
                    ),
                    child: Center(
                      heightFactor: 1,
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        spacing: 8,
                        children: [
                          if (widget.icon != null)
                            Icon(widget.icon, size: 18, color: foreground),
                          Flexible(
                            child: Text(
                              widget.label,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                letterSpacing: 0,
                                fontFamily: widget.fontFamily,
                                fontSize: widget.fontSize,
                                fontWeight: widget.isSelected
                                    ? widget.selectedWeight
                                    : widget.unselectedWeight,
                                color: foreground,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
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
