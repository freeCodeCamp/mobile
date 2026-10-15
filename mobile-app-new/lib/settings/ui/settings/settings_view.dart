import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mobile_app_new/routing/auth.dart';
import 'package:mobile_app_new/routing/podcasts.dart';
import 'package:mobile_app_new/routing/settings.dart';
import 'package:mobile_app_new/services/auth_service.dart';
import 'package:mobile_app_new/utils/custom_tab.dart';
import 'package:mobile_app_new/widgets/dialog/confirm_dialog.dart';
import 'package:mobile_app_new/widgets/drawer/drawer.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsView extends ConsumerWidget {
  const SettingsView({super.key});

  Future<void> _confirmResetCache(BuildContext context) async {
    final confirmed = await showConfirmDialog(
      context,
      title: 'Reset app data?',
      description:
          'This clears all locally saved app data and progress. Your freeCodeCamp account will not be deleted.',
      confirmLabel: 'Reset app data',
      destructive: true,
    );
    if (!confirmed) return;
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
    if (context.mounted) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Local app data cleared')));
    }
  }

  Future<void> _signOut(BuildContext context, WidgetRef ref) async {
    try {
      await ref.read(authProvider.notifier).signOut();
    } catch (_) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Could not sign out. Please try again.'),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final auth = ref.watch(authProvider);
    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      drawer: const DrawerWidget(),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 32),
        children: [
          _Group(
            title: 'Storage',
            children: [
              _SettingsTile(
                title: 'Downloaded episodes',
                subtitle: 'Manage episodes on this device',
                onTap: () => const PodcastDownloadsRoute().go(context),
              ),
              _SettingsTile(
                title: 'Reset app data',
                subtitle: 'Clears all local data and progress',
                destructive: true,
                onTap: () => _confirmResetCache(context),
              ),
            ],
          ),
          _Group(
            title: 'About',
            children: [
              _SettingsTile(
                title: 'Privacy Policy',
                external: true,
                onTap: () => openInCustomTab(
                  'https://www.freecodecamp.org/news/privacy-policy/',
                ),
              ),
              _SettingsTile(
                title: 'Terms of Service',
                external: true,
                onTap: () => openInCustomTab(
                  'https://www.freecodecamp.org/news/terms-of-service/',
                ),
              ),
            ],
          ),
          if (!auth.isLoading && !auth.hasError)
            _Group(
              title: 'Account',
              children: auth.isLoggedIn
                  ? [
                      _SettingsTile(
                        title: 'Log out',
                        onTap: () => _signOut(context, ref),
                      ),
                      _SettingsTile(
                        title: 'Delete account',
                        destructive: true,
                        onTap: () => const SettingsDeleteAccountRoute()
                            .push<void>(context),
                      ),
                    ]
                  : [
                      _SettingsTile(
                        title: 'Sign in',
                        subtitle: 'Save your progress across devices',
                        onTap: () => const LoginRoute().push<void>(context),
                      ),
                    ],
            ),
        ],
      ),
    );
  }
}

class _Group extends StatelessWidget {
  const _Group({required this.title, required this.children});
  final String title;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.only(bottom: 22),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: Theme.of(context).textTheme.titleSmall?.copyWith(
            color: Theme.of(context).colorScheme.onSurfaceVariant,
          ),
        ),
        const SizedBox(height: 8),
        Card(
          clipBehavior: Clip.antiAlias,
          child: Column(
            children: [
              for (final (i, child) in children.indexed) ...[
                if (i > 0) const Divider(),
                child,
              ],
            ],
          ),
        ),
      ],
    ),
  );
}

class _SettingsTile extends StatelessWidget {
  const _SettingsTile({
    required this.title,
    required this.onTap,
    this.subtitle,
    this.destructive = false,
    this.external = false,
  });
  final String title;
  final String? subtitle;
  final VoidCallback onTap;
  final bool destructive;
  final bool external;

  @override
  Widget build(BuildContext context) => ListTile(
    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
    title: Text(
      title,
      style: Theme.of(context).textTheme.titleMedium?.copyWith(
        color: destructive ? Theme.of(context).colorScheme.error : null,
      ),
    ),
    subtitle: subtitle == null ? null : Text(subtitle!),
    trailing: Icon(
      external ? Icons.open_in_new : Icons.chevron_right,
      size: 20,
    ),
    onTap: onTap,
  );
}
