import 'package:flutter/material.dart';

class FloatingNavigationButtons extends StatelessWidget {
  final VoidCallback? onPrevious;
  final VoidCallback? onNext;
  final bool hasPrevious;
  final bool hasNext;
  final bool isAnimating;

  const FloatingNavigationButtons({
    super.key,
    this.onPrevious,
    this.onNext,
    required this.hasPrevious,
    required this.hasNext,
    this.isAnimating = false,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        FloatingActionButton(
          heroTag: 'previous',
          onPressed: (hasPrevious && !isAnimating) ? onPrevious : null,
          shape: RoundedRectangleBorder(
            side: const BorderSide(
              width: 1,
              color: Colors.white,
            ),
            borderRadius: BorderRadius.circular(100),
          ),
          backgroundColor: (hasPrevious && !isAnimating)
              ? const Color.fromRGBO(0x2A, 0x2A, 0x40, 1)
              : const Color.fromRGBO(0x2A, 0x2A, 0x40, 0.5),
          child: Icon(
            Icons.keyboard_arrow_up,
            size: 30,
            color: (hasPrevious && !isAnimating) ? Colors.white : Colors.grey,
          ),
        ),
        const SizedBox(height: 12),
        FloatingActionButton(
          heroTag: 'next',
          onPressed: (hasNext && !isAnimating) ? onNext : null,
          shape: RoundedRectangleBorder(
            side: const BorderSide(
              width: 1,
              color: Colors.white,
            ),
            borderRadius: BorderRadius.circular(100),
          ),
          backgroundColor: (hasNext && !isAnimating)
              ? const Color.fromRGBO(0x2A, 0x2A, 0x40, 1)
              : const Color.fromRGBO(0x2A, 0x2A, 0x40, 0.5),
          child: Icon(
            Icons.keyboard_arrow_down,
            size: 30,
            color: (hasNext && !isAnimating) ? Colors.white : Colors.grey,
          ),
        ),
      ],
    );
  }
}
