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
                  children: [
                    loginHeader(),
                    loginButton('Google'),
                    loginButton('GitHub'),
                    orWidget(),
                    inputField(),
                    cancelButton()
                  ],
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
              style: TextStyle(height: 2.5, fontSize: 20),
            ))
          ],
        )
      ],
    );
  }

  Widget loginButton(String service) {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          Container(
            decoration: BoxDecoration(
                border: Border.all(width: 2, color: Colors.white)),
            width: 300,
            height: 50,
            child: ElevatedButton(
                style: TextButton.styleFrom(
                  backgroundColor: const Color.fromRGBO(0x3b, 0x3b, 0x4f, 1),
                ),
                onPressed: () {},
                child: Text('Continue with $service')),
          )
        ],
      ),
    );
  }

  Column orWidget() {
    return Column(
      children: [
        Stack(
          alignment: Alignment.center,
          children: const [
            SizedBox(
                width: 300,
                child: Divider(
                  color: Colors.white,
                  thickness: 1,
                )),
            Text(
              'or',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 20,
                backgroundColor: Color.fromRGBO(0x2A, 0x2A, 0x40, 1),
              ),
            )
          ],
        )
      ],
    );
  }

  Widget inputField() {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.only(top: 16, bottom: 16),
          width: 300,
          child: TextField(
            style: const TextStyle(color: Colors.white),
            decoration: InputDecoration(
                enabledBorder: const OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.white, width: 2)),
                border:
                    OutlineInputBorder(borderRadius: BorderRadius.circular(0)),
                label: const Text(
                  'Email',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                )),
          ),
        ),
        Container(
          decoration:
              BoxDecoration(border: Border.all(width: 2, color: Colors.white)),
          width: 300,
          height: 50,
          child: ElevatedButton(
              style: TextButton.styleFrom(
                backgroundColor: const Color.fromRGBO(0x3b, 0x3b, 0x4f, 1),
              ),
              onPressed: () {},
              child: const Text('Email a sign in code')),
        )
      ],
    );
  }

  Widget cancelButton() {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.only(bottom: 64),
        child: Align(
          alignment: Alignment.bottomCenter,
          child: Container(
            decoration: BoxDecoration(
                border: Border.all(width: 2, color: Colors.white)),
            width: 300,
            height: 50,
            padding: const EdgeInsets.only(),
            child: ElevatedButton(
                style: TextButton.styleFrom(
                  backgroundColor: const Color.fromRGBO(0x3b, 0x3b, 0x4f, 1),
                ),
                onPressed: () {},
                child: const Text('continue without logging in')),
          ),
        ),
      ),
    );
  }
}
