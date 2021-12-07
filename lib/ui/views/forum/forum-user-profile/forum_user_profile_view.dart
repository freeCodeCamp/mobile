import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:freecodecamp/models/forum_post_model.dart';
import 'package:freecodecamp/ui/views/forum/forum-user-profile/forum_user_profile_viewmodel.dart';
import 'package:stacked/stacked.dart';

class ForumUserProfileView extends StatelessWidget {
  const ForumUserProfileView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<ForumUserProfileViewModel>.reactive(
        viewModelBuilder: () => ForumUserProfileViewModel(),
        onModelReady: (model) => model.initState(),
        builder: (context, model, child) => Scaffold(
            resizeToAvoidBottomInset: false,
            appBar: AppBar(
              backgroundColor: const Color(0xFF0a0a23),
              centerTitle: true,
              title: const Text(
                'Your forum profile',
                style: TextStyle(color: Colors.white),
              ),
            ),
            backgroundColor: const Color.fromRGBO(0x2A, 0x2A, 0x40, 1),
            body: model.userLoaded
                ? userSettingsTemplate(model)
                : const Center(
                    child: CircularProgressIndicator(
                    color: Colors.white,
                  ))));
  }

  Column userSettingsTemplate(ForumUserProfileViewModel model) {
    return Column(
      children: [
        const ListTile(
          title: Text(
            "Account",
            style: TextStyle(
                color: Colors.white, fontWeight: FontWeight.bold, fontSize: 24),
          ),
        ),
        ListTile(
          title: const Text(
            "Username",
            style: TextStyle(color: Colors.white, fontSize: 20),
          ),
          subtitle: Text(
            'People can mention you as @' + model.user.username,
            style: const TextStyle(color: Colors.white),
          ),
        ),
        const ListTile(
          title: Text("Profile Picture",
              style: TextStyle(color: Colors.white, fontSize: 20)),
        ),
        ListTile(
          leading: Stack(
            children: [
              const SizedBox(
                width: 60,
                height: 60,
                child: Center(
                  child: CircularProgressIndicator(
                    color: Colors.white,
                  ),
                ),
              ),
              Image.network(PostModel.parseProfileAvatar(
                model.baseUrl + model.user.profilePicture,
              ))
            ],
          ),
          trailing: Container(
            constraints: const BoxConstraints(minWidth: 200),
            child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                    primary: const Color.fromRGBO(0x3b, 0x3b, 0x4f, 1),
                    side: const BorderSide(width: 2, color: Colors.white),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(0))),
                onPressed: () {
                  model.changeProfilePicture();
                },
                child: const Text(
                  'change profile picture',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.white),
                )),
          ),
        ),
        ListTile(
          title: const Text("Email",
              style: TextStyle(color: Colors.white, fontSize: 20)),
          isThreeLine: true,
          subtitle: Column(
            children: [
              Row(
                children: [
                  Text(
                    model.user.userEmail,
                    style: const TextStyle(color: Colors.white),
                  ),
                ],
              ),
              Row(
                children: [
                  Text(
                    'Primary',
                    style: TextStyle(color: Colors.green[800]),
                  ),
                ],
              )
            ],
          ),
        ),
        ListTile(
            trailing: Container(
          constraints: const BoxConstraints(minWidth: 200),
          child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                  primary: const Color.fromRGBO(0x3b, 0x3b, 0x4f, 1),
                  side: const BorderSide(width: 2, color: Colors.white),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(0))),
              onPressed: () {
                model.showEmailDialog();
              },
              child: const Text(
                'change email address',
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.white),
              )),
        )),
        ListTile(
          title: const Text("Name",
              style: TextStyle(color: Colors.white, fontSize: 20)),
          subtitle: Text(
            model.user.name,
            style: const TextStyle(color: Colors.white),
          ),
          trailing: Container(
            constraints: const BoxConstraints(minWidth: 200),
            child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                    primary: const Color.fromRGBO(0x3b, 0x3b, 0x4f, 1),
                    side: const BorderSide(width: 2, color: Colors.white),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(0))),
                onPressed: () {
                  model.showNameDialog();
                },
                child: const Text(
                  'change your name',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.white),
                )),
          ),
        )
      ],
    );
  }
}
