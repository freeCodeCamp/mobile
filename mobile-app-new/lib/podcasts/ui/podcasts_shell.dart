import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mobile_app_new/routing/podcasts.dart';
import 'package:mobile_app_new/widgets/app_bottom_navigation.dart';
import 'package:mobile_app_new/widgets/listen_tabs.dart';
import 'package:mobile_app_new/widgets/mini_player.dart';

class PodcastsShell extends StatelessWidget {
  const PodcastsShell({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final downloaded =
        GoRouterState.of(context).uri.path == podcastDownloadsPath;
    return Scaffold(
      body: SafeArea(
        bottom: false,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Padding(
              padding: EdgeInsets.fromLTRB(18, 24, 18, 18),
              child: Text(
                'Listen',
                style: TextStyle(fontSize: 34, fontWeight: FontWeight.w700),
              ),
            ),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 18),
              child: ListenTabs(isRadio: false),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(18, 16, 18, 20),
              child: Wrap(
                spacing: 10,
                children: [
                  ChoiceChip(
                    label: const Text('All'),
                    selected: !downloaded,
                    showCheckmark: false,
                    selectedColor: colors.primary,
                    labelStyle: TextStyle(
                      color: !downloaded ? colors.onPrimary : colors.onSurface,
                    ),
                    onSelected: (_) => context.go(podcastListPath),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 6,
                      vertical: 12,
                    ),
                  ),
                  ChoiceChip(
                    label: const Text('Downloaded'),
                    avatar: Icon(
                      Icons.download_rounded,
                      size: 18,
                      color: downloaded ? colors.onPrimary : colors.onSurface,
                    ),
                    selected: downloaded,
                    showCheckmark: false,
                    selectedColor: colors.primary,
                    labelStyle: TextStyle(
                      color: downloaded ? colors.onPrimary : colors.onSurface,
                    ),
                    onSelected: (_) => context.go(podcastDownloadsPath),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 12,
                    ),
                  ),
                ],
              ),
            ),
            Expanded(child: child),
          ],
        ),
      ),
      bottomNavigationBar: const Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          MiniPlayer(),
          AppBottomNavigation(selected: AppDestination.listen),
        ],
      ),
    );
  }
}
