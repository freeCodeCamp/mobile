import 'package:flutter/material.dart';

import 'package:flutter_custom_tabs/flutter_custom_tabs.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
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

  void resetCache(BuildContext context) async {
    DialogResponse? res = await _dialogService.showCustomDialog(
      barrierDismissible: true,
      variant: DialogType.buttonForm,
      title: AppLocalizations.of(context)!.settings_reset_cache,
      description:
          AppLocalizations.of(context)!.settings_reset_cache_description,
      mainButtonTitle:
          AppLocalizations.of(context)!.settings_reset_cache_confirm,
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
