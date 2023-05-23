import 'package:flutter/material.dart';
import 'package:freecodecamp/ui/views/settings/delete-account/delete_account_viewmodel.dart';
import 'package:freecodecamp/ui/widgets/drawer_widget/drawer_widget_view.dart';
import 'package:stacked/stacked.dart';
import 'package:url_launcher/url_launcher.dart';

class DeleteAccountView extends StatelessWidget {
  const DeleteAccountView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    const paragraphTextStyle = TextStyle(
      fontSize: 18,
      fontFamily: 'Lato',
      height: 1.2,
    );

    return ViewModelBuilder<DeleteAccountViewModel>.reactive(
      viewModelBuilder: () => DeleteAccountViewModel(),
      builder: (context, model, child) => Scaffold(
        appBar: AppBar(
          title: const Text('Delete My Account'),
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                const Text(
                  'This will really delete all your data, including all your progress and account information.',
                  style: paragraphTextStyle,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(
                  height: 8,
                ),
                const Text(
                  "We won't be able to recover any of it for you later, even if you change your mind.",
                  style: paragraphTextStyle,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(
                  height: 8,
                ),
                const Text(
                  "If there's something we could do better, send us an email instead and we'll do our best:",
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
                // Row(
                //   children: [
                //     Expanded(
                //       child: TextButton(
                //         onPressed: () => Navigator.pop(context),
                //         style: TextButton.styleFrom(
                //           backgroundColor: const Color(0xFF0a0a23),
                //           side: const BorderSide(
                //             width: 2,
                //             color: Colors.white,
                //           ),
                //         ),
                //         child: const Text(
                //           "Nevermind, I don't want to delete my account",
                //           textAlign: TextAlign.center,
                //           style: paragraphTextStyle,
                //         ),
                //       ),
                //     ),
                //   ],
                // ),
                // const SizedBox(
                //   height: 12,
                // ),
                Row(
                  children: [
                    Expanded(
                      child: TextButton(
                        onPressed: model.processing
                            ? null
                            : () => model.deleteAccount(context),
                        style: TextButton.styleFrom(
                          backgroundColor: Colors.red.shade100,
                          foregroundColor: Colors.red.shade900,
                          side: BorderSide(
                            width: 2,
                            color: Colors.red.shade900,
                          ),
                          disabledBackgroundColor: Colors.red.shade50,
                          disabledForegroundColor: Colors.red.shade700,
                        ),
                        child: const Text(
                          'I am 100% certain. Delete everything related to this account',
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
      ),
    );
  }
}
