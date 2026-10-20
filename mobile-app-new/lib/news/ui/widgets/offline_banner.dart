import 'package:flutter/material.dart';
import 'package:mobile_app_new/fcc_theme.dart';

class OfflineBanner extends StatelessWidget {
  const OfflineBanner({super.key});

  @override
  Widget build(BuildContext context) {
    final dark = Theme.of(context).brightness == Brightness.dark;
    final foreground = FccDesignColors.of(context).success;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: foreground.withValues(alpha: dark ? .15 : .1),
        border: Border.all(color: foreground.withValues(alpha: .25)),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Icon(Icons.download_rounded, size: 20, color: foreground),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              'Saved articles can be read offline',
              style: TextStyle(color: foreground, fontWeight: FontWeight.w600),
            ),
          ),
        ],
      ),
    );
  }
}
