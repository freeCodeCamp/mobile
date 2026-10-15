import 'package:flutter/material.dart';
import 'package:mobile_app_new/learn/ui/challenge/widgets/parsed_html.dart';

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
  Widget build(BuildContext context) => Material(
    type: MaterialType.transparency,
    child: CheckboxListTile(
      contentPadding: EdgeInsets.zero,
      value: value,
      onChanged: (_) => onToggle(),
      controlAffinity: ListTileControlAffinity.leading,
      activeColor: Theme.of(context).colorScheme.primary,
      title: IgnorePointer(child: ParsedHtml(label, selectable: false)),
    ),
  );
}
