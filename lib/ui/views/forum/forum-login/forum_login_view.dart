import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:freecodecamp/ui/views/forum/forum-login/forum_login_viewmodel.dart';
import 'package:stacked/stacked.dart';

class ForumLoginView extends StatelessWidget {
  const ForumLoginView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder.reactive(
        viewModelBuilder: () => ForumLoginModel(),
        builder: (context, model, child) => const Scaffold(
              backgroundColor: Color.fromRGBO(0x2A, 0x2A, 0x40, 1),
              body: Center(
                child: Text(
                  'Coming soon',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ));
  }
}
