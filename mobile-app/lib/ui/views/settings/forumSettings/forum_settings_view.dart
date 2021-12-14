import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:freecodecamp/ui/views/settings/forumSettings/forum_settings_viewmodel.dart';
import 'package:stacked/stacked.dart';

class ForumSettingsView extends StatelessWidget {
  const ForumSettingsView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<ForumSettingsViewModel>.reactive(
        onModelReady: (model) => model.init(),
        viewModelBuilder: () => ForumSettingsViewModel(),
        builder: (context, model, child) => Scaffold(
              appBar: AppBar(
                title: const Text('FORUM SETTINGS'),
              ),
              body: ListView(
                children: [
                  model.isLoggedIn ? loginButton(model) : Container(),
                  Container(
                    decoration: const BoxDecoration(
                        border:
                            Border(bottom: BorderSide(color: Colors.white))),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ListTile(
                        title: const Text(
                          'REGISTER',
                        ),
                        subtitle: const Text(
                          'register on the forum',
                        ),
                        onTap: () {
                          model.gotoForum();
                        },
                      ),
                    ),
                  ),
                  Container(
                    decoration: const BoxDecoration(
                        border:
                            Border(bottom: BorderSide(color: Colors.white))),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ListTile(
                        title: const Text(
                          'RESET PASSWORD',
                        ),
                        subtitle: const Text(
                          'reset your password on the forum',
                        ),
                        onTap: () {
                          model.gotoForum();
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ));
  }

  Container loginButton(ForumSettingsViewModel model) {
    return Container(
      decoration: const BoxDecoration(
          border: Border(bottom: BorderSide(color: Colors.white))),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ListTile(
          title: const Text(
            'LOGOUT',
          ),
          subtitle: const Text(
            'logout from the forum',
          ),
          onTap: () {
            model.forumLogout();
          },
        ),
      ),
    );
  }
}
