import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mobile_app_new/routing/news.dart';
import 'package:mobile_app_new/widgets/app_bottom_navigation.dart';
import 'package:mobile_app_new/widgets/app_page_title.dart';

class NewsShell extends StatelessWidget {
  const NewsShell({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    final location = GoRouterState.of(context).uri.path;
    final isSaved = location == newsBookmarksPath;
    final isSearch = location == newsSearchPath;
    final colors = Theme.of(context).colorScheme;
    final scaler = MediaQuery.textScalerOf(context);
    const bookmarkStyle = TextStyle(
      fontFamily: 'Lato',
      fontSize: 14,
      height: 1.3,
      fontWeight: FontWeight.w600,
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

    final bookmarkHeight = math.max(48.0, scaler.scale(14) * 1.3 + 24);
    final stackBookmarks =
        textWidth(
              'Articles',
              const TextStyle(
                fontFamily: 'Lato',
                fontSize: 32,
                fontWeight: FontWeight.w800,
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
      style: OutlinedButton.styleFrom(
        backgroundColor: colors.surface,
        foregroundColor: colors.onSurface,
        side: BorderSide(color: colors.outlineVariant),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        minimumSize: Size(48, bookmarkHeight),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
        textStyle: bookmarkStyle,
      ),
    );

    return Scaffold(
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
  }
}
