import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:freecodecamp/fcc_theme.dart';
import 'package:freecodecamp/routing/auth.dart';
import 'package:freecodecamp/routing/learn.dart';
import 'package:freecodecamp/routing/settings.dart';
import 'package:freecodecamp/services/auth_service.dart';
import 'package:freecodecamp/settings/ui/settings/delete_account/delete_account_viewmodel.dart';
import 'package:freecodecamp/widgets/dialog/confirm_dialog.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher.dart';

class DeleteAccountView extends ConsumerStatefulWidget {
  const DeleteAccountView({super.key});

  @override
  ConsumerState<DeleteAccountView> createState() => _DeleteAccountViewState();
}

class _DeleteAccountViewState extends ConsumerState<DeleteAccountView> {
  bool _certain = false;

  void _keepAccount() =>
      context.canPop() ? context.pop() : const SettingsRoute().go(context);

  Future<void> _contactSupport() async {
    var opened = false;
    try {
      opened = await launchUrl(Uri.parse('mailto:support@freecodecamp.org'));
    } catch (_) {
      // The address remains selectable if this device has no email application.
    }
    if (!opened && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'No email app is available. You can copy support@freecodecamp.org.',
          ),
        ),
      );
    }
  }

  Future<void> _delete() async {
    if (!_certain || ref.read(deleteAccountProvider)) return;
    final confirmed = await showConfirmDialog(
      context,
      title: 'Delete account?',
      description:
          'This permanently deletes your progress and everything associated with your freeCodeCamp account. This cannot be undone.',
      confirmLabel: 'Delete account',
      destructive: true,
    );
    if (!confirmed || !mounted) return;
    final messenger = ScaffoldMessenger.of(context);
    final message = await ref
        .read(deleteAccountProvider.notifier)
        .deleteAccount();
    if (!mounted) return;
    messenger.showSnackBar(SnackBar(content: Text(message)));
    if (!ref.read(authProvider).isLoggedIn) {
      const LearnLandingRoute().go(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDeleting = ref.watch(deleteAccountProvider);
    final auth = ref.watch(authProvider);
    final theme = Theme.of(context);
    final colors = theme.colorScheme;
    final design = FccDesignColors.of(context);
    return PopScope(
      canPop: !isDeleting,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Delete account'),
          leading: BackButton(onPressed: isDeleting ? null : _keepAccount),
        ),
        body: Stack(
          children: [
            SafeArea(
              top: false,
              bottom: false,
              child: Align(
                alignment: Alignment.topCenter,
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 640),
                  child: ListView(
                    padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
                    children: [
                      Align(
                        alignment: Alignment.centerLeft,
                        child: CircleAvatar(
                          radius: 28,
                          backgroundColor: colors.error.withValues(alpha: .12),
                          child: Icon(
                            Icons.delete_outline,
                            size: 28,
                            color: colors.error,
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'Delete your account?',
                        style: theme.textTheme.headlineMedium?.copyWith(
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      const SizedBox(height: 16),
                      const Text(
                        'This will really delete all your data, including all your progress and account information.',
                        style: TextStyle(fontSize: 16, height: 1.5),
                      ),
                      const SizedBox(height: 16),
                      const Text(
                        "We won't be able to recover any of it for you later, even if you change your mind.",
                        style: TextStyle(fontSize: 16, height: 1.5),
                      ),
                      const SizedBox(height: 16),
                      Card(
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                "If there's something we could do better, send us an email instead and we'll do our best:",
                                style: TextStyle(fontSize: 16, height: 1.5),
                              ),
                              const SizedBox(height: 12),
                              SelectableText(
                                'support@freecodecamp.org',
                                onTap: isDeleting ? null : _contactSupport,
                                style: TextStyle(
                                  fontSize: 16,
                                  color: design.accentText,
                                  decoration: TextDecoration.underline,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),
                      CheckboxListTile(
                        contentPadding: EdgeInsets.zero,
                        controlAffinity: ListTileControlAffinity.leading,
                        activeColor: colors.error,
                        checkColor: colors.onError,
                        title: const Text(
                          'I am 100% certain. Delete everything related to this account.',
                        ),
                        value: _certain,
                        onChanged: isDeleting
                            ? null
                            : (value) =>
                                  setState(() => _certain = value ?? false),
                      ),
                      if (!auth.isLoading && !auth.isLoggedIn)
                        TextButton(
                          onPressed: auth.hasError
                              ? () => ref.invalidate(authProvider)
                              : () => const LoginRoute().push<void>(context),
                          child: Text(
                            auth.hasError
                                ? 'Could not load your account. Retry'
                                : 'Sign in to manage your account',
                          ),
                        ),
                    ],
                  ),
                ),
              ),
            ),
            if (isDeleting) ...[
              const ModalBarrier(dismissible: false, color: Colors.black26),
              const Center(
                child: CircularProgressIndicator(
                  semanticsLabel: 'Deleting account',
                ),
              ),
            ],
          ],
        ),
        bottomNavigationBar: DecoratedBox(
          decoration: BoxDecoration(
            color: theme.scaffoldBackgroundColor,
            border: Border(top: BorderSide(color: colors.outlineVariant)),
          ),
          child: SafeArea(
            top: false,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 10, 16, 12),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 608),
                    child: SizedBox(
                      width: double.infinity,
                      child: FilledButton(
                        onPressed: _certain && !isDeleting && auth.isLoggedIn
                            ? _delete
                            : null,
                        style: FccTheme.dangerStyle(context).copyWith(
                          textStyle: const WidgetStatePropertyAll(
                            TextStyle(
                              fontFamily: 'Lato',
                              fontSize: 17,
                              fontWeight: FontWeight.w900,
                            ),
                          ),
                        ),
                        child: const Text(
                          'Delete my account',
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 608),
                    child: SizedBox(
                      width: double.infinity,
                      child: OutlinedButton(
                        onPressed: isDeleting ? null : _keepAccount,
                        style: OutlinedButton.styleFrom(
                          minimumSize: const Size.fromHeight(50),
                          textStyle: const TextStyle(
                            fontFamily: 'Lato',
                            fontSize: 17,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        child: const Text(
                          'Keep my account',
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
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
