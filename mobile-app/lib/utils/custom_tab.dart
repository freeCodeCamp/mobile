import 'package:flutter_custom_tabs/flutter_custom_tabs.dart';

Future<void> openInCustomTab(String url) {
  return launchUrl(
    Uri.parse(url),
    customTabsOptions: const CustomTabsOptions(
      shareState: CustomTabsShareState.on,
      urlBarHidingEnabled: true,
      showTitle: true,
      browser: CustomTabsBrowserConfiguration(
        fallbackCustomTabs: ['org.mozilla.firefox', 'com.microsoft.emmx'],
      ),
    ),
    safariVCOptions: const SafariViewControllerOptions(
      barCollapsingEnabled: true,
    ),
  );
}
