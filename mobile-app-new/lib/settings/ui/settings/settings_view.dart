import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:mobile_app_new/routing/auth.dart';
import 'package:mobile_app_new/routing/podcasts.dart';
import 'package:mobile_app_new/routing/settings.dart';
import 'package:mobile_app_new/services/auth_service.dart';
import 'package:mobile_app_new/settings/services/app_preferences.dart';
import 'package:mobile_app_new/settings/services/learning_reminder_service.dart';
import 'package:mobile_app_new/settings/services/local_data_service.dart';
import 'package:mobile_app_new/utils/custom_tab.dart';
import 'package:mobile_app_new/widgets/dialog/confirm_dialog.dart';

class SettingsView extends ConsumerStatefulWidget {
  const SettingsView({super.key});

  @override
  ConsumerState<SettingsView> createState() => _SettingsViewState();
}

class _SettingsViewState extends ConsumerState<SettingsView> {
  bool _busy = false;

  void _message(String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(message)));
  }

  Future<void> _change(Future<void> Function() action) async {
    if (_busy) return;
    setState(() => _busy = true);
    try {
      await action();
    } on ReminderPermissionDenied {
      _message(
        'Allow notifications in your device settings to enable reminders.',
      );
    } catch (_) {
      _message('Could not save this change. Please try again.');
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  Future<void> _confirmReset() async {
    final confirmed = await showConfirmDialog(
      context,
      title: 'Reset app data?',
      description:
          'Remove downloaded episodes, saved articles, listening history, settings and reminders from this device, and sign out. Your freeCodeCamp account and online learning progress will be kept.',
      confirmLabel: 'Reset app data',
      destructive: true,
    );
    if (!confirmed || !mounted || _busy) return;
    setState(() => _busy = true);
    try {
      await ref.read(localDataResetServiceProvider).reset();
      _message('Local app data cleared. Your online progress is safe.');
    } on DownloadsInProgress {
      _message('Finish or cancel your episode downloads before resetting.');
    } catch (_) {
      _message('Some local data could not be cleared. Please try again.');
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final auth = ref.watch(authProvider);
    final preferences = ref.watch(appPreferencesProvider);
    final storage = ref.watch(downloadedStorageBytesProvider);
    final version = ref.watch(appVersionProvider);
    final colors = Theme.of(context).colorScheme;
    final current = preferences.value;
    return PopScope(
      canPop: !_busy,
      child: Stack(
        children: [
          Scaffold(
            appBar: AppBar(
              title: const Text('Settings'),
              leading: BackButton(
                onPressed: _busy
                    ? null
                    : () => context.canPop()
                          ? context.pop()
                          : const ProfileRoute().go(context),
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
                      _Group(
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
                                  ).textTheme.titleMedium,
                                ),
                                const SizedBox(height: 12),
                                if (preferences.isLoading)
                                  const LinearProgressIndicator()
                                else if (preferences.hasError)
                                  TextButton.icon(
                                    onPressed: () => ref.invalidate(
                                      settingsPreferencesStoreProvider,
                                    ),
                                    icon: const Icon(Icons.refresh),
                                    label: const Text(
                                      'Could not load settings. Retry',
                                    ),
                                  )
                                else
                                  LayoutBuilder(
                                    builder: (context, constraints) {
                                      final largeText =
                                          MediaQuery.textScalerOf(
                                            context,
                                          ).scale(14) >
                                          20;
                                      final buttons = [
                                        for (final mode in ThemeMode.values)
                                          _ThemeChoice(
                                            mode: mode,
                                            selected:
                                                current!.themeMode == mode,
                                            onPressed: () => _change(
                                              () => ref
                                                  .read(
                                                    appPreferencesProvider
                                                        .notifier,
                                                  )
                                                  .setTheme(mode),
                                            ),
                                          ),
                                      ];
                                      return largeText &&
                                              constraints.maxWidth < 400
                                          ? Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.stretch,
                                              children: [
                                                for (final button in buttons)
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                          bottom: 4,
                                                        ),
                                                    child: button,
                                                  ),
                                              ],
                                            )
                                          : Row(
                                              children: [
                                                for (final (index, button)
                                                    in buttons.indexed) ...[
                                                  if (index > 0)
                                                    const SizedBox(width: 4),
                                                  Expanded(child: button),
                                                ],
                                              ],
                                            );
                                    },
                                  ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      _Group(
                        title: 'Learning',
                        children: [
                          SwitchListTile.adaptive(
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 10,
                            ),
                            title: const Text('Daily reminder'),
                            subtitle: const Text(
                              'Remind me to learn at 9:00 AM',
                            ),
                            value: current?.dailyReminder ?? false,
                            onChanged: current == null || _busy
                                ? null
                                : (enabled) => _change(
                                    () => ref
                                        .read(appPreferencesProvider.notifier)
                                        .setDailyReminder(enabled),
                                  ),
                          ),
                          const _SettingsTile(
                            title: 'Language',
                            subtitle: 'English',
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
                              if (mounted) {
                                ref.invalidate(downloadedStorageBytesProvider);
                              }
                            },
                          ),
                          _SettingsTile(
                            title: 'Reset app data',
                            subtitle: 'Remove local data and sign out',
                            destructive: true,
                            onTap: _confirmReset,
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
                                    onTap: () => _change(
                                      () => ref
                                          .read(authProvider.notifier)
                                          .signOut(),
                                    ),
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
                        error: (_, _) => TextButton(
                          onPressed: () => ref.invalidate(appVersionProvider),
                          child: const Text('Retry version information'),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          if (_busy) ...[
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

class _ThemeChoice extends StatelessWidget {
  const _ThemeChoice({
    required this.mode,
    required this.selected,
    required this.onPressed,
  });
  final ThemeMode mode;
  final bool selected;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return Semantics(
      selected: selected,
      child: OutlinedButton(
        style: OutlinedButton.styleFrom(
          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 12),
          backgroundColor: selected
              ? colors.primaryContainer
              : Colors.transparent,
          foregroundColor: selected
              ? colors.onPrimaryContainer
              : colors.onSurfaceVariant,
          side: BorderSide(
            color: selected ? colors.primary : colors.outlineVariant,
          ),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
        onPressed: onPressed,
        child: Text(switch (mode) {
          ThemeMode.system => 'System',
          ThemeMode.light => 'Light',
          ThemeMode.dark => 'Dark',
        }),
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
            style: Theme.of(context).textTheme.titleSmall?.copyWith(
              color: Theme.of(context).colorScheme.onSurfaceVariant,
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
    this.destructive = false,
    this.external = false,
  });
  final String title;
  final String? subtitle;
  final VoidCallback? onTap;
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
    trailing: onTap == null
        ? null
        : Icon(external ? Icons.open_in_new : Icons.chevron_right, size: 20),
    onTap: onTap,
  );
}
