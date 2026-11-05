import 'package:flutter/material.dart';
import 'package:freecodecamp/fcc_theme.dart';

class OfflineBanner extends StatelessWidget {
  const OfflineBanner({super.key});

  @override
  Widget build(BuildContext context) {
    final design = FccDesignColors.of(context);
    final foreground = design.success;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: design.successContainer,
        border: Border.all(color: design.successBorder),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Icon(Icons.download_rounded, size: 20, color: foreground),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              'Saved articles can be read offline',
              style: TextStyle(
                color: foreground,
                fontSize: 14,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
