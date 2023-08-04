import 'package:flutter/material.dart';

class BackToTopButton extends StatelessWidget {
  final VoidCallback onPressed;

  const BackToTopButton({Key? key, required this.onPressed}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.bottomRight,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 128),
        child: FloatingActionButton(
          onPressed: onPressed,
          shape: RoundedRectangleBorder(
            side: const BorderSide(
              width: 1,
              color: Colors.white,
            ),
            borderRadius: BorderRadius.circular(100),
          ),
          backgroundColor: const Color.fromRGBO(0x2A, 0x2A, 0x40, 1),
          child: const Icon(
            Icons.keyboard_arrow_up,
            size: 40,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}
