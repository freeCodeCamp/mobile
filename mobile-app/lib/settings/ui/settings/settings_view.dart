import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:freecodecamp/auth/ui/widgets/log_out_dialog.dart';
import 'package:freecodecamp/routing/auth.dart';
import 'package:freecodecamp/routing/podcasts.dart';
import 'package:freecodecamp/routing/settings.dart';
import 'package:freecodecamp/services/app_preferences_service.dart';
import 'package:freecodecamp/services/auth_service.dart';
import 'package:freecodecamp/settings/ui/settings/settings_viewmodel.dart';
import 'package:freecodecamp/utils/custom_tab.dart';
import 'package:freecodecamp/widgets/dialog/confirm_dialog.dart';
import 'package:freecodecamp/widgets/error_retry.dart';
import 'package:freecodecamp/widgets/fcc_switch.dart';
import 'package:freecodecamp/widgets/segmented_tabs.dart';
import 'package:go_router/go_router.dart';

void _showMessage(BuildContext context, String? message) {
  if (message == null || !context.mounted) return;
  ScaffoldMessenger.of(context)
    ..hideCurrentSnackBar()
    ..showSnackBar(SnackBar(content: Text(message)));
}

class SettingsView extends ConsumerWidget {
  const SettingsView({super.key});

  Future<void> _confirmReset(BuildContext context, WidgetRef ref) async {
    final confirmed = await showConfirmDialog(
      context,
      title: 'Reset app data?',
      description:
          'Remove downloaded episodes, saved articles, listening history, settings and reminders from this device, and sign out. Your freeCodeCamp account and online learning progress will be kept.',
      confirmLabel: 'Reset app data',
      destructive: true,
    );
    if (!confirmed || !context.mounted) return;
    final message = await ref.read(settingsProvider.notifier).resetLocalData();
    if (context.mounted) _showMessage(context, message);
  }

  Future<void> _confirmLogOut(BuildContext context, WidgetRef ref) async {
    if (ref.read(settingsProvider).busy) return;
    final confirmed = await showLogOutDialog(context);
    if (!confirmed || !context.mounted) return;
    final message = await ref.read(settingsProvider.notifier).signOut();
    if (context.mounted) _showMessage(context, message);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final auth = ref.watch(authProvider);
    final storage = ref.watch(downloadedStorageBytesProvider);
    final version = ref.watch(appVersionProvider);
    final busy = ref.watch(settingsProvider.select((s) => s.busy));
    final colors = Theme.of(context).colorScheme;
    return PopScope(
      canPop: !busy,
      child: Stack(
        children: [
          Scaffold(
            appBar: AppBar(
              title: const Text('Settings'),
              leading: BackButton(
                onPressed: busy
                    ? null
                    : () => context.canPop()
                          ? context.pop()
                          : const AccountRoute().go(context),
              ),
            ),
            body: SafeArea(
              top: false,
              child: Align(
                alignment: Alignment.topCenter,
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 640),
                  child: ListView(
                    padding: const EdgeInsets.fromLTRB(16, 12, 16, 32),
                    children: [
                      const _ThemeGroup(),
                      _Group(
                        title: 'Learning',
                        children: [
                          const _ReminderRow(),
                          const _SettingsTile(
                            title: 'Language',
                            trailingLabel: 'English',
                          ),
                        ],
                      ),
                      if (auth.value case final user?)
                        _Group(
                          title: 'Privacy',
                          children: [
                            _SettingsTile(
                              title: 'Profile visibility',
                              subtitle:
                                  'Choose who sees your profile and what it shows',
                              trailingLabel: user.profileUI.isLocked
                                  ? 'Private'
                                  : 'Public',
                              onTap: () => const ProfileVisibilityRoute()
                                  .push<void>(context),
                            ),
                          ],
                        ),
                      _Group(
                        title: 'Storage',
                        children: [
                          _SettingsTile(
                            title: 'Downloaded episodes',
                            subtitle: storage.when(
                              data: (bytes) =>
                                  '${formatStorageBytes(bytes)} on this device',
                              loading: () => 'Calculating storage…',
                              error: (_, _) => 'Manage episodes on this device',
                            ),
                            onTap: () async {
                              await const PodcastDownloadsRoute().push<void>(
                                context,
                              );
                              if (context.mounted) {
                                ref.invalidate(downloadedStorageBytesProvider);
                              }
                            },
                          ),
                          _SettingsTile(
                            title: 'Reset app data',
                            subtitle: 'Clears all local data and progress',
                            destructive: true,
                            onTap: () => _confirmReset(context, ref),
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
                                    onTap: () => _confirmLogOut(context, ref),
                                  ),
                                  _SettingsTile(
                                    title: 'Delete account',
                                    destructive: true,
                                    onTap: () =>
                                        const SettingsDeleteAccountRoute()
                                            .push<void>(context),
                                  ),
                                ]
                              : [
                                  _SettingsTile(
                                    title: 'Sign in',
                                    onTap: () =>
                                        const LoginRoute().push<void>(context),
                                  ),
                                ],
                        ),
                      version.when(
                        data: (info) => Text(
                          'Version ${info.version}${info.buildNumber.isEmpty ? '' : ' (${info.buildNumber})'}',
                          textAlign: TextAlign.center,
                          style: Theme.of(context).textTheme.bodySmall
                              ?.copyWith(color: colors.onSurfaceVariant),
                        ),
                        loading: () => const SizedBox.shrink(),
                        error: (_, _) => ErrorRetry(
                          message: 'Could not load version information.',
                          onRetry: () => ref.invalidate(appVersionProvider),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          if (busy) ...[
            const ModalBarrier(dismissible: false, color: Colors.black26),
            const Center(
              child: CircularProgressIndicator(
                semanticsLabel: 'Updating settings',
              ),
            ),
          ],
        ],
      ),
    );
  }
}

String formatStorageBytes(int bytes) {
  if (bytes < 1024) return '$bytes B';
  if (bytes < 1024 * 1024) return '${(bytes / 1024).toStringAsFixed(1)} KB';
  if (bytes < 1024 * 1024 * 1024) {
    return '${(bytes / 1024 / 1024).toStringAsFixed(1)} MB';
  }
  return '${(bytes / 1024 / 1024 / 1024).toStringAsFixed(1)} GB';
}

class _ThemeGroup extends ConsumerWidget {
  const _ThemeGroup();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final preferences = ref.watch(appPreferencesProvider);
    final busy = ref.watch(settingsProvider.select((s) => s.busy));
    return _Group(
      children: [
        Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                'Theme',
                style: Theme.of(
                  context,
                ).textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.w700),
              ),
              const SizedBox(height: 8),
              if (preferences.isLoading)
                const LinearProgressIndicator()
              else if (preferences.hasError)
                ErrorRetry(
                  message: 'Could not load settings.',
                  margin: EdgeInsets.zero,
                  onRetry: () =>
                      ref.read(appPreferencesProvider.notifier).retry(),
                )
              else
                SegmentedTabs<ThemeMode>(
                  tabs: const [
                    (value: ThemeMode.system, label: 'System', icon: null),
                    (value: ThemeMode.light, label: 'Light', icon: null),
                    (value: ThemeMode.dark, label: 'Dark', icon: null),
                  ],
                  selected: preferences.requireValue.themeMode,
                  onSelected: busy
                      ? null
                      : (mode) async {
                          final message = await ref
                              .read(settingsProvider.notifier)
                              .setTheme(mode);
                          if (context.mounted) _showMessage(context, message);
                        },
                ),
            ],
          ),
        ),
      ],
    );
  }
}

