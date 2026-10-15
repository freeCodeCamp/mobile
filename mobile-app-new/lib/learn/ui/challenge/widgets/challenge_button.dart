import 'package:flutter/material.dart';

class ChallengeButton extends StatelessWidget {
  const ChallengeButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.loading = false,
    this.secondary = false,
  });
  final String label;
  final VoidCallback? onPressed;
  final bool loading;
  final bool secondary;
  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return FilledButton(
      style: FilledButton.styleFrom(
        minimumSize: const Size(double.infinity, 48),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        backgroundColor: secondary ? colors.surfaceContainer : colors.secondary,
        foregroundColor: secondary ? colors.onSurface : colors.onSecondary,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
      onPressed: loading ? null : onPressed,
      child: loading
          ? const SizedBox.square(
              dimension: 22,
              child: CircularProgressIndicator(strokeWidth: 2),
            )
          : Text(label, textAlign: TextAlign.center),
    );
  }
}
