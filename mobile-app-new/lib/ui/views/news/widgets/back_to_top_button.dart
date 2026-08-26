import 'package:flutter/material.dart';
import 'package:mobile_app_new/fcc_theme.dart';

class BackToTopButton extends StatelessWidget {
  const BackToTopButton({super.key, required this.onPressed});

  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Padding(
      // Lifts the button clear of the bottom action buttons.
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 64),
      child: FloatingActionButton(
        onPressed: onPressed,
        shape: RoundedRectangleBorder(
          side: const BorderSide(width: 1, color: Colors.white),
          borderRadius: BorderRadius.circular(100),
        ),
        backgroundColor: FccColors.gray80,
        child: const Icon(
          Icons.keyboard_arrow_up,
          size: 40,
          color: Colors.white,
        ),
      ),
    );
  }
}
