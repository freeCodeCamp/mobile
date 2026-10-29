import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:freecodecamp/fcc_theme.dart';
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
      destinations: [
        const NavigationDestination(
          icon: Icon(Icons.school_outlined),
          selectedIcon: Icon(Icons.school),
          label: 'Courses',
        ),
        const NavigationDestination(
          icon: Icon(Icons.article_outlined),
          selectedIcon: Icon(Icons.article),
          label: 'Articles',
        ),
        NavigationBarTheme(
          data: NavigationBarTheme.of(context).copyWith(
            labelTextStyle: WidgetStatePropertyAll(
              TextStyle(
                fontFamily: 'Lato',
                fontSize: 12,
                fontWeight: FontWeight.w700,
                color: Theme.of(context).colorScheme.tertiary,
              ),
            ),
          ),
          child: NavigationDestination(
            icon: Transform.translate(
              offset: const Offset(0, -10),
              child: Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: FccDesignColors.of(context).donateContainer,
                ),
                child: Icon(
                  Icons.favorite,
                  color: Theme.of(context).colorScheme.tertiary,
                ),
              ),
            ),
            label: 'Donate',
            tooltip: 'Donate on freecodecamp.org',
          ),
        ),
        const NavigationDestination(
          icon: Icon(Icons.headphones_outlined),
          selectedIcon: Icon(Icons.headphones),
          label: 'Listen',
        ),
        const NavigationDestination(
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
