import 'package:flutter/material.dart';

AppBar challengeAppBar(
  BuildContext context, {
  required String title,
  required String subtitle,
  List<Widget>? actions,
  Widget? leading,
}) => AppBar(
  toolbarHeight: 28 + MediaQuery.textScalerOf(context).scale(52),
  leading: leading,
  title: Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        title,
        maxLines: 2,
        overflow: TextOverflow.ellipsis,
        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w800),
      ),
      const SizedBox(height: 4),
      Text(
        subtitle,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: TextStyle(
          fontSize: 13,
          color: Theme.of(context).colorScheme.onSurfaceVariant,
        ),
      ),
    ],
  ),
  actions: actions,
);

class ChallengeFooter extends StatelessWidget {
  const ChallengeFooter({super.key, required this.child});
  final Widget child;
  @override
  Widget build(BuildContext context) => Container(
    decoration: BoxDecoration(
      color: Theme.of(context).scaffoldBackgroundColor,
      border: Border(
        top: BorderSide(color: Theme.of(context).colorScheme.outlineVariant),
      ),
    ),
    child: SafeArea(
      top: false,
      child: Padding(padding: const EdgeInsets.all(16), child: child),
    ),
  );
}

class QuestionProgress extends StatelessWidget {
  const QuestionProgress({
    super.key,
    required this.total,
    required this.current,
    required this.answered,
  });
  final int total;
  final int current;
  final List<bool> answered;
  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return Semantics(
      label: 'Question ${current + 1} of $total',
      child: Row(
        children: [
          for (var i = 0; i < total; i++)
            Expanded(
              child: Container(
                height: 4,
                margin: EdgeInsets.only(right: i == total - 1 ? 0 : 4),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(2),
                  color: i == current
                      ? colors.primary
                      : answered[i]
                      ? colors.primary.withValues(alpha: .45)
                      : colors.outlineVariant,
                ),
              ),
            ),
        ],
      ),
    );
  }
}
