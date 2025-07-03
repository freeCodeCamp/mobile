import 'package:flutter/material.dart';
import 'package:freecodecamp/ui/theme/fcc_theme.dart';

class FloatingNavigationButtons extends StatelessWidget {
  final VoidCallback? onPrevious;
  final VoidCallback? onNext;
  final bool hasPrevious;
  final bool hasNext;

  const FloatingNavigationButtons({
    super.key,
    this.onPrevious,
    this.onNext,
    required this.hasPrevious,
    required this.hasNext,
  });

  @override
  Widget build(BuildContext context) {
    return Positioned(
      bottom: 16,
      right: 16,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Previous button
          FloatingActionButton(
            heroTag: "previous",
            onPressed: hasPrevious ? onPrevious : null,
            shape: RoundedRectangleBorder(
              side: const BorderSide(
                width: 1,
                color: Colors.white,
              ),
              borderRadius: BorderRadius.circular(100),
            ),
            backgroundColor: hasPrevious 
                ? const Color.fromRGBO(0x2A, 0x2A, 0x40, 1)
                : const Color.fromRGBO(0x2A, 0x2A, 0x40, 0.5),
            child: Icon(
              Icons.keyboard_arrow_up,
              size: 30,
              color: hasPrevious ? Colors.white : Colors.grey,
            ),
          ),
          const SizedBox(height: 12),
          // Next button
          FloatingActionButton(
            heroTag: "next",
            onPressed: hasNext ? onNext : null,
            shape: RoundedRectangleBorder(
              side: const BorderSide(
                width: 1,
                color: Colors.white,
              ),
              borderRadius: BorderRadius.circular(100),
            ),
            backgroundColor: hasNext 
                ? const Color.fromRGBO(0x2A, 0x2A, 0x40, 1)
                : const Color.fromRGBO(0x2A, 0x2A, 0x40, 0.5),
            child: Icon(
              Icons.keyboard_arrow_down,
              size: 30,
              color: hasNext ? Colors.white : Colors.grey,
            ),
          ),
        ],
      ),
    );
  }
}