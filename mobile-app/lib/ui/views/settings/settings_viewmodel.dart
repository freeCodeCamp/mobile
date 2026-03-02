import 'package:flutter/material.dart';
import 'package:flutter_custom_tabs/flutter_custom_tabs.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:freecodecamp/core/providers/service_providers.dart';
import 'package:freecodecamp/extensions/i18n_extension.dart';
import 'package:freecodecamp/service/developer_service.dart';
import 'package:freecodecamp/service/locale_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsState {
  const SettingsState({this.isDev = false});

  final bool isDev;

  SettingsState copyWith({bool? isDev}) {
    return SettingsState(isDev: isDev ?? this.isDev);
  }
}

class SettingsNotifier extends Notifier<SettingsState> {
  late LocaleService localeService;
  late DeveloperService developerService;

  @override
  SettingsState build() {
    localeService = ref.watch(localeServiceProvider);
    developerService = ref.watch(developerServiceProvider);
    return const SettingsState();
  }

  void init() async {
    final isDev = await developerService.developmentMode();
    state = state.copyWith(isDev: isDev);
  }

  void resetCache(BuildContext context) async {
    final confirmed = await showDialog<bool>(
      context: context,
      barrierDismissible: true,
      builder: (dialogContext) => AlertDialog(
        backgroundColor: const Color(0xFF2A2A40),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(0)),
        title: Text(context.t.settings_reset_cache),
        content: Text(context.t.settings_reset_cache_description),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(true),
            child: Text(context.t.settings_reset_cache_confirm),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.clear();
    }
  }

  void openPrivacyPolicy() {
    launchUrl(
      Uri.parse('https://www.freecodecamp.org/news/privacy-policy/'),
      customTabsOptions: const CustomTabsOptions(
        shareState: CustomTabsShareState.on,
        urlBarHidingEnabled: true,
        showTitle: true,
        browser: CustomTabsBrowserConfiguration(
          fallbackCustomTabs: [
            'org.mozilla.firefox',
            'com.microsoft.emmx',
          ],
        ),
      ),
      safariVCOptions: const SafariViewControllerOptions(
        barCollapsingEnabled: true,
      ),
    );
  }
}

final settingsProvider =
    NotifierProvider<SettingsNotifier, SettingsState>(SettingsNotifier.new);
