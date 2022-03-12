import 'package:flutter/material.dart';
import 'package:freecodecamp/ui/views/fcc/login/fcc_login_model.dart';
import 'package:stacked/stacked.dart';

class FccLoginView extends StatelessWidget {
  const FccLoginView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder.reactive(
        viewModelBuilder: () => FccLoginModel(),
        builder: (context, model, child) => Scaffold(
              body: SafeArea(
                child: Column(
                  children: [loginHeader()],
                ),
              ),
            ));
  }

  Column loginHeader() {
    return Column(
      children: [
        Row(
          children: const [
            Expanded(
              child: Text(
                'Login',
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontSize: 36, fontWeight: FontWeight.bold, height: 2.5),
              ),
            ),
          ],
        ),
        Row(
          children: const [
            Expanded(
                child: Text(
              'Login to your freeCodeCamp account',
              textAlign: TextAlign.center,
              style: TextStyle(height: 2.5),
            ))
          ],
        )
      ],
    );
  }
}