class _ReminderRow extends ConsumerWidget {
  const _ReminderRow();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final saved = ref.watch(
      appPreferencesProvider.select((p) => p.value?.dailyReminder),
    );
    final pending = ref.watch(
      settingsProvider.select((s) => s.pendingReminder),
    );
    final busy = ref.watch(settingsProvider.select((s) => s.busy));
    return _SettingsSwitchRow(
      title: 'Daily learning reminder',
      subtitle: 'A nudge to keep learning every day',
      value: pending ?? saved ?? false,
      onChanged: saved == null || busy
          ? null
          : (enabled) async {
              final message = await ref
                  .read(settingsProvider.notifier)
                  .setDailyReminder(enabled);
              if (context.mounted) _showMessage(context, message);
            },
    );
  }
}

class _SettingsSwitchRow extends StatelessWidget {
  const _SettingsSwitchRow({
    required this.title,
    required this.subtitle,
    required this.value,
    required this.onChanged,
  });
  final String title;
  final String subtitle;
  final bool value;
  final ValueChanged<bool>? onChanged;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final enabled = onChanged != null;
    return MergeSemantics(
      child: ListTile(
        minTileHeight: 76,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16),
        title: Text(
          title,
          style: theme.textTheme.bodyLarge?.copyWith(
            height: 1.35,
            fontWeight: FontWeight.w700,
            color: enabled
                ? theme.colorScheme.onSurface
                : theme.colorScheme.outline,
          ),
        ),
        subtitle: Text(
          subtitle,
          style: theme.textTheme.bodySmall?.copyWith(
            color: enabled
                ? theme.colorScheme.onSurfaceVariant
                : theme.colorScheme.outline,
          ),
        ),
        trailing: FccSwitch(
          value: value,
          onChanged: onChanged,
          semanticLabel: title,
        ),
        onTap: enabled ? () => onChanged!(!value) : null,
      ),
    );
  }
}

class _Group extends StatelessWidget {
  const _Group({this.title, required this.children});
  final String? title;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.only(bottom: 22),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (title case final title?) ...[
          Text(
            title,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: Theme.of(context).colorScheme.onSurfaceVariant,
              fontSize: 14,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 8),
        ],
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
    this.onTap,
    this.subtitle,
    this.trailingLabel,
    this.destructive = false,
    this.external = false,
  });
  final String title;
  final String? subtitle;
  final String? trailingLabel;
  final VoidCallback? onTap;
  final bool destructive;
  final bool external;

  @override
  Widget build(BuildContext context) => ListTile(
    minTileHeight: 76,
    contentPadding: const EdgeInsets.symmetric(horizontal: 16),
    title: Text(
      title,
      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
        height: 1.35,
        fontWeight: FontWeight.w700,
        color: destructive ? Theme.of(context).colorScheme.error : null,
      ),
    ),
    subtitle: subtitle == null
        ? null
        : Text(
            subtitle!,
            style: Theme.of(
              context,
            ).textTheme.bodySmall?.copyWith(fontSize: 13),
          ),
    trailing: trailingLabel == null && onTap == null
        ? null
        : Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (trailingLabel != null)
                Text(
                  trailingLabel!,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    fontSize: 14,
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
                ),
              if (onTap != null) ...[
                if (trailingLabel != null) const SizedBox(width: 4),
                Icon(
                  external ? Icons.open_in_new : Icons.chevron_right,
                  size: 20,
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
              ],
            ],
          ),
    onTap: onTap,
  );
}
