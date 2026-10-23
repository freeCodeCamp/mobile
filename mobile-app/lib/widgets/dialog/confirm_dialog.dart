import 'package:flutter/material.dart';
import 'package:freecodecamp/fcc_theme.dart';

final _buttonStyle = ElevatedButton.styleFrom(
  backgroundColor: FccColors.gray75,
  foregroundColor: FccColors.gray00,
  side: const BorderSide(width: 2, color: FccColors.gray00),
  shape: const RoundedRectangleBorder(),
  minimumSize: const Size.fromHeight(50),
);

final _destructiveStyle = ElevatedButton.styleFrom(
  backgroundColor: Colors.red.shade100,
  foregroundColor: Colors.red.shade900,
  side: BorderSide(width: 2, color: Colors.red.shade900),
  shape: const RoundedRectangleBorder(),
  minimumSize: const Size.fromHeight(50),
);

// NOTE: Resolves to true only when the confirm button is tapped.
Future<bool> showConfirmDialog(
  BuildContext context, {
  required String title,
  required String description,
  required String confirmLabel,
  bool destructive = false,
}) async {
  final confirmed = await showDialog<bool>(
    context: context,
    builder: (context) => Dialog(
      backgroundColor: FccColors.gray90,
      shape: const RoundedRectangleBorder(),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Wrap(
          runSpacing: 20,
          children: [
            Text(
              title,
              style: const TextStyle(
                fontSize: 24,
                height: 1.5,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            Text(
              description,
              style: const TextStyle(
                fontSize: 16,
                height: 1.5,
                color: Colors.white,
              ),
            ),
            ElevatedButton(
              style: destructive ? _destructiveStyle : _buttonStyle,
              onPressed: () => Navigator.pop(context, true),
              child: Text(
                destructive ? confirmLabel.toUpperCase() : confirmLabel,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: destructive ? FontWeight.bold : null,
                ),
              ),
            ),
            ElevatedButton(
              style: _buttonStyle,
              onPressed: () => Navigator.pop(context, false),
              child: const Text(
                'Cancel',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16),
              ),
            ),
          ],
        ),
      ),
    ),
  );
  return confirmed ?? false;
}
