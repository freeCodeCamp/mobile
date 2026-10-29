import 'package:flutter/material.dart';
import 'package:freecodecamp/fcc_theme.dart';

Future<bool> showQuizLeaveDialog(
  BuildContext context, {
  required int answered,
  required int total,
}) async =>
    await showDialog<bool>(
      context: context,
      builder: (context) {
        final theme = Theme.of(context);
        final colors = theme.colorScheme;
        final dark = theme.brightness == Brightness.dark;
        return Dialog(
          insetPadding: const EdgeInsets.all(24),
          backgroundColor: colors.surface,
          surfaceTintColor: Colors.transparent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 342),
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Center(
                    child: Container(
                      width: 56,
                      height: 56,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Color(dark ? 0xFF4D401A : 0xFFFFF1B8),
                      ),
                      child: Icon(
                        Icons.warning_amber_rounded,
                        size: 30,
                        color: Color(dark ? 0xFFFFC83D : 0xFF946500),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Leave the quiz?',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    "You've answered $answered of $total questions. If you leave now, your answers won't be saved.",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 15,
                      height: 1.45,
                      color: colors.onSurfaceVariant,
                    ),
                  ),
                  const SizedBox(height: 16),
                  FilledButton(
                    autofocus: true,
                    style: FilledButton.styleFrom(
                      minimumSize: const Size(double.infinity, 50),
                      padding: const EdgeInsets.all(12),
                      textStyle: const TextStyle(
                        fontFamily: 'Lato',
                        fontSize: 17,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    onPressed: () => Navigator.pop(context, false),
                    child: const Text(
                      'Keep going',
                      textAlign: TextAlign.center,
                    ),
                  ),
                  const SizedBox(height: 12),
                  OutlinedButton(
                    style: FccTheme.dangerOutlineStyle(context).copyWith(
                      minimumSize: const WidgetStatePropertyAll(
                        Size(double.infinity, 50),
                      ),
                      padding: const WidgetStatePropertyAll(EdgeInsets.all(12)),
                    ),
                    onPressed: () => Navigator.pop(context, true),
                    child: const Text(
                      'Leave quiz',
                      textAlign: TextAlign.center,
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    ) ??
    false;
