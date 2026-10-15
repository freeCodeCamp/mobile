import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mobile_app_new/routing/auth.dart';
import 'package:mobile_app_new/routing/learn.dart';
import 'package:mobile_app_new/routing/news.dart';
import 'package:mobile_app_new/routing/podcasts.dart';
import 'package:mobile_app_new/services/audio_service.dart';
import 'package:mobile_app_new/utils/custom_tab.dart';
import 'package:mobile_app_new/widgets/mini_player.dart';

enum AppDestination { learn, tutorials, donate, listen, profile }

class AppBottomNavigation extends StatelessWidget {
  const AppBottomNavigation({super.key, required this.selected});
  final AppDestination selected;

  @override
  Widget build(BuildContext context) => DecoratedBox(
    decoration: BoxDecoration(
      border: Border(
        top: BorderSide(color: Theme.of(context).colorScheme.outlineVariant),
      ),
    ),
    child: NavigationBar(
      selectedIndex: selected.index,
      height: 72 + (MediaQuery.textScalerOf(context).scale(12) - 12),
      onDestinationSelected: (index) async {
        switch (AppDestination.values[index]) {
          case AppDestination.learn:
            const LearnLandingRoute().go(context);
          case AppDestination.tutorials:
            const NewsFeedRoute().go(context);
          case AppDestination.donate:
            try {
              await openInCustomTab('https://www.freecodecamp.org/donate/');
            } catch (_) {
              if (context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text(
                      'Could not open donations. Please try again.',
                    ),
                  ),
                );
              }
            }
          case AppDestination.listen:
            const PodcastListRoute().go(context);
          case AppDestination.profile:
            const ProfileRoute().go(context);
        }
      },
      destinations: const [
        NavigationDestination(
          icon: Icon(Icons.school_outlined),
          label: 'Courses',
        ),
        NavigationDestination(
          icon: Icon(Icons.article_outlined),
          label: 'Articles',
        ),
        NavigationDestination(
          icon: Icon(Icons.favorite_border),
          label: 'Donate',
          tooltip: 'Donate on freecodecamp.org',
        ),
        NavigationDestination(
          icon: Icon(Icons.headphones_outlined),
          label: 'Listen',
        ),
        NavigationDestination(
          icon: Icon(Icons.person_outline),
          label: 'Profile',
        ),
      ],
    ),
  );
}

/// Keeps loaded audio accessible while browsing. A full radio player suppresses
/// only its own mini player, so a podcast remains controllable before switching.
class AppNavigationFooter extends ConsumerWidget {
  const AppNavigationFooter({
    super.key,
    required this.selected,
    this.hideRadioPlayer = false,
  });
  final AppDestination selected;
  final bool hideRadioPlayer;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final handler = ref.watch(audioHandlerProvider);
    return StreamBuilder(
      stream: handler.playbackState,
      initialData: handler.playbackState.value,
      builder: (context, _) => Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (!hideRadioPlayer || handler.codeRadioSongId == null)
            const MiniPlayer(),
          AppBottomNavigation(selected: selected),
        ],
      ),
    );
  }
}
