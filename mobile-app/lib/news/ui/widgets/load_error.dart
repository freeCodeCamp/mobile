import 'package:flutter/material.dart';
import 'package:freecodecamp/routing/news.dart';
import 'package:freecodecamp/widgets/error_retry.dart';
import 'package:url_launcher/url_launcher.dart';

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
              ErrorRetry(
                message: 'There was an error loading articles',
                detail:
                    'Check your connection and try again. Your saved articles still work offline.',
                onRetry: onRetry,
                margin: EdgeInsets.zero,
              ),
              const SizedBox(height: 12),
              Wrap(
                alignment: WrapAlignment.center,
                spacing: 12,
                children: [
                  TextButton(
                    onPressed: () =>
                        const NewsBookmarksRoute().push<void>(context),
                    child: const Text('Saved articles'),
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
                              'Unable to open articles in your browser.',
                            ),
                          ),
                        );
                      }
                    },
                    child: const Text('Read articles online'),
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
