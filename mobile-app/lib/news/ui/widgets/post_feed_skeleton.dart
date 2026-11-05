import 'package:flutter/material.dart';

class PostFeedSkeleton extends StatelessWidget {
  const PostFeedSkeleton({super.key, this.header, this.featured = false});
  final Widget? header;
  final bool featured;

  @override
  Widget build(BuildContext context) => ListView(
    children: [
      ?header,
      ExcludeSemantics(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              if (featured) ...[
                const AspectRatio(aspectRatio: 16 / 9, child: _Placeholder()),
                const SizedBox(height: 14),
                const _Placeholder(height: 24),
                const SizedBox(height: 8),
                const FractionallySizedBox(
                  widthFactor: .7,
                  alignment: Alignment.centerLeft,
                  child: _Placeholder(height: 24),
                ),
                const SizedBox(height: 12),
                const FractionallySizedBox(
                  widthFactor: .6,
                  alignment: Alignment.centerLeft,
                  child: _Placeholder(height: 18),
                ),
              ],
              for (var row = 0; row < 3; row++) ...[
                const SizedBox(height: 24),
                const Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(width: 104, height: 70, child: _Placeholder()),
                    SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        children: [
                          _Placeholder(height: 18),
                          SizedBox(height: 8),
                          _Placeholder(height: 18),
                          SizedBox(height: 8),
                          _Placeholder(height: 14),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ],
          ),
        ),
      ),
    ],
  );
}

class _Placeholder extends StatelessWidget {
  const _Placeholder({this.height});
  final double? height;

  @override
  Widget build(BuildContext context) => Container(
    height: height,
    decoration: BoxDecoration(
      color: Theme.of(context).colorScheme.surfaceContainer,
      borderRadius: BorderRadius.circular(8),
    ),
  );
}
