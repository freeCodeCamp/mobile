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
              backgroundColor: const Color.fromRGBO(0x2A, 0x2A, 0x40, 1),
              appBar: AppBar(
                backgroundColor: const Color(0xFF0a0a23),
                title: const Text('FORUM SETTINGS'),
                centerTitle: true,
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
                          style: TextStyle(color: Colors.white),
                        ),
                        subtitle: const Text(
                          'register on the forum',
                          style: TextStyle(color: Colors.white),
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
                          style: TextStyle(color: Colors.white),
                        ),
                        subtitle: const Text(
                          'reset your password on the forum',
                          style: TextStyle(color: Colors.white),
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
            style: TextStyle(color: Colors.white),
          ),
          subtitle: const Text(
            'logout from the forum',
            style: TextStyle(color: Colors.white),
          ),
          onTap: () {
            model.forumLogout();
          },
        ),
      ),
    );
  }
}
