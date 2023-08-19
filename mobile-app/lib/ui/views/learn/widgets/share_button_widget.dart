import 'package:flutter/material.dart';

class ShareButton extends StatefulWidget {
  final Function() onPressed;
  final IconData icon;

  const ShareButton({super.key, required this.onPressed, required this.icon});

  @override
  State<ShareButton> createState() => _ShareButtonState();
}

class _ShareButtonState extends State<ShareButton> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(4),
      child: IconButton(
        icon: Icon(widget.icon),
        color: Colors.white,
        onPressed: widget.onPressed,
      ),
    );
  }
}
