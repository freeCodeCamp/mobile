import 'package:flutter_custom_tabs/flutter_custom_tabs.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:stacked/stacked.dart';

class SettingsViewModel extends BaseViewModel {
  void resetCache() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  }

  void openPrivacyPolicy() {
    launch(
      'https://www.freecodecamp.org/news/privacy-policy/',
      customTabsOption: const CustomTabsOption(
        enableDefaultShare: true,
        enableUrlBarHiding: true,
        showPageTitle: true,
        extraCustomTabs: [
          'org.mozilla.firefox',
          'com.microsoft.emmx',
        ],
      ),
    );
  }
}
