import 'package:flutter/material.dart';
import 'package:freecodecamp/fcc_theme.dart';

class SuperBlockButton extends StatelessWidget {
  const SuperBlockButton({
    super.key,
    required this.title,
    required this.onPressed,
    this.icon,
    this.isEnabled = true,
    this.isExternal = false,
    this.subtitle,
  });
  final String title;
  final VoidCallback onPressed;
  final IconData? icon;
  final bool isEnabled;
  final bool isExternal;
  final String? subtitle;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return InkWell(
      onTap: onPressed,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
        child: Row(
          children: [
            Container(
              width: 44,
              height: 44,
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: colors.surfaceContainer,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                icon ?? Icons.desktop_windows_outlined,
                color: colors.onSurface,
                size: 22,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 16,
                      height: 1.25,
                      fontWeight: FontWeight.w700,
                      color: colors.onSurface,
                    ),
                  ),
                  if (subtitle != null || !isEnabled) ...[
                    const SizedBox(height: 2),
                    Text(
                      subtitle ?? 'Not available in the app',
                      style: TextStyle(
                        fontSize: 13,
                        color:
                            subtitle == 'Start here' ||
                                subtitle == 'In progress'
                            ? FccDesignColors.of(context).accentText
                            : colors.onSurfaceVariant,
                      ),
                    ),
                  ],
                ],
              ),
            ),
            const SizedBox(width: 8),
            Icon(
              isExternal
                  ? Icons.open_in_new
                  : isEnabled
                  ? Icons.chevron_right
                  : Icons.info_outline,
              size: 18,
              color: colors.onSurfaceVariant,
            ),
          ],
        ),
      ),
    );
  }
}
