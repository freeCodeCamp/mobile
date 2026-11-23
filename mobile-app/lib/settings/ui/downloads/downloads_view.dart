import 'package:flutter/material.dart';
import 'package:freecodecamp/news/ui/widgets/news_downloads_tab.dart';
import 'package:freecodecamp/podcasts/ui/widgets/podcast_downloads_tab.dart';
import 'package:freecodecamp/routing/auth.dart';
import 'package:freecodecamp/widgets/app_bottom_navigation.dart';
import 'package:freecodecamp/widgets/segmented_tabs.dart';
import 'package:go_router/go_router.dart';

enum _DownloadsTab { podcasts, articles }

class DownloadsView extends StatefulWidget {
  const DownloadsView({super.key});

  @override
  State<DownloadsView> createState() => _DownloadsViewState();
}

class _DownloadsViewState extends State<DownloadsView> {
  _DownloadsTab _tab = _DownloadsTab.podcasts;

  void _back() {
    if (context.canPop()) {
      context.pop();
    } else {
      const AccountRoute().go(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, _) {
        if (!didPop) _back();
      },
      child: Scaffold(
        extendBody: true,
        appBar: AppBar(
          title: const Text('Downloads'),
          leading: IconButton(
            tooltip: 'Back',
            icon: const Icon(Icons.arrow_back_rounded),
            onPressed: _back,
          ),
        ),
        bottomNavigationBar: const AppNavigationFooter(
          selected: AppDestination.account,
        ),
        body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(18, 4, 18, 8),
              child: SegmentedTabs<_DownloadsTab>(
                selected: _tab,
                tabs: const [
                  (
                    value: _DownloadsTab.podcasts,
                    label: 'Podcasts',
                    icon: null,
                  ),
                  (
                    value: _DownloadsTab.articles,
                    label: 'Articles',
                    icon: null,
                  ),
                ],
                onSelected: (tab) => setState(() => _tab = tab),
              ),
            ),
            Expanded(
              child: switch (_tab) {
                _DownloadsTab.podcasts => const PodcastDownloadsTab(
                  key: ValueKey(_DownloadsTab.podcasts),
                ),
                _DownloadsTab.articles => const NewsDownloadsTab(
                  key: ValueKey(_DownloadsTab.articles),
                ),
              },
            ),
          ],
        ),
      ),
    );
  }
}
