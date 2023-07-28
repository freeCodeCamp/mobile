import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:freecodecamp/service/authentication/authentication_service.dart';
import 'package:freecodecamp/ui/views/settings/delete-account/delete_account_view.dart';
import 'package:freecodecamp/ui/views/settings/settings_viewmodel.dart';
import 'package:freecodecamp/ui/widgets/drawer_widget/drawer_widget_view.dart';
import 'package:stacked/stacked.dart';

class SettingsView extends StatelessWidget {
  const SettingsView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<SettingsViewModel>.reactive(
      viewModelBuilder: () => SettingsViewModel(),
      onViewModelReady: (viewModel) => viewModel.init(),
      builder: (context, model, child) => Scaffold(
        appBar: AppBar(
          title: Text(
            AppLocalizations.of(context)!.settings_title,
          ),
        ),
        drawer: const DrawerWidgetView(),
        body: Column(
          children: [
            if (AuthenticationService.staticIsloggedIn) ...[
              ListTile(
                leading: const Icon(Icons.delete_forever),
                title: Text(
                  AppLocalizations.of(context)!.settings_delete_account,
                ),
                subtitle: Text(
                  AppLocalizations.of(context)!
                      .settings_delete_account_description,
                ),
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const DeleteAccountView(),
                    settings: const RouteSettings(name: 'Delete Account View'),
                  ),
                ),
              ),
              buildDivider(),
            ],
            ListTile(
              leading: const Icon(Icons.dataset_linked),
              title: Text(AppLocalizations.of(context)!.settings_reset_cache),
              subtitle: Text(
                AppLocalizations.of(context)!.settings_reset_cache_description,
              ),
              onTap: () => model.resetCache(context),
            ),
            buildDivider(),
            ListTile(
              leading: const Icon(Icons.privacy_tip),
              title: Text(
                AppLocalizations.of(context)!.settings_privacy_policy,
              ),
              subtitle: Text(
                AppLocalizations.of(context)!
                    .settings_privacy_policy_description,
              ),
              onTap: () => model.openPrivacyPolicy(),
            ),
            buildDivider(),
          ],
        ),
      ),
    );
  }
}
