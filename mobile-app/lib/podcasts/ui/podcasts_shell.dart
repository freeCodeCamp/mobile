import 'package:flutter/material.dart';
import 'package:freecodecamp/routing/podcasts.dart';
import 'package:freecodecamp/widgets/app_bottom_navigation.dart';
import 'package:freecodecamp/widgets/chip_surface.dart';
import 'package:freecodecamp/widgets/listen_header.dart';
import 'package:go_router/go_router.dart';

class PodcastsShell extends StatelessWidget {
  const PodcastsShell({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    final downloaded =
        GoRouterState.of(context).uri.path == podcastDownloadsPath;
    return Scaffold(
      body: SafeArea(
        bottom: false,
        child: NestedScrollView(
          headerSliverBuilder: (context, innerBoxIsScrolled) => [
            SliverToBoxAdapter(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const ListenHeader(isRadio: false),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 16, 16, 20),
                    child: Wrap(
                      spacing: 10,
                      children: [
                        ChipSurface(
                          child: ChoiceChip(
                            label: const Text('All'),
                            selected: !downloaded,
                            onSelected: (_) => context.go(podcastListPath),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 6,
                              vertical: 12,
                            ),
                          ),
                        ),
                        ChipSurface(
                          child: ChoiceChip(
                            label: const Text('Downloaded'),
                            avatar: const Icon(
                              Icons.download_rounded,
                              size: 18,
                            ),
                            selected: downloaded,
                            onSelected: (_) => context.go(podcastDownloadsPath),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 12,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
          body: child,
        ),
      ),
      bottomNavigationBar: const AppNavigationFooter(
        selected: AppDestination.listen,
      ),
    );
  }
}
