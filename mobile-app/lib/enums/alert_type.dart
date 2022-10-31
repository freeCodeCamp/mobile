import 'package:flutter/material.dart';

enum Alert {
  warning,
  danger,
  success,
}

class AlertColor {
  const AlertColor({
    required this.backgroundColor,
    required this.textColor,
  });

  final Color backgroundColor;
  final Color textColor;
}

// This returns the colors for the different types of alerts

AlertColor returnColor(Alert alert) {
  switch (alert) {
    case Alert.warning:
      return AlertColor(
        backgroundColor: const Color.fromRGBO(0xff, 0xf3, 0xcd, 1),
        textColor: Colors.yellow.shade900,
      );
    case Alert.danger:
      return AlertColor(
        backgroundColor: const Color.fromRGBO(0xf8, 0xd7, 0xda, 1),
        textColor: Colors.red.shade900,
      );
    case Alert.success:
      return AlertColor(
        backgroundColor: const Color.fromRGBO(0xd4, 0xed, 0xda, 1),
        textColor: Colors.green.shade900,
      );
  }
}
