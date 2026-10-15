import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mobile_app_new/routing/settings.dart';
import 'package:mobile_app_new/services/auth_service.dart';
import 'package:mobile_app_new/utils/custom_tab.dart';
import 'package:mobile_app_new/widgets/dialog/confirm_dialog.dart';
import 'package:mobile_app_new/widgets/drawer/drawer.dart';
import 'package:mobile_app_new/widgets/section_divider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsView extends ConsumerWidget {
  const SettingsView({super.key});

  Future<void> _confirmResetCache(BuildContext context) async {
    final confirmed = await showConfirmDialog(
      context,
      title: 'Reset Cache',
      description: 'Clears all local data and progress',
      confirmLabel: 'Clear',
    );

    if (!confirmed) return;

    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();

    if (context.mounted) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Cache cleared')));
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isLoggedIn = ref.watch(authProvider.select((s) => s.isLoggedIn));

    return Scaffold(
      appBar: AppBar(title: const Text('SETTINGS')),
      drawer: const DrawerWidget(),
      body: Column(
        children: [
          if (isLoggedIn) ...[
            ListTile(
              leading: const Icon(Icons.delete_forever),
              title: const Text('Delete Account'),
              subtitle: const Text('Delete your freeCodeCamp account'),
              onTap: () =>
                  const SettingsDeleteAccountRoute().push<void>(context),
            ),
            sectionDivider,
          ],
          ListTile(
            leading: const Icon(Icons.dataset_linked),
            title: const Text('Reset Cache'),
            subtitle: const Text('Clears all local data and progress'),
            onTap: () => _confirmResetCache(context),
          ),
          sectionDivider,
          ListTile(
            leading: const Icon(Icons.privacy_tip),
            title: const Text('Privacy Policy'),
            subtitle: const Text('Read our privacy policy'),
            onTap: () => openInCustomTab(
              'https://www.freecodecamp.org/news/privacy-policy/',
            ),
          ),
          sectionDivider,
        ],
      ),
    );
  }
}
