import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:freecodecamp/routing/auth.dart';
import 'package:freecodecamp/routing/learn.dart';
import 'package:freecodecamp/routing/news.dart';
import 'package:freecodecamp/routing/podcasts.dart';
import 'package:freecodecamp/services/audio_service.dart';
import 'package:freecodecamp/utils/custom_tab.dart';
import 'package:freecodecamp/widgets/mini_player.dart';

enum AppDestination { learn, tutorials, donate, listen, account }

class AppBottomNavigation extends StatelessWidget {
  const AppBottomNavigation({
    super.key,
    required this.selected,
    this.beforeNavigate,
  });
  final AppDestination selected;
  final Future<bool> Function()? beforeNavigate;

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
        if (AppDestination.values[index] != AppDestination.donate &&
            beforeNavigate != null &&
            !await beforeNavigate!()) {
          return;
        }
        if (!context.mounted) return;
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
          case AppDestination.account:
            const AccountRoute().go(context);
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
          selectedIcon: Icon(Icons.person),
          label: 'Account',
        ),
      ],
    ),
  );
}

class AppNavigationFooter extends ConsumerWidget {
  const AppNavigationFooter({
    super.key,
    required this.selected,
    this.hideRadioPlayer = false,
    this.beforeNavigate,
  });
  final AppDestination selected;
  final bool hideRadioPlayer;
  final Future<bool> Function()? beforeNavigate;

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
            MiniPlayer(beforeNavigate: beforeNavigate),
          AppBottomNavigation(
            selected: selected,
            beforeNavigate: beforeNavigate,
          ),
        ],
      ),
    );
  }
}
