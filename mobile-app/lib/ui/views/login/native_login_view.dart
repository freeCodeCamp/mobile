import 'package:flutter/material.dart';
import 'package:freecodecamp/extensions/i18n_extension.dart';
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
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(0),
      ),
      side: const BorderSide(
        width: 3,
        color: Colors.black,
      ),
    );

    TextStyle textStyle = const TextStyle(
      fontSize: 20,
      color: Colors.black,
    );

    return ViewModelBuilder<NativeLoginViewModel>.reactive(
      viewModelBuilder: () => NativeLoginViewModel(),
      onViewModelReady: (viewModel) => viewModel.init(),
      builder: (context, model, child) => Scaffold(
        appBar: AppBar(
          title: Text(context.t.login),
        ),
        drawer: fromButton ? null : const DrawerWidgetView(),
        body: SingleChildScrollView(
          child: Container(
            margin: const EdgeInsets.only(top: 16),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Expanded(
                      child: Container(
                        constraints: const BoxConstraints(minHeight: 50),
                        margin: const EdgeInsets.all(16),
                        child: ElevatedButton(
                          style: buttonStyle,
                          onPressed: () {
                            model.auth.login(context, 'google-oauth2');
                          },
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Image.asset(
                                'assets/images/google-logo.png',
                                height: 25,
                                width: 25,
                              ),
                              Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(
                                    context.t.login_with_google,
                                    style: textStyle,
                                  ),
                                ),
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
                        constraints: const BoxConstraints(minHeight: 50),
                        margin: const EdgeInsets.all(16),
                        child: ElevatedButton(
                          style: buttonStyle,
                          onPressed: () {
                            model.auth.login(context, 'github');
                          },
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Image.asset(
                                'assets/images/github-logo.png',
                                height: 25,
                                width: 25,
                              ),
                              Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(
                                    context.t.login_with_github,
                                    style: textStyle,
                                  ),
                                ),
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
                        constraints: const BoxConstraints(minHeight: 50),
                        child: ElevatedButton(
                          style: buttonStyle,
                          onPressed: () {
                            model.auth.login(context, 'apple');
                          },
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Image.asset(
                                'assets/images/apple-logo.png',
                                height: 25,
                                width: 25,
                              ),
                              Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(
                                    context.t.login_with_apple,
                                    style: textStyle,
                                  ),
                                ),
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
                    decoration: InputDecoration(
                      hintText: context.t.email,
                      border: const OutlineInputBorder(
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
                            hintText: context.t.email_sign_in_code,
                            errorText: model.incorrectOTP
                                ? context.t.email_invalid_code
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
                    if (model.showOTPfield)
                      Expanded(
                        child: Container(
                          margin: const EdgeInsets.all(16),
                          child: ElevatedButton(
                            style: buttonStyle.copyWith(
                              padding: const MaterialStatePropertyAll(
                                EdgeInsets.symmetric(vertical: 8),
                              ),
                            ),
                            onPressed: model.otpFieldIsValid
                                ? () {
                                    model.verifyOTP(context);
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
                    else
                      Expanded(
                        child: Container(
                          margin: const EdgeInsets.all(16),
                          constraints: const BoxConstraints(minHeight: 50),
                          child: ElevatedButton(
                            style: buttonStyle,
                            onPressed: model.emailFieldIsValid
                                ? () {
                                    model.sendOTPtoEmail();
                                  }
                                : null,
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Align(
                                child: Text(
                                  context.t.email_submit_code,
                                  style: textStyle,
                                  textAlign: TextAlign.center,
                                ),
                              ),
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
                          context.t.login_data_message,
                          textAlign: TextAlign.center,
                          style:
                              TextStyle(color: Colors.white.withOpacity(0.87)),
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
                          context.t.login_age_message,
                          textAlign: TextAlign.center,
                          style:
                              TextStyle(color: Colors.white.withOpacity(0.87)),
                        ),
                      ),
                    )
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
