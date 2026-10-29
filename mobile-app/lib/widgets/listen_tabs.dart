import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:freecodecamp/fcc_theme.dart';
import 'package:freecodecamp/routing/code_radio.dart';
import 'package:freecodecamp/routing/podcasts.dart';

class ListenTabs extends StatelessWidget {
  const ListenTabs({super.key, required this.isRadio});

  final bool isRadio;

  @override
  Widget build(BuildContext context) {
    // Match the existing app's platform availability for Code Radio.
    if (defaultTargetPlatform == TargetPlatform.iOS) {
      return const SizedBox.shrink();
    }
    final colors = Theme.of(context).colorScheme;
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: colors.surface,
        border: Border.all(color: colors.outlineVariant),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          for (final radio in [false, true])
            Expanded(
              child: Semantics(
                selected: isRadio == radio,
                child: TextButton(
                  style:
                      TextButton.styleFrom(
                        foregroundColor: isRadio == radio
                            ? colors.onSurface
                            : colors.onSurfaceVariant,
                        textStyle: TextStyle(
                          fontSize: 15,
                          fontWeight: isRadio == radio
                              ? FontWeight.w900
                              : FontWeight.w700,
                        ),
                        side: isRadio == radio
                            ? BorderSide(
                                color: FccDesignColors.of(context).accentText,
                                width: 1.5,
                              )
                            : BorderSide.none,
                        backgroundColor: isRadio == radio
                            ? colors.surfaceContainerLow
                            : Colors.transparent,
                      ).copyWith(
                        shape: FccTheme.focusShape(context, radius: 8),
                        backgroundColor: WidgetStateProperty.resolveWith(
                          (states) =>
                              isRadio == radio ||
                                  states.contains(WidgetState.pressed)
                              ? colors.primaryContainer
                              : Colors.transparent,
                        ),
                      ),
                  onPressed: isRadio == radio
                      ? () {}
                      : () {
                          if (radio) {
                            const CodeRadioRoute().go(context);
                          } else {
                            const PodcastListRoute().go(context);
                          }
                        },
                  child: Text(radio ? 'Code Radio' : 'Podcasts'),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
