import 'package:flutter/material.dart';
import 'package:freecodecamp/ui/views/login/native_login_viewmodel.dart';
import 'package:freecodecamp/ui/widgets/drawer_widget/drawer_widget_view.dart';
import 'package:stacked/stacked.dart';

class NativeLoginView extends StatelessWidget {
  const NativeLoginView({Key? key, this.fromButton = false}) : super(key: key);

  final bool fromButton;

  @override
  Widget build(BuildContext context) {
    ButtonStyle buttonStyle = ElevatedButton.styleFrom(
      backgroundColor: Colors.white,
      disabledBackgroundColor: Colors.grey,
    );

    BoxDecoration outerDecoration = BoxDecoration(
      border: Border.all(
        width: 3,
        color: Colors.black,
      ),
      borderRadius: BorderRadius.circular(0),
    );

    TextStyle textStyle = const TextStyle(fontSize: 20, color: Colors.black);

    return ViewModelBuilder<NativeLoginViewModel>.reactive(
      viewModelBuilder: () => NativeLoginViewModel(),
      onViewModelReady: (viewModel) => viewModel.init(),
      builder: (context, model, child) => Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          title: const Text('LOGIN'),
        ),
        drawer: fromButton ? null : const DrawerWidgetView(),
        body: Container(
          margin: const EdgeInsets.only(top: 16),
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
                        onPressed: () {
                          model.auth.login(context, 'google-oauth2');
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Image.asset(
                                'assets/images/google-logo.png',
                                height: 25,
                                width: 25,
                              ),
                            ),
                            Text(
                              'Continue with Google',
                              style: textStyle,
                            ),
                          ],
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
                        onPressed: () {
                          model.auth.login(context, 'github');
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Image.asset(
                                'assets/images/github-logo.png',
                                height: 25,
                                width: 25,
                              ),
                            ),
                            Text(
                              'Continue with GitHub',
                              style: textStyle,
                            ),
                          ],
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
                        onPressed: () {
                          model.auth.login(context, 'apple');
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Image.asset(
                                'assets/images/apple-logo.png',
                                height: 25,
                                width: 25,
                              ),
                            ),
                            Text(
                              'Continue with Apple',
                              style: textStyle,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              buildDivider(),
              Container(
                padding: const EdgeInsets.all(16),
                child: TextFormField(
                  enabled: !model.showOTPfield,
                  controller: model.emailController,
                  keyboardType: TextInputType.emailAddress,
                  decoration: const InputDecoration(
                    hintText: 'email',
                    border: OutlineInputBorder(
                      borderSide: BorderSide(width: 2, color: Colors.white),
                    ),
                  ),
                ),
              ),
              model.showOTPfield
                  ? Container(
                      padding: const EdgeInsets.all(16),
                      child: TextFormField(
                        autofocus: model.showOTPfield,
                        controller: model.otpController,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          hintText: 'Enter sign in code',
                          errorText: model.incorrectOTP
                              ? 'The code you entered is not valid. Please check the last OTP you received and try again.'
                              : null,
                          errorMaxLines: 5,
                          border: const OutlineInputBorder(
                            borderSide:
                                BorderSide(width: 2, color: Colors.white),
                          ),
                        ),
                      ),
                    )
                  : Container(),
              Row(
                children: [
                  model.showOTPfield
                      ? Expanded(
                          child: Container(
                            margin: const EdgeInsets.all(16),
                            decoration: outerDecoration,
                            child: ElevatedButton(
                              style: buttonStyle.copyWith(
                                padding: const MaterialStatePropertyAll(
                                  EdgeInsets.symmetric(vertical: 8),
                                ),
                              ),
                              onPressed: model.otpFieldIsValid
                                  ? () {
                                      model.verifyOTP();
                                    }
                                  : null,
                              child: Text(
                                'Submit and sign in to freeCodeCamp',
                                style: textStyle,
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ),
                        )
                      : Expanded(
                          child: Container(
                            margin: const EdgeInsets.all(16),
                            decoration: outerDecoration,
                            height: 50,
                            child: ElevatedButton(
                              style: buttonStyle,
                              onPressed: model.emailFieldIsValid
                                  ? () {
                                      model.sendOTPtoEmail();
                                    }
                                  : null,
                              child: Text(
                                'Email a sign in code',
                                style: textStyle,
                              ),
                            ),
                          ),
                        ),
                ],
              ),
              buildDivider(),
              Row(
                children: [
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        'freeCodeCamp is free and your account is private by default. We use your email address to connect you to your account.',
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Colors.white.withOpacity(0.87)),
                      ),
                    ),
                  )
                ],
              ),
              Row(
                children: [
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        'You must be at least 13 years old to create an account on freeCodeCamp.',
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Colors.white.withOpacity(0.87)),
                      ),
                    ),
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
