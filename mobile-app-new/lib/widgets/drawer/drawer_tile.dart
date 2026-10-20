import 'package:flutter/material.dart';
import 'package:mobile_app_new/fcc_theme.dart';

class DrawerTile extends StatelessWidget {
  const DrawerTile({
    super.key,
    this.textColor,
    required this.component,
    required this.route,
    this.icon,
    this.selected = false,
  });

  final String component;
  final IconData? icon;
  final VoidCallback route;
  final Color? textColor;
  final bool selected;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final foreground =
        textColor ??
        (selected
            ? FccDesignColors.of(context).accentText
            : colors.onSurfaceVariant);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 2),
      child: ListTile(
        selected: selected,
        selectedTileColor: colors.primaryContainer,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        leading: Icon(icon ?? Icons.school_outlined, color: foreground),
        title: Text(
          component,
          style: TextStyle(
            fontSize: 15,
            fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
            color: foreground,
          ),
        ),
        onTap: route,
      ),
    );
  }
}
