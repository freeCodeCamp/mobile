import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:freecodecamp/extensions/i18n_extension.dart';
import 'package:freecodecamp/ui/views/settings/delete-account/delete_account_viewmodel.dart';
import 'package:url_launcher/url_launcher.dart';

Widget buildDivider() => const Divider(
      color: Colors.white24,
      thickness: 1,
      height: 24,
    );

class DeleteAccountView extends ConsumerWidget {
  const DeleteAccountView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    const paragraphTextStyle = TextStyle(
      fontSize: 18,
      height: 1.2,
    );

    final state = ref.watch(deleteAccountProvider);
    final notifier = ref.read(deleteAccountProvider.notifier);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          context.t.settings_delete_account,
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              Text(
                context.t.delete_account_message_one,
                style: paragraphTextStyle,
                textAlign: TextAlign.center,
              ),
              const SizedBox(
                height: 8,
              ),
              Text(
                context.t.delete_account_message_two,
                style: paragraphTextStyle,
                textAlign: TextAlign.center,
              ),
              const SizedBox(
                height: 8,
              ),
              Text(
                context.t.delete_account_message_three,
                style: paragraphTextStyle,
                textAlign: TextAlign.center,
              ),
              const SizedBox(
                height: 8,
              ),
              InkWell(
                onTap: () {
                  launchUrl(
                    Uri.parse('mailto:support@freecodecamp.org'),
                  );
                },
                child: Text(
                  'support@freecodecamp.org',
                  style: paragraphTextStyle.copyWith(
                    decoration: TextDecoration.underline,
                  ),
                ),
              ),
              const SizedBox(
                height: 12,
              ),
              buildDivider(),
              const SizedBox(
                height: 12,
              ),
              Row(
                children: [
                  Expanded(
                    child: TextButton(
                      onPressed: state.processing
                          ? null
                          : () => notifier.deleteAccount(context),
                      style: TextButton.styleFrom(
                        backgroundColor: Colors.red.shade100,
                        foregroundColor: Colors.red.shade900,
                        side: BorderSide(
                          width: 2,
                          color: Colors.red.shade900,
                        ),
                        disabledBackgroundColor: Colors.red.shade50,
                        disabledForegroundColor: Colors.red.shade700,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(0),
                        ),
                      ),
                      child: Text(
                        context.t.delete_account_message_four,
                        textAlign: TextAlign.center,
                        style: paragraphTextStyle,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
