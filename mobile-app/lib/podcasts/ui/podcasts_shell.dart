import 'package:flutter/material.dart';
import 'package:freecodecamp/routing/podcasts.dart';
import 'package:freecodecamp/widgets/app_bottom_navigation.dart';
import 'package:freecodecamp/widgets/app_page_title.dart';
import 'package:freecodecamp/widgets/listen_tabs.dart';
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
                  const Padding(
                    padding: EdgeInsets.fromLTRB(18, 24, 18, 18),
                    child: AppPageTitle('Listen'),
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
                          onSelected: (_) => context.go(podcastListPath),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 6,
                            vertical: 12,
                          ),
                        ),
                        ChoiceChip(
                          label: const Text('Downloaded'),
                          avatar: const Icon(Icons.download_rounded, size: 18),
                          selected: downloaded,
                          onSelected: (_) => context.go(podcastDownloadsPath),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 12,
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
