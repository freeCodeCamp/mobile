import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:freecodecamp/extensions/i18n_extension.dart';
import 'package:freecodecamp/ui/theme/fcc_theme.dart';
import 'package:freecodecamp/ui/views/login/native_login_viewmodel.dart';
import 'package:freecodecamp/ui/widgets/drawer_widget/drawer_widget_view.dart';
import 'package:stacked/stacked.dart';
import 'package:url_launcher/url_launcher.dart';

class NativeLoginView extends StatelessWidget {
  const NativeLoginView({super.key, this.fromButton = false});

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

    ButtonStyle ctaButtonStyle = ElevatedButton.styleFrom(
      backgroundColor: FccSemanticColors.backgroundCta,
      foregroundColor: FccSemanticColors.foregroundCta,
      disabledBackgroundColor:
          Color(0xCCFFC300), // backgroundCta with 80% opacity
      disabledForegroundColor: FccSemanticColors.foregroundCta,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(0),
      ),
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
                            hintText: context.t.email_enter_sign_in_code,
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
                            style: ctaButtonStyle.copyWith(
                              padding: const WidgetStatePropertyAll(
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
                              style: TextStyle(
                                fontSize: 20,
                              ),
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
                            style: ctaButtonStyle,
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
                                  style: TextStyle(
                                    fontSize: 20,
                                  ),
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
                          style: TextStyle(
                            color: Colors.white.withValues(alpha: 0.87),
                          ),
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
                          style: TextStyle(
                            color: Colors.white.withValues(alpha: 0.87),
                          ),
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
                      child: RichText(
                        textAlign: TextAlign.center,
                        text: TextSpan(
                          style: TextStyle(
                            color: Colors.white.withValues(alpha: 0.87),
                          ),
                          children: [
                            TextSpan(
                              text:
                                  "By continuing, you indicate that you have read and agree to freeCodeCamp.org's ",
                            ),
                            TextSpan(
                              text: 'Terms of Service',
                              style: const TextStyle(
                                decoration: TextDecoration.underline,
                              ),
                              recognizer: TapGestureRecognizer()
                                ..onTap = () {
                                  launchUrl(
                                    Uri.parse(
                                      'https://www.freecodecamp.org/news/terms-of-service',
                                    ),
                                  );
                                },
                            ),
                            TextSpan(
                              text: ' and ',
                            ),
                            TextSpan(
                              text: 'Privacy Policy',
                              style: const TextStyle(
                                decoration: TextDecoration.underline,
                              ),
                              recognizer: TapGestureRecognizer()
                                ..onTap = () {
                                  launchUrl(
                                    Uri.parse(
                                      'https://www.freecodecamp.org/news/privacy-policy',
                                    ),
                                  );
                                },
                            ),
                            TextSpan(
                              text: '.',
                            ),
                          ],
                        ),
                      ),
                    )),
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
