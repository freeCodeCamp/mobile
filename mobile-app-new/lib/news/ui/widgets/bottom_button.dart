import 'package:flutter/material.dart';
import 'package:mobile_app_new/fcc_theme.dart';

class NewsBottomButton extends StatelessWidget {
  const NewsBottomButton({
    super.key,
    required this.label,
    required this.onPressed,
    required this.icon,
    required this.rightSided,
  });

  final VoidCallback onPressed;
  final String label;
  final bool rightSided;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: ElevatedButton.icon(
        icon: Icon(icon, color: Colors.white),
        onPressed: onPressed,
        label: FittedBox(
          fit: BoxFit.scaleDown,
          child: Text(label, maxLines: 1, softWrap: false),
        ),
        style: ElevatedButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(rightSided ? 0 : 10),
              topRight: Radius.circular(rightSided ? 10 : 0),
              bottomLeft: Radius.circular(rightSided ? 0 : 10),
              bottomRight: Radius.circular(rightSided ? 10 : 0),
            ),
          ),
          backgroundColor: FccColors.gray80,
        ),
      ),
    );
  }
}
