import 'package:flutter/material.dart';
import 'package:freecodecamp/fcc_theme.dart';

class ChallengeButton extends StatelessWidget {
  const ChallengeButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.loading = false,
  });

  final String label;
  final VoidCallback? onPressed;
  final bool loading;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          minimumSize: const Size(double.infinity, 50),
          backgroundColor: FccColors.gray75,
          side: const BorderSide(width: 2, color: FccColors.gray00),
          shape: const RoundedRectangleBorder(),
        ),
        onPressed: loading ? null : onPressed,
        child: loading
            ? const SizedBox.square(
                dimension: 24,
                child: CircularProgressIndicator(strokeWidth: 2),
              )
            : Text(label, style: const TextStyle(fontSize: 20)),
      ),
    );
  }
}
