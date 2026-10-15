import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class SuperBlockButton extends StatelessWidget {
  const SuperBlockButton({
    super.key,
    required this.title,
    required this.onPressed,
    this.icon,
    this.svgAsset,
    this.isEnabled = true,
    this.subtitle,
    this.color,
  });
  final String title;
  final VoidCallback onPressed;
  final IconData? icon;
  final String? svgAsset;
  final bool isEnabled;
  final String? subtitle;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final accent = color ?? colors.primary;
    return InkWell(
      onTap: onPressed,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 16),
        child: Row(
          children: [
            Container(
              width: 38,
              height: 38,
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: accent.withValues(alpha: .12),
                borderRadius: BorderRadius.circular(12),
              ),
              child: svgAsset != null
                  ? SvgPicture.asset(
                      svgAsset!,
                      fit: BoxFit.contain,
                      colorFilter: ColorFilter.mode(accent, BlendMode.srcIn),
                    )
                  : Icon(
                      icon ?? Icons.school_outlined,
                      color: accent,
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
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      color: colors.onSurface,
                    ),
                  ),
                  if (subtitle != null || !isEnabled) ...[
                    const SizedBox(height: 2),
                    Text(
                      subtitle ?? 'Not available in the app',
                      style: TextStyle(
                        fontSize: 12,
                        color: colors.onSurfaceVariant,
                      ),
                    ),
                  ],
                ],
              ),
            ),
            const SizedBox(width: 8),
            Icon(
              isEnabled ? Icons.chevron_right : Icons.info_outline,
              size: 18,
              color: colors.onSurfaceVariant,
            ),
          ],
        ),
      ),
    );
  }
}
