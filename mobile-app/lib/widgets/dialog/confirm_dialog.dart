import 'package:flutter/material.dart';
import 'package:freecodecamp/fcc_theme.dart';

// Resolves to true only when the confirm button is tapped.
Future<bool> showConfirmDialog(
  BuildContext context, {
  required String title,
  required String description,
  required String confirmLabel,
  bool destructive = false,
}) async {
  final confirmed = await showDialog<bool>(
    context: context,
    builder: (context) {
      final colors = Theme.of(context).colorScheme;
      return AlertDialog(
        scrollable: true,
        backgroundColor: colors.surface,
        surfaceTintColor: Colors.transparent,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: BorderSide(color: colors.outlineVariant),
        ),
        title: Text(title),
        content: Text(description),
        actions: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              FilledButton(
                style:
                    (destructive
                            ? FccTheme.dangerStyle(context)
                            : const ButtonStyle())
                        .copyWith(
                          minimumSize: const WidgetStatePropertyAll(
                            Size.fromHeight(50),
                          ),
                          textStyle: const WidgetStatePropertyAll(
                            TextStyle(
                              fontFamily: 'Lato',
                              fontSize: 17,
                              fontWeight: FontWeight.w900,
                            ),
                          ),
                        ),
                onPressed: () => Navigator.pop(context, true),
                child: Text(confirmLabel),
              ),
              const SizedBox(height: 12),
              OutlinedButton(
                style: OutlinedButton.styleFrom(
                  minimumSize: const Size.fromHeight(50),
                  textStyle: const TextStyle(
                    fontFamily: 'Lato',
                    fontSize: 17,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                onPressed: () => Navigator.pop(context, false),
                child: const Text('Cancel'),
              ),
            ],
          ),
        ],
      );
    },
  );
  return confirmed ?? false;
}
