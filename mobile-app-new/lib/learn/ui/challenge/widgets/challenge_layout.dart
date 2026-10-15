import 'package:flutter/material.dart';

AppBar challengeAppBar(
  BuildContext context, {
  required String title,
  required String subtitle,
  List<Widget>? actions,
  Widget? leading,
}) => AppBar(
  toolbarHeight:
      28 +
      MediaQuery.textScalerOf(
        context,
      ).scale(MediaQuery.sizeOf(context).height < 500 ? 30 : 52),
  leading: leading,
  title: Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        title,
        maxLines: MediaQuery.sizeOf(context).height < 500 ? 1 : 2,
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
  const ChallengeFooter({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(16),
  });
  final Widget child;
  final EdgeInsets padding;
  @override
  Widget build(BuildContext context) => Padding(
    padding: EdgeInsets.only(bottom: MediaQuery.viewInsetsOf(context).bottom),
    child: Material(
      color: Theme.of(context).scaffoldBackgroundColor,
      child: Container(
        decoration: BoxDecoration(
          border: Border(
            top: BorderSide(
              color: Theme.of(context).colorScheme.outlineVariant,
            ),
          ),
        ),
        child: SafeArea(
          top: false,
          child: Padding(padding: padding, child: child),
        ),
      ),
    ),
  );
}

class QuestionProgress extends StatelessWidget {
  const QuestionProgress({
    super.key,
    required this.total,
    required this.current,
    required this.answered,
    this.height = 4,
    this.spacing = 4,
    this.currentColor,
    this.answeredColor,
  });
  final int total;
  final int current;
  final List<bool> answered;
  final double height;
  final double spacing;
  final Color? currentColor;
  final Color? answeredColor;
  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return Semantics(
      label: 'Question ${current + 1} of $total',
      child: Row(
        children: [
          for (var i = 0; i < total; i++) ...[
            if (i > 0) SizedBox(width: spacing),
            Expanded(
              child: Container(
                height: height,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(height / 2),
                  color: i == current
                      ? currentColor ?? colors.primary
                      : answered[i]
                      ? answeredColor ?? colors.primary.withValues(alpha: .45)
                      : colors.outlineVariant,
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
