import 'package:flutter/material.dart';
import 'package:freecodecamp/extensions/i18n_extension.dart';
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
      ),
    );
  }
}
