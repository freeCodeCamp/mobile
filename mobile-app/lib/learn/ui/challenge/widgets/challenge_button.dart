import 'package:flutter/material.dart';

class ChallengeButton extends StatelessWidget {
  const ChallengeButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.loading = false,
    this.secondary = false,
    this.style,
    this.leadingIcon,
    this.trailingIcon,
  });
  final String label;
  final VoidCallback? onPressed;
  final bool loading;
  final bool secondary;
  final ButtonStyle? style;
  final IconData? leadingIcon;
  final IconData? trailingIcon;
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final defaults =
        FilledButton.styleFrom(
          minimumSize: const Size(double.infinity, 48),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        ).merge(
          secondary
              ? theme.outlinedButtonTheme.style
              : theme.filledButtonTheme.style,
        );
    return FilledButton(
      style: style?.merge(defaults) ?? defaults,
      onPressed: loading ? null : onPressed,
      child: loading
          ? const SizedBox.square(
              dimension: 22,
              child: CircularProgressIndicator(strokeWidth: 2),
            )
          : leadingIcon == null && trailingIcon == null
          ? Text(label, textAlign: TextAlign.center)
          : Row(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                if (leadingIcon != null) ...[
                  Icon(leadingIcon, size: 18),
                  const SizedBox(width: 8),
                ],
                Flexible(child: Text(label, textAlign: TextAlign.center)),
                if (trailingIcon != null) ...[
                  const SizedBox(width: 8),
                  Icon(trailingIcon, size: 18),
                ],
              ],
            ),
    );
  }
}
