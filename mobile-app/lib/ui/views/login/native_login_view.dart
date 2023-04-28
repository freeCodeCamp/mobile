import 'package:flutter/material.dart';
import 'package:freecodecamp/ui/views/login/native_login_viewmodel.dart';
import 'package:stacked/stacked.dart';

class NativeLoginView extends StatelessWidget {
  const NativeLoginView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    ButtonStyle buttonStyle = ElevatedButton.styleFrom(
      backgroundColor: const Color.fromRGBO(0x3b, 0x3b, 0x4f, 1),
    );

    BoxDecoration outerDecoration = BoxDecoration(
      border: Border.all(
        width: 2,
        color: Colors.white,
      ),
    );

    TextStyle textStyle = const TextStyle(fontSize: 20);

    return ViewModelBuilder<NativeLoginViewModel>.reactive(
      viewModelBuilder: () => NativeLoginViewModel(),
      builder: (context, model, child) => Scaffold(
        appBar: AppBar(
          title: const Text('LOGIN'),
        ),
        body: Container(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(
                    child: Container(
                      height: 50,
                      margin: const EdgeInsets.all(16),
                      decoration: outerDecoration,
                      child: ElevatedButton(
                        style: buttonStyle,
                        onPressed: () {},
                        child: Text(
                          'Continue with Google',
                          style: textStyle,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  Expanded(
                    child: Container(
                      height: 50,
                      margin: const EdgeInsets.all(16),
                      decoration: outerDecoration,
                      child: ElevatedButton(
                        style: buttonStyle,
                        onPressed: () {},
                        child: Text(
                          'Continue with GitHub',
                          style: textStyle,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  Expanded(
                    child: Container(
                      margin: const EdgeInsets.all(16),
                      decoration: outerDecoration,
                      height: 50,
                      child: ElevatedButton(
                        style: buttonStyle,
                        onPressed: () {},
                        child: Text(
                          'Continue with Apple',
                          style: textStyle,
                        ),
                      ),
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
