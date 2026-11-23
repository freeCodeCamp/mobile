import 'package:flutter/material.dart';
import 'package:freecodecamp/routing/podcasts.dart';

class DownloadsEmptyState extends StatelessWidget {
  const DownloadsEmptyState({super.key});

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.symmetric(vertical: 48, horizontal: 20),
    child: Column(
      children: [
        Icon(
          Icons.download_rounded,
          size: 44,
          color: Theme.of(context).colorScheme.primary,
        ),
        const SizedBox(height: 14),
        const Text(
          'No downloads yet',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.w900),
        ),
        const SizedBox(height: 8),
        Text(
          'Tap the download button on any episode to listen without internet.',
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Theme.of(context).colorScheme.onSurfaceVariant,
          ),
        ),
        const SizedBox(height: 20),
        FilledButton(
          onPressed: () => const PodcastListRoute().go(context),
          child: const Text('Browse podcasts'),
        ),
      ],
    ),
  );
}
