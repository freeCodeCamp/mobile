import 'package:flutter/material.dart';
import 'package:mobile_app_new/fcc_theme.dart';
import 'package:mobile_app_new/widgets/html_handler/html_handler.dart';

class AssignmentTile extends StatelessWidget {
  const AssignmentTile({
    super.key,
    required this.label,
    required this.value,
    required this.onToggle,
  });

  final String label;
  final bool value;
  final VoidCallback onToggle;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Material(
        type: MaterialType.transparency,
        child: CheckboxListTile(
          value: value,
          onChanged: (_) => onToggle(),
          controlAffinity: ListTileControlAffinity.leading,
          activeColor: const Color(0xDEFFFFFF),
          checkColor: FccColors.gray90,
          title: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: HTMLParser(
              context: context,
            ).parse(label, isSelectable: false),
          ),
        ),
      ),
    );
  }
}
