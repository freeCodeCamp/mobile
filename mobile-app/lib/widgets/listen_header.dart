import 'package:flutter/material.dart';
import 'package:freecodecamp/widgets/app_page_title.dart';
import 'package:freecodecamp/widgets/listen_tabs.dart';

class ListenHeader extends StatelessWidget {
  const ListenHeader({super.key, required this.isRadio});

  final bool isRadio;

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.fromLTRB(16, 24, 16, 0),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (isRadio)
          DefaultTextStyle.merge(
            style: const TextStyle(color: Colors.white),
            child: const AppPageTitle('Listen'),
          )
        else
          const AppPageTitle('Listen'),
        const SizedBox(height: 32),
        ListenTabs(isRadio: isRadio),
      ],
    ),
  );
}
