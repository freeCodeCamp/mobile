import 'package:flutter/material.dart';
import 'package:freecodecamp/fcc_theme.dart';

class ToolButton extends StatelessWidget {
  const ToolButton({
    super.key,
    required this.label,
    required this.icon,
    required this.selectedIcon,
    required this.active,
    required this.onPressed,
    this.badge,
    this.badgeColor,
  });
  final String label;
  final IconData icon;
  final IconData selectedIcon;
  final bool active;
  final VoidCallback onPressed;
  final String? badge;
  final Color? badgeColor;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return TextButton(
      onPressed: onPressed,
      style:
          FccTheme.surfaceButtonStyle(
            context,
            fill: Colors.transparent,
            foreground: active ? colors.onSurface : colors.onSurfaceVariant,
          ).copyWith(
            padding: const WidgetStatePropertyAll(
              EdgeInsets.symmetric(horizontal: 10, vertical: 8),
            ),
            minimumSize: const WidgetStatePropertyAll(Size(60, 64)),
          ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Badge(
            isLabelVisible: badge != null,
            label: Container(
              padding: const EdgeInsets.symmetric(horizontal: 4),
              decoration: BoxDecoration(
                color: badgeColor,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: Theme.of(context).scaffoldBackgroundColor,
                  width: 2,
                ),
              ),
              child: Text(
                badge ?? '',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
            backgroundColor: Colors.transparent,
            padding: EdgeInsets.zero,
            child: Icon(active ? selectedIcon : icon, size: 22),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              fontWeight: active ? FontWeight.w900 : FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}
