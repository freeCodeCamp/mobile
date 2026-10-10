import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mobile_app_new/routing/news.dart';
import 'package:mobile_app_new/widgets/app_bottom_navigation.dart';
import 'package:mobile_app_new/widgets/mini_player.dart';

class NewsShell extends StatelessWidget {
  const NewsShell({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    final location = GoRouterState.of(context).uri.path;
    final isSaved = location == newsBookmarksPath;
    final isSearch = location == newsSearchPath;
    final colors = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: isSearch
          ? null
          : AppBar(
              automaticallyImplyLeading: false,
              leading: isSaved
                  ? BackButton(onPressed: () => context.go(newsFeedPath))
                  : null,
              title: Text(
                isSaved ? 'Saved tutorials' : 'Tutorials',
                style: TextStyle(
                  fontSize: isSaved ? 20 : 32,
                  fontWeight: FontWeight.w800,
                ),
              ),
              toolbarHeight: isSaved ? 64 : 80,
              actions: isSaved
                  ? null
                  : [
                      Padding(
                        padding: const EdgeInsets.only(right: 20),
                        child: IconButton.outlined(
                          tooltip: 'Saved tutorials',
                          style: IconButton.styleFrom(
                            backgroundColor: colors.surface,
                            side: BorderSide(color: colors.outlineVariant),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            minimumSize: const Size(48, 48),
                          ),
                          icon: const Icon(Icons.bookmark_border_rounded),
                          onPressed: () => context.go(newsBookmarksPath),
                        ),
                      ),
                    ],
            ),
      body: SafeArea(top: isSearch, bottom: false, child: child),
      bottomNavigationBar: const Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          MiniPlayer(),
          AppBottomNavigation(selected: AppDestination.tutorials),
        ],
      ),
    );
  }
}
