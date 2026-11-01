import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:freecodecamp/auth/controllers/profile_controller.dart';
import 'package:freecodecamp/auth/models/user_model.dart';
import 'package:freecodecamp/auth/ui/widgets/log_out_dialog.dart';
import 'package:freecodecamp/fcc_theme.dart';
import 'package:freecodecamp/routing/auth.dart';
import 'package:freecodecamp/routing/podcasts.dart';
import 'package:freecodecamp/routing/settings.dart';
import 'package:freecodecamp/services/auth_service.dart';
import 'package:freecodecamp/utils/custom_tab.dart';
import 'package:freecodecamp/widgets/app_bottom_navigation.dart';
import 'package:freecodecamp/widgets/app_page_title.dart';
import 'package:freecodecamp/widgets/error_retry.dart';

class AccountView extends ConsumerStatefulWidget {
  const AccountView({super.key});

  @override
  ConsumerState<AccountView> createState() => _AccountViewState();
}

class _AccountViewState extends ConsumerState<AccountView> {
  bool _signingOut = false;

  Future<void> _signOut() async {
    if (_signingOut) return;
    final confirmed = await showLogOutDialog(context);
    if (!confirmed || !mounted || _signingOut) return;
    setState(() => _signingOut = true);
    try {
      await ref.read(authProvider.notifier).signOut();
    } catch (_) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Could not sign out. Please try again.'),
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _signingOut = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final auth = ref.watch(authProvider);
    final refresh = ref.watch(profileRefreshProvider);
    final user = auth.value;
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const AppPageTitle('Account'),
        toolbarHeight: AppPageTitle.toolbarHeight(context),
      ),
      bottomNavigationBar: const AppNavigationFooter(
        selected: AppDestination.account,
      ),
      body: SafeArea(
        top: false,
        child: Align(
          alignment: Alignment.topCenter,
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 640),
            child: RefreshIndicator(
              onRefresh: () => ref.refresh(profileRefreshProvider.future),
              child: ListView(
                padding: const EdgeInsets.fromLTRB(16, 12, 16, 32),
                physics: const AlwaysScrollableScrollPhysics(),
                children: [
                  if (user != null) _AccountHeader(user: user),
                  if (user == null && auth.isLoading)
                    const Card(
                      child: Padding(
                        padding: EdgeInsets.all(32),
                        child: Center(child: CircularProgressIndicator()),
                      ),
                    )
                  else if (user == null && !auth.hasError)
                    const _GuestAccount(),
                  if (auth.hasError || refresh.hasError) ...[
                    if (user != null) const SizedBox(height: 12),
                    ErrorRetry(
                      margin: EdgeInsets.zero,
                      message: 'Unable to refresh your account.',
                      onRetry: () => ref.invalidate(profileRefreshProvider),
                    ),
                  ],
                  const SizedBox(height: 16),
                  const _AccountLinks(),
                  if (user != null) ...[
                    const SizedBox(height: 16),
                    OutlinedButton(
                      style: FccTheme.dangerOutlineStyle(context),
                      onPressed: _signingOut ? null : _signOut,
                      child: Text(_signingOut ? 'Logging out…' : 'Log out'),
                    ),
                  ],
                  const SizedBox(height: 18),
                  Text(
                    'freeCodeCamp is a donor-supported tax-exempt 501(c)(3) charity.',
                    textAlign: TextAlign.center,
                    style: theme.textTheme.bodySmall?.copyWith(fontSize: 13),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _AccountHeader extends StatelessWidget {
  const _AccountHeader({required this.user});
  final FccUserModel user;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;
    final identity = Row(
      children: [
        DecoratedBox(
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(color: colors.outlineVariant),
          ),
          child: Padding(
            padding: const EdgeInsets.all(1),
            child: CircleAvatar(
              radius: 31,
              backgroundColor: colors.surfaceContainer,
              backgroundImage: user.picture.isEmpty
                  ? null
                  : CachedNetworkImageProvider(user.picture),
              child: user.picture.isEmpty
                  ? Icon(Icons.person_outline, color: colors.onSurfaceVariant)
                  : null,
            ),
          ),
        ),
        const SizedBox(width: 14),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                user.name.trim().isEmpty ? user.username : user.name,
                style: theme.textTheme.titleMedium?.copyWith(
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                ),
              ),
              Text(
                '@${user.username}',
                style: theme.textTheme.bodySmall?.copyWith(
                  fontFamily: 'JetBrains Mono',
                  fontSize: 13,
                  color: colors.onSurfaceVariant,
                ),
              ),
            ],
          ),
        ),
      ],
    );
    final viewProfile = OutlinedButton(
      style: FccTheme.compactOutlineStyle(context),
      onPressed: () => const ProfileRoute().push<void>(context),
      child: const Text('View profile'),
    );
    return Card(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 16),
        child: LayoutBuilder(
          builder: (context, constraints) {
            final stacked =
                constraints.maxWidth < 300 ||
                MediaQuery.textScalerOf(context).scale(14) > 20;
            return stacked
                ? Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      identity,
                      const SizedBox(height: 12),
                      viewProfile,
                    ],
                  )
                : Row(
                    children: [
                      Expanded(child: identity),
                      const SizedBox(width: 12),
                      viewProfile,
                    ],
                  );
          },
        ),
      ),
    );
  }
}

class _GuestAccount extends StatelessWidget {
  const _GuestAccount();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;
    return Card(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                Container(
                  width: 56,
                  height: 56,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: colors.surfaceContainer,
                    border: Border.all(color: colors.outlineVariant),
                  ),
                  child: Icon(
                    Icons.person_outline,
                    color: colors.onSurfaceVariant,
                    size: 30,
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "You're learning as a guest.",
                        style: theme.textTheme.titleLarge,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Sign in to save progress across devices and earn certifications.',
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: colors.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            FilledButton(
              style: FilledButton.styleFrom(
                textStyle: const TextStyle(
                  fontFamily: 'Lato',
                  fontSize: 17,
                  fontWeight: FontWeight.w700,
                ),
              ),
              onPressed: () => const LoginRoute().push<void>(context),
              child: const Text('Sign in'),
            ),
          ],
        ),
      ),
    );
  }
}

class _AccountLinks extends StatelessWidget {
  const _AccountLinks();

  @override
  Widget build(BuildContext context) => Card(
    clipBehavior: Clip.antiAlias,
    child: Column(
      children: [
        ListTile(
          leading: const Icon(Icons.settings, size: 20),
          title: const Text('Settings'),
          trailing: const Icon(Icons.chevron_right, size: 20),
          onTap: () => const SettingsRoute().push<void>(context),
        ),
        const Divider(),
        ListTile(
          leading: const Icon(Icons.download_outlined, size: 20),
          title: const Text('Downloads'),
          trailing: const Icon(Icons.chevron_right, size: 20),
          onTap: () => const PodcastDownloadsRoute().push<void>(context),
        ),
        const Divider(),
        ListTile(
          leading: const Icon(Icons.error_outline, size: 20),
          title: const Text('Report an issue'),
          trailing: const Icon(Icons.open_in_new, size: 18),
          onTap: () =>
              openInCustomTab('https://github.com/freeCodeCamp/mobile/issues'),
        ),
      ],
    ),
  );
}
