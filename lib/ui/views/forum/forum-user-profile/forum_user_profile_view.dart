import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:freecodecamp/ui/views/forum/forum-user-profile/forum_user_profile_viewmodel.dart';
import 'package:stacked/stacked.dart';

class ForumUserProfileView extends StatelessWidget {
  const ForumUserProfileView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder.reactive(
        viewModelBuilder: () => ForumUserProfileViewModel(),
        builder: (context, model, child) => Scaffold(
              appBar: AppBar(
                backgroundColor: const Color(0xFF0a0a23),
                centerTitle: true,
                title: const Text(
                  'Your forum profile',
                  style: TextStyle(color: Colors.white),
                ),
              ),
              backgroundColor: const Color.fromRGBO(0x2A, 0x2A, 0x40, 1),
              body: Container(),
            ));
  }
}
