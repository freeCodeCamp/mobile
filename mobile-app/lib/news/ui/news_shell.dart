import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:freecodecamp/fcc_theme.dart';
import 'package:freecodecamp/routing/news.dart';
import 'package:freecodecamp/widgets/app_bottom_navigation.dart';
import 'package:freecodecamp/widgets/app_page_title.dart';
import 'package:go_router/go_router.dart';

class NewsShell extends StatelessWidget {
  const NewsShell({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    final location = GoRouterState.of(context).uri.path;
    final isSaved = location == newsBookmarksPath;
    final isSearch = location == newsSearchPath;
    final scaler = MediaQuery.textScalerOf(context);
    const bookmarkStyle = TextStyle(
      fontFamily: 'Lato',
      fontSize: 14,
      height: 1.3,
      fontWeight: FontWeight.w700,
      letterSpacing: 0,
    );
    double textWidth(String text, TextStyle style) {
      final painter = TextPainter(
        text: TextSpan(text: text, style: style),
        textDirection: Directionality.of(context),
        textScaler: scaler,
      )..layout();
      final width = painter.width;
      painter.dispose();
      return width;
    }

    final bookmarkHeight = math.max(44.0, scaler.scale(14) * 1.3 + 20);
    final stackBookmarks =
        textWidth(
              'Articles',
              const TextStyle(
                fontFamily: 'Lato',
                fontSize: 30,
                fontWeight: FontWeight.w900,
              ),
            ) +
            textWidth('View bookmarks', bookmarkStyle) +
            108 >
        MediaQuery.sizeOf(context).width -
            MediaQuery.paddingOf(context).horizontal;
    final viewBookmarks = OutlinedButton.icon(
      onPressed: () => context.go(newsBookmarksPath),
      icon: const Icon(Icons.bookmark_border_rounded, size: 20),
      label: const Text('View bookmarks'),
      style: FccTheme.compactOutlineStyle(context).copyWith(
        minimumSize: WidgetStatePropertyAll(Size(44, bookmarkHeight)),
        padding: const WidgetStatePropertyAll(
          EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        ),
        textStyle: const WidgetStatePropertyAll(bookmarkStyle),
      ),
    );

    final scaffold = Scaffold(
      appBar: isSearch
          ? null
          : AppBar(
              automaticallyImplyLeading: false,
              leading: isSaved
                  ? BackButton(onPressed: () => context.go(newsFeedPath))
                  : null,
              title: isSaved
                  ? const Text('Saved articles')
                  : const AppPageTitle('Articles'),
              toolbarHeight: isSaved ? 64 : AppPageTitle.toolbarHeight(context),
              bottom: !isSaved && stackBookmarks
                  ? PreferredSize(
                      preferredSize: Size.fromHeight(bookmarkHeight + 12),
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(20, 0, 20, 12),
                        child: Align(
                          alignment: Alignment.centerRight,
                          child: viewBookmarks,
                        ),
                      ),
                    )
                  : null,
              actions: isSaved || stackBookmarks
                  ? null
                  : [
                      Padding(
                        padding: const EdgeInsets.only(right: 20),
                        child: viewBookmarks,
                      ),
                    ],
            ),
      body: SafeArea(top: isSearch, bottom: false, child: child),
      bottomNavigationBar: const AppNavigationFooter(
        selected: AppDestination.tutorials,
      ),
    );

    // Saved and Search are reached with context.go, so system back has nothing to pop.
    return PopScope(
      canPop: !isSaved && !isSearch,
      onPopInvokedWithResult: (didPop, _) {
        if (!didPop) {
          context.go(newsFeedPath);
        }
      },
      child: scaffold,
    );
  }
}
