import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/rendering.dart';
import 'package:freecodecamp/ui/views/forum/forum-create-post/forum_create_post_view.dart';
import 'package:freecodecamp/ui/views/forum/forum-login/forum_login_viewmodel.dart';
import 'package:stacked/stacked.dart';

class ForumLoginView extends StatelessWidget {
  const ForumLoginView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<ForumLoginModel>.reactive(
        viewModelBuilder: () => ForumLoginModel(),
        onModelReady: (model) async => model.initState(),
        builder: (context, model, child) => Scaffold(
            resizeToAvoidBottomInset: true,
            backgroundColor: const Color.fromRGBO(0x2A, 0x2A, 0x40, 1),
            body: SingleChildScrollView(
              child: Column(children: [
                model.isLoggedIn
                    ? const ForumCreatePostViewmodel()
                    : loginForum(context, model)
              ]),
            )));
  }
}

Column loginForum(context, ForumLoginModel model) {
  return Column(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      Row(mainAxisAlignment: MainAxisAlignment.center, children: const [
        Padding(
          padding: EdgeInsets.only(top: 100),
          child: Text(
            'Login to your forum account',
            style: TextStyle(
                color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold),
          ),
        )
      ]),
      Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            width: MediaQuery.of(context).size.width * 0.75,
            height: 100,
            child: Padding(
              padding: const EdgeInsets.only(top: 16.0),
              child: TextField(
                controller: model.nameController,
                style: const TextStyle(color: Colors.white),
                decoration: InputDecoration(
                    enabledBorder: const OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.white, width: 2)),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(0)),
                    errorText:
                        model.hasUsernameError ? model.errorMessage : null,
                    label: const Text(
                      'Name',
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold),
                    )),
              ),
            ),
          )
        ],
      ),
      Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            width: MediaQuery.of(context).size.width * 0.75,
            height: 100,
            child: Padding(
              padding: const EdgeInsets.only(top: 16.0),
              child: TextField(
                controller: model.passwordController,
                style: const TextStyle(color: Colors.white),
                obscureText: true,
                enableSuggestions: false,
                autocorrect: false,
                decoration: InputDecoration(
                    errorText: model.hasPasswordError || model.hasAuthError
                        ? model.errorMessage
                        : null,
                    enabledBorder: const OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.white, width: 2)),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(0)),
                    label: const Text(
                      'Password',
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold),
                    )),
              ),
            ),
          )
        ],
      ),
      Padding(
        padding: const EdgeInsets.only(top: 8.0),
        child: SizedBox(
          width: MediaQuery.of(context).size.width * 0.75,
          height: 50,
          child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                  primary: const Color.fromRGBO(0x3b, 0x3b, 0x4f, 1),
                  side: const BorderSide(width: 2, color: Colors.white),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(0))),
              onPressed: () {
                model.login(
                    model.nameController.text, model.passwordController.text);
              },
              child: const Text(
                'LOGIN',
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.white),
              )),
        ),
      ),
    ],
  );
}
