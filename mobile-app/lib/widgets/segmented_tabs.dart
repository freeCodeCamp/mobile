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
  });

  final List<SegmentedTab<T>> tabs;
  final T selected;
  final ValueChanged<T>? onSelected;
  final String fontFamily;
  final double fontSize;
  final FontWeight selectedWeight;
  final FontWeight unselectedWeight;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final design = FccDesignColors.of(context);
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: colors.surface,
        border: Border.all(color: colors.outlineVariant),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        spacing: 4,
        children: [
          for (final tab in tabs)
            Expanded(
              child: _Segment(
                label: tab.label,
                icon: tab.icon,
                isSelected: tab.value == selected,
                onTap: onSelected == null ? null : () => onSelected!(tab.value),
                accent: design.accentText,
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

class _Segment extends StatelessWidget {
  const _Segment({
    required this.label,
    required this.icon,
    required this.isSelected,
    required this.onTap,
    required this.accent,
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
  final String fontFamily;
  final double fontSize;
  final FontWeight selectedWeight;
  final FontWeight unselectedWeight;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final foreground = isSelected ? colors.onSurface : colors.onSurfaceVariant;
    final shape = RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(8),
      side: isSelected
          ? BorderSide(color: accent, width: 1.5)
          : BorderSide.none,
    );
    return Semantics(
      button: true,
      selected: isSelected,
      child: Material(
        color: isSelected ? colors.primaryContainer : Colors.transparent,
        shape: shape,
        child: InkWell(
          customBorder: shape,
          onTap: isSelected ? null : onTap,
          child: ConstrainedBox(
            constraints: const BoxConstraints(minHeight: 44),
            child: Center(
              child: Row(
                mainAxisSize: MainAxisSize.min,
                spacing: 8,
                children: [
                  if (icon != null) Icon(icon, size: 18, color: foreground),
                  Flexible(
                    child: Text(
                      label,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        letterSpacing: 0,
                        fontFamily: fontFamily,
                        fontSize: fontSize,
                        fontWeight: isSelected
                            ? selectedWeight
                            : unselectedWeight,
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
    );
  }
}
