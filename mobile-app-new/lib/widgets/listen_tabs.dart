import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:mobile_app_new/routing/code_radio.dart';
import 'package:mobile_app_new/routing/podcasts.dart';

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
                  style: TextButton.styleFrom(
                    foregroundColor: colors.onSurface,
                    backgroundColor: isRadio == radio
                        ? colors.surfaceContainerLow
                        : Colors.transparent,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
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
