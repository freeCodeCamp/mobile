import 'package:flutter/material.dart';
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
          title: const Text('SETTINGS'),
        ),
        drawer: const DrawerWidgetView(),
        body: Column(
          children: [
            if (AuthenticationService.staticIsloggedIn) ...[
              ListTile(
                leading: const Icon(Icons.delete_forever),
                title: const Text('Delete my account'),
                subtitle: const Text('Delete your freeCodeCamp account'),
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
              title: const Text('Reset Cache'),
              subtitle: const Text('Clears all local data and progress'),
              onTap: () => model.resetCache(),
            ),
            buildDivider(),
            ListTile(
              leading: const Icon(Icons.privacy_tip),
              title: const Text('Privacy Policy'),
              subtitle: const Text('Read our privacy policy'),
              onTap: () => model.openPrivacyPolicy(),
            ),
            buildDivider(),
          ],
        ),
      ),
    );
  }
}
