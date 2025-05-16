import 'package:flutter/material.dart';
import 'package:freecodecamp/enums/alert_type.dart';

class CustomAlert extends StatelessWidget {
  const CustomAlert({
    super.key,
    required this.text,
    required this.alertType,
  });

  final String text;
  final Alert alertType;

  @override
  Widget build(BuildContext context) {
    Size screen = MediaQuery.of(context).size;

    AlertColor alert = returnColor(alertType);

    return Container(
      padding: const EdgeInsets.all(8),
      margin: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: alert.backgroundColor,
        border: Border.all(
          width: 2,
          color: alert.textColor,
        ),
        borderRadius: const BorderRadius.all(
          Radius.circular(5),
        ),
      ),
      constraints: const BoxConstraints(minHeight: 50),
      width: screen.width,
      child: Text(
        text,
        style: TextStyle(
          color: alert.textColor,
          fontWeight: FontWeight.bold,
          height: 1.2,
        ),
      ),
    );
  }
}
