import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mobile_app_new/routing/learn.dart';
import 'package:mobile_app_new/services/auth_service.dart';
import 'package:mobile_app_new/settings/ui/settings/delete_account/delete_account_viewmodel.dart';
import 'package:mobile_app_new/widgets/dialog/confirm_dialog.dart';
import 'package:mobile_app_new/widgets/section_divider.dart';
import 'package:url_launcher/url_launcher.dart';

const _paragraphStyle = TextStyle(fontSize: 18, height: 1.2);

class DeleteAccountView extends ConsumerWidget {
  const DeleteAccountView({super.key});

  Future<void> _delete(BuildContext context, WidgetRef ref) async {
    final confirmed = await showConfirmDialog(
      context,
      title: 'Delete Account',
      description:
          'Are you sure you want to delete your account? - this deletes everything related to your account',
      confirmLabel: 'Delete Account',
      destructive: true,
    );

    if (!confirmed || !context.mounted) return;

    final messenger = ScaffoldMessenger.of(context);
    final message = await ref
        .read(deleteAccountProvider.notifier)
        .deleteAccount();

    messenger.showSnackBar(SnackBar(content: Text(message)));

    // NOTE: Signed out means the account was deleted or the session expired.
    if (context.mounted && !ref.read(authProvider).isLoggedIn) {
      const LearnLandingRoute().go(context);
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDeleting = ref.watch(deleteAccountProvider);

    return PopScope(
      canPop: !isDeleting,
      child: Scaffold(
        appBar: AppBar(title: const Text('Delete Account')),
        body: Stack(
          children: [
            SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  const Text(
                    'This will really delete all your data, including all your progress and account information.',
                    style: _paragraphStyle,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    "We won't be able to recover any of it for you later, even if you change your mind.",
                    style: _paragraphStyle,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    "If there's something we could do better, send us an email instead and we'll do our best:",
                    style: _paragraphStyle,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 8),
                  InkWell(
                    onTap: () =>
                        launchUrl(Uri.parse('mailto:support@freecodecamp.org')),
                    child: Text(
                      'support@freecodecamp.org',
                      style: _paragraphStyle.copyWith(
                        decoration: TextDecoration.underline,
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  sectionDivider,
                  const SizedBox(height: 12),
                  SizedBox(
                    width: double.infinity,
                    child: TextButton(
                      onPressed: isDeleting
                          ? null
                          : () => _delete(context, ref),
                      style: TextButton.styleFrom(
                        backgroundColor: Colors.red.shade100,
                        foregroundColor: Colors.red.shade900,
                        side: BorderSide(width: 2, color: Colors.red.shade900),
                        disabledBackgroundColor: Colors.red.shade50,
                        disabledForegroundColor: Colors.red.shade700,
                        shape: const RoundedRectangleBorder(),
                      ),
                      child: const Text(
                        'I am 100% certain. Delete everything related to this account',
                        textAlign: TextAlign.center,
                        style: _paragraphStyle,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            if (isDeleting)
              const ModalBarrier(dismissible: false, color: Colors.black54),
            if (isDeleting) const Center(child: CircularProgressIndicator()),
          ],
        ),
      ),
    );
  }
}
