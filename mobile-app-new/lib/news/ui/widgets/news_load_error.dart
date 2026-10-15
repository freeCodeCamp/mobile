import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mobile_app_new/routing/news.dart';
import 'package:url_launcher/url_launcher.dart';

/// Tutorials saved on this device remain reachable when the feed is unavailable.
class NewsLoadError extends StatelessWidget {
  const NewsLoadError({super.key, required this.onRetry});

  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) => LayoutBuilder(
    builder: (context, constraints) => SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: ConstrainedBox(
        constraints: BoxConstraints(
          minHeight: (constraints.maxHeight - 48).clamp(0, double.infinity),
        ),
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'There was an error loading tutorials',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.w800),
              ),
              const SizedBox(height: 12),
              Text(
                'Check your connection and try again. Your saved tutorials still work offline.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                  height: 1.5,
                ),
              ),
              const SizedBox(height: 24),
              FilledButton(onPressed: onRetry, child: const Text('Try again')),
              const SizedBox(height: 12),
              Wrap(
                alignment: WrapAlignment.center,
                spacing: 12,
                children: [
                  TextButton(
                    onPressed: () => context.go(newsBookmarksPath),
                    child: const Text('Saved tutorials'),
                  ),
                  TextButton(
                    onPressed: () async {
                      try {
                        final opened = await launchUrl(
                          Uri.parse('https://www.freecodecamp.org/news/'),
                          mode: LaunchMode.externalApplication,
                        );
                        if (opened || !context.mounted) return;
                      } catch (_) {
                        if (!context.mounted) return;
                      }
                      if (context.mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text(
                              'Unable to open tutorials in your browser.',
                            ),
                          ),
                        );
                      }
                    },
                    child: const Text('Read tutorials online'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    ),
  );
}
