import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:mobile_app_new/auth/ui/login/login_viewmodel.dart';
import 'package:mobile_app_new/fcc_theme.dart';
import 'package:mobile_app_new/services/auth_service.dart';
import 'package:mobile_app_new/utils/custom_tab.dart';
import 'package:mobile_app_new/widgets/section_divider.dart';

final _emailPattern = RegExp(
  r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$',
);
final _otpPattern = RegExp(r'^[0-9]{6}$');

const _noticeStyle = TextStyle(color: Color(0xDEFFFFFF));

class LoginView extends ConsumerStatefulWidget {
  const LoginView({super.key});

  @override
  ConsumerState<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends ConsumerState<LoginView> {
  final _emailController = TextEditingController();
  final _otpController = TextEditingController();
  final _termsRecognizer = TapGestureRecognizer()
    ..onTap = () =>
        openInCustomTab('https://www.freecodecamp.org/news/terms-of-service');
  final _privacyRecognizer = TapGestureRecognizer()
    ..onTap = () =>
        openInCustomTab('https://www.freecodecamp.org/news/privacy-policy');

  @override
  void dispose() {
    _emailController.dispose();
    _otpController.dispose();
    _termsRecognizer.dispose();
    _privacyRecognizer.dispose();
    super.dispose();
  }

  void _showError(String message) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message)));
  }

  void _afterLogin(String? error) {
    if (!mounted) return;
    if (error != null) {
      _showError(error);
    } else if (ref.read(authProvider).isLoggedIn) {
      context.pop();
    }
  }

  Future<void> _loginWithProvider(String connection) async {
    _afterLogin(
      await ref.read(loginProvider.notifier).loginWithProvider(connection),
    );
  }

  Future<void> _sendOtp() async {
    final error = await ref
        .read(loginProvider.notifier)
        .sendOtp(_emailController.text);
    if (mounted && error != null) _showError(error);
  }

  Future<void> _verifyOtp() async {
    _afterLogin(
      await ref
          .read(loginProvider.notifier)
          .verifyOtp(_emailController.text, _otpController.text),
    );
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(loginProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('LOG IN')),
      body: Stack(
        children: [
          SingleChildScrollView(
            padding: const EdgeInsets.only(top: 16),
            child: Column(
              children: [
                _ProviderButton(
                  label: 'Continue with Google',
                  logo: 'assets/images/google-logo.png',
                  onPressed: () => _loginWithProvider('google-oauth2'),
                ),
                _ProviderButton(
                  label: 'Continue with GitHub',
                  logo: 'assets/images/github-logo.png',
                  onPressed: () => _loginWithProvider('github'),
                ),
                _ProviderButton(
                  label: 'Continue with Apple',
                  logo: 'assets/images/apple-logo.png',
                  onPressed: () => _loginWithProvider('apple'),
                ),
                sectionDivider,
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: TextFormField(
                    enabled: !state.showOtpField,
                    controller: _emailController,
                    keyboardType: TextInputType.emailAddress,
                    decoration: const InputDecoration(
                      hintText: 'Email',
                      border: OutlineInputBorder(
                        borderSide: BorderSide(width: 2, color: Colors.white),
                      ),
                    ),
                  ),
                ),
                if (state.showOtpField)
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: TextFormField(
                      autofocus: true,
                      controller: _otpController,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        hintText: 'Enter sign in code',
                        errorText: state.incorrectOtp
                            ? 'The code you entered is not valid. Please check the last OTP you received and try again.'
                            : null,
                        errorMaxLines: 5,
                        border: const OutlineInputBorder(
                          borderSide: BorderSide(width: 2, color: Colors.white),
                        ),
                      ),
                    ),
                  ),
                ListenableBuilder(
                  listenable: Listenable.merge([
                    _emailController,
                    _otpController,
                  ]),
                  builder: (context, _) {
                    final canSubmit = state.showOtpField
                        ? _otpPattern.hasMatch(_otpController.text)
                        : _emailPattern.hasMatch(_emailController.text);

                    return _CtaButton(
                      onPressed: canSubmit
                          ? (state.showOtpField ? _verifyOtp : _sendOtp)
                          : null,
                    );
                  },
                ),
                sectionDivider,
                const Padding(
                  padding: EdgeInsets.all(8),
                  child: Text(
                    'freeCodeCamp is free and your account is private by default. We use your email address to connect you to your account.',
                    textAlign: TextAlign.center,
                    style: _noticeStyle,
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.all(8),
                  child: Text(
                    'You must be at least 13 years old to create an account on freeCodeCamp.',
                    textAlign: TextAlign.center,
                    style: _noticeStyle,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8),
                  child: Text.rich(
                    textAlign: TextAlign.center,
                    style: _noticeStyle,
                    TextSpan(
                      children: [
                        const TextSpan(
                          text:
                              "By continuing, you indicate that you have read and agree to freeCodeCamp.org's ",
                        ),
                        TextSpan(
                          text: 'Terms of Service',
                          style: const TextStyle(
                            decoration: TextDecoration.underline,
                          ),
                          recognizer: _termsRecognizer,
                        ),
                        const TextSpan(text: ' and '),
                        TextSpan(
                          text: 'Privacy Policy',
                          style: const TextStyle(
                            decoration: TextDecoration.underline,
                          ),
                          recognizer: _privacyRecognizer,
                        ),
                        const TextSpan(text: '.'),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          if (state.isLoading)
            const ModalBarrier(dismissible: false, color: Colors.black54),
          if (state.isLoading) const Center(child: CircularProgressIndicator()),
        ],
      ),
    );
  }
}

class _ProviderButton extends StatelessWidget {
  const _ProviderButton({
    required this.label,
    required this.logo,
    required this.onPressed,
  });

  final String label;
  final String logo;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      constraints: const BoxConstraints(minHeight: 50),
      margin: const EdgeInsets.all(16),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.white,
          disabledBackgroundColor: Colors.grey,
          shape: const RoundedRectangleBorder(),
          side: const BorderSide(width: 3, color: Colors.black),
        ),
        onPressed: onPressed,
        child: Row(
          children: [
            Image.asset(logo, height: 25, width: 25),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(8),
                child: Text(
                  label,
                  style: const TextStyle(fontSize: 20, color: Colors.black),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _CtaButton extends StatelessWidget {
  const _CtaButton({required this.onPressed});

  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      constraints: const BoxConstraints(minHeight: 50),
      margin: const EdgeInsets.all(16),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: FccSemanticColors.backgroundCta,
          foregroundColor: FccSemanticColors.foregroundCta,
          // NOTE: backgroundCta at 80% opacity.
          disabledBackgroundColor: const Color(0xCCFFC300),
          disabledForegroundColor: FccSemanticColors.foregroundCta,
          shape: const RoundedRectangleBorder(),
        ),
        onPressed: onPressed,
        child: const Padding(
          padding: EdgeInsets.all(8),
          child: Text(
            'Submit and sign in to freeCodeCamp',
            style: TextStyle(fontSize: 20),
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }
}
