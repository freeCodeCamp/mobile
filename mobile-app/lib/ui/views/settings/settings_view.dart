import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:freecodecamp/extensions/i18n_extension.dart';
import 'package:freecodecamp/service/authentication/authentication_service.dart';
import 'package:freecodecamp/ui/views/settings/delete-account/delete_account_view.dart';
import 'package:freecodecamp/ui/views/settings/settings_viewmodel.dart';
import 'package:freecodecamp/ui/widgets/drawer_widget/drawer_widget_view.dart';

Widget buildDivider() => const Divider(
      color: Colors.white24,
      thickness: 1,
      height: 24,
    );

class SettingsView extends ConsumerStatefulWidget {
  const SettingsView({super.key});

  @override
  ConsumerState<SettingsView> createState() => _SettingsViewState();
}

class _SettingsViewState extends ConsumerState<SettingsView> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(settingsProvider.notifier).init();
    });
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(settingsProvider);
    final notifier = ref.read(settingsProvider.notifier);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          context.t.settings_title,
        ),
      ),
      drawer: const DrawerWidgetView(),
      body: Column(
        children: [
          if (AuthenticationService.staticIsloggedIn) ...[
            ListTile(
              leading: const Icon(Icons.delete_forever),
              title: Text(
                context.t.settings_delete_account,
              ),
              subtitle: Text(
                context.t.settings_delete_account_description,
              ),
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const DeleteAccountView(),
                  settings: const RouteSettings(name: '/delete-account'),
                ),
              ),
            ),
            buildDivider(),
          ],
          ListTile(
            leading: const Icon(Icons.dataset_linked),
            title: Text(context.t.settings_reset_cache),
            subtitle: Text(
              context.t.settings_reset_cache_description,
            ),
            onTap: () => notifier.resetCache(context),
          ),
          buildDivider(),
          ListTile(
            leading: const Icon(Icons.privacy_tip),
            title: Text(
              context.t.settings_privacy_policy,
            ),
            subtitle: Text(
              context.t.settings_privacy_policy_description,
            ),
            onTap: () => notifier.openPrivacyPolicy(),
          ),
          buildDivider(),
          // language dropdown selector
          if (state.isDev)
            ListTile(
              leading: const Icon(Icons.language),
              title: Text(context.t.settings_language),
              subtitle: DropdownButton<String>(
                isExpanded: true,
                value: notifier.localeService.currentLocaleName,
                dropdownColor: const Color(0xFF0a0a23),
                onChanged: (String? newValue) {
                  notifier.localeService.changeLocale(newValue!);
                },
                items: <String>[...notifier.localeService.localeNames]
                    .map<DropdownMenuItem<String>>(
                  (String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(
                        value.toUpperCase(),
                        style: const TextStyle(color: Colors.white),
                      ),
                    );
                  },
                ).toList(),
              ),
            ),
        ],
      ),
    );
  }
}
