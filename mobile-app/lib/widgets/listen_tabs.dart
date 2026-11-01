import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:freecodecamp/routing/code_radio.dart';
import 'package:freecodecamp/routing/podcasts.dart';
import 'package:freecodecamp/widgets/segmented_tabs.dart';

class ListenTabs extends StatelessWidget {
  const ListenTabs({super.key, required this.isRadio});

  final bool isRadio;

  @override
  Widget build(BuildContext context) {
    // Match the existing app's platform availability for Code Radio.
    if (defaultTargetPlatform == TargetPlatform.iOS) {
      return const SizedBox.shrink();
    }
    return SegmentedTabs<bool>(
      selected: isRadio,
      tabs: const [
        (value: false, label: 'Podcasts', icon: null),
        (value: true, label: 'Code Radio', icon: null),
      ],
      onSelected: (radio) {
        if (radio) {
          const CodeRadioRoute().go(context);
        } else {
          const PodcastListRoute().go(context);
        }
      },
    );
  }
}
