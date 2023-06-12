import 'package:flutter_custom_tabs/flutter_custom_tabs.dart';
import 'package:freecodecamp/app/app.locator.dart';
import 'package:freecodecamp/enums/dialog_type.dart';
import 'package:freecodecamp/ui/widgets/setup_dialog_ui.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

class SettingsViewModel extends BaseViewModel {
  final DialogService _dialogService = locator<DialogService>();

  void init() {
    setupDialogUi();
  }

  void resetCache() async {
    DialogResponse? res = await _dialogService.showCustomDialog(
      barrierDismissible: true,
      variant: DialogType.buttonForm,
      title: 'Clear Cache',
      description:
          'Are you sure you want to clear the cache? - this resets all your progress and local data',
      mainButtonTitle: 'Clear',
    );

    if (res?.confirmed == true) {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.clear();
    }
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
