import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:mobile_app_new/auth/ui/login/login_viewmodel.dart';
import 'package:mobile_app_new/routing/learn.dart';
import 'package:mobile_app_new/services/auth_service.dart';
import 'package:mobile_app_new/utils/custom_tab.dart';

final _emailPattern = RegExp(r'^[^\s@]+@[^\s@]+\.[^\s@]+$');
final _otpPattern = RegExp(r'^[0-9]{6}$');

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

  void _showError(String message) => ScaffoldMessenger.of(
    context,
  ).showSnackBar(SnackBar(content: Text(message)));

  void _close() {
    if (context.canPop()) {
      context.pop();
    } else {
      const LearnLandingRoute().go(context);
    }
  }

  void _changeEmail() {
    _otpController.clear();
    ref.read(loginProvider.notifier).changeEmail();
  }

  void _afterLogin(String? error) {
    if (!mounted) return;
    if (error != null) {
      _showError(error);
    } else if (ref.read(authProvider).isLoggedIn) {
      _close();
    }
  }

  Future<void> _loginWithProvider(String connection) async {
    _afterLogin(
      await ref.read(loginProvider.notifier).loginWithProvider(connection),
    );
  }

  Future<void> _sendOtp({bool resend = false}) async {
    final error = await ref
        .read(loginProvider.notifier)
        .sendOtp(_emailController.text.trim());
    if (!mounted) return;
    if (error != null) {
      _showError(error);
    } else if (resend) {
      _showError('A new sign-in code has been sent.');
    }
  }

  Future<void> _verifyOtp() async {
    _afterLogin(
      await ref
          .read(loginProvider.notifier)
          .verifyOtp(_emailController.text.trim(), _otpController.text),
    );
  }

  Future<void> _pasteCode() async {
    final data = await Clipboard.getData(Clipboard.kTextPlain);
    if (!mounted) return;
    final code = data?.text?.trim() ?? '';
    if (_otpPattern.hasMatch(code)) {
      _otpController.text = code;
    } else {
      _showError('Copy the 6-digit code from your email, then try again.');
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(loginProvider);
    final theme = Theme.of(context);
    final colors = theme.colorScheme;

    return PopScope(
      canPop: !state.isLoading,
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            tooltip: state.showOtpField ? 'Change email' : 'Close',
            icon: Icon(state.showOtpField ? Icons.arrow_back : Icons.close),
            onPressed: state.isLoading
                ? null
                : state.showOtpField
                ? _changeEmail
                : _close,
          ),
        ),
        body: Stack(
          children: [
            SafeArea(
              top: false,
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(20, 4, 20, 32),
                child: Align(
                  alignment: Alignment.topCenter,
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 520),
                    child: AutofillGroup(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            width: 64,
                            height: 64,
                            decoration: BoxDecoration(
                              color: state.showOtpField
                                  ? colors.primaryContainer
                                  : colors.primary,
                              borderRadius: BorderRadius.circular(
                                state.showOtpField ? 32 : 20,
                              ),
                            ),
                            child: Icon(
                              state.showOtpField
                                  ? Icons.mail_outline
                                  : Icons.school_outlined,
                              size: 30,
                              color: state.showOtpField
                                  ? colors.primary
                                  : colors.onPrimary,
                            ),
                          ),
                          const SizedBox(height: 18),
                          Text(
                            state.showOtpField
                                ? 'Check your email'
                                : 'Sign in to freeCodeCamp',
                            style: theme.textTheme.headlineMedium,
                          ),
                          const SizedBox(height: 14),
                          if (state.showOtpField) ...[
                            Text.rich(
                              TextSpan(
                                children: [
                                  const TextSpan(
                                    text: 'We sent a 6-digit code to ',
                                  ),
                                  TextSpan(
                                    text: _emailController.text.trim(),
                                    style: const TextStyle(
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                  const TextSpan(text: '.'),
                                ],
                              ),
                              style: theme.textTheme.bodyLarge?.copyWith(
                                color: colors.onSurfaceVariant,
                              ),
                            ),
                            TextButton(
                              onPressed: state.isLoading ? null : _changeEmail,
                              style: TextButton.styleFrom(
                                padding: EdgeInsets.zero,
                              ),
                              child: const Text('Change email'),
                            ),
                            const SizedBox(height: 12),
                            Text(
                              'Sign-in code',
                              style: theme.textTheme.titleMedium,
                            ),
                            const SizedBox(height: 8),
                            _CodeInput(
                              controller: _otpController,
                              enabled: !state.isLoading,
                              incorrect: state.incorrectOtp,
                              onSubmitted: (_) {
                                if (_otpPattern.hasMatch(_otpController.text)) {
                                  _verifyOtp();
                                }
                              },
                            ),
                            const SizedBox(height: 12),
                            OutlinedButton.icon(
                              onPressed: state.isLoading ? null : _pasteCode,
                              icon: const Icon(Icons.content_paste, size: 18),
                              label: const Text('Paste code'),
                            ),
                          ] else ...[
                            Text(
                              'Save your progress, earn certifications and keep your streak across devices.',
                              style: theme.textTheme.bodyLarge?.copyWith(
                                color: colors.onSurfaceVariant,
                              ),
                            ),
                            const SizedBox(height: 24),
                            for (final provider in const [
                              ('Google', 'google-oauth2', 'google'),
                              ('GitHub', 'github', 'github'),
                              ('Apple', 'apple', 'apple'),
                            ]) ...[
                              _ProviderButton(
                                label: 'Continue with ${provider.$1}',
                                logo: 'assets/images/${provider.$3}-logo.png',
                                monochrome: provider.$3 != 'google',
                                onPressed: state.isLoading
                                    ? null
                                    : () => _loginWithProvider(provider.$2),
                              ),
                              const SizedBox(height: 12),
                            ],
                            Padding(
                              padding: const EdgeInsets.symmetric(vertical: 8),
                              child: Row(
                                children: [
                                  const Expanded(child: Divider()),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 12,
                                    ),
                                    child: Text(
                                      'or use your email',
                                      style: theme.textTheme.bodyMedium
                                          ?.copyWith(
                                            color: colors.onSurfaceVariant,
                                          ),
                                    ),
                                  ),
                                  const Expanded(child: Divider()),
                                ],
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text('Email', style: theme.textTheme.titleMedium),
                            const SizedBox(height: 8),
                            TextField(
                              enabled: !state.isLoading,
                              controller: _emailController,
                              keyboardType: TextInputType.emailAddress,
                              textInputAction: TextInputAction.done,
                              autofillHints: const [AutofillHints.email],
                              autocorrect: false,
                              decoration: const InputDecoration(
                                hintText: 'you@example.com',
                              ),
                              onSubmitted: (_) {
                                if (_emailPattern.hasMatch(
                                  _emailController.text.trim(),
                                )) {
                                  _sendOtp();
                                }
                              },
                            ),
                          ],
                          const SizedBox(height: 16),
                          ListenableBuilder(
                            listenable: Listenable.merge([
                              _emailController,
                              _otpController,
                            ]),
                            builder: (context, _) {
                              final canSubmit =
                                  !state.isLoading &&
                                  (state.showOtpField
                                      ? _otpPattern.hasMatch(
                                          _otpController.text,
                                        )
                                      : _emailPattern.hasMatch(
                                          _emailController.text.trim(),
                                        ));
                              return SizedBox(
                                width: double.infinity,
                                child: FilledButton(
                                  style: FilledButton.styleFrom(
                                    minimumSize: const Size.fromHeight(52),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                  ),
                                  onPressed: canSubmit
                                      ? state.showOtpField
                                            ? _verifyOtp
                                            : _sendOtp
                                      : null,
                                  child: Text(
                                    state.showOtpField
                                        ? 'Sign in'
                                        : 'Email me a sign-in code',
                                  ),
                                ),
                              );
                            },
                          ),
                          const SizedBox(height: 20),
                          if (state.showOtpField)
                            Center(
                              child: Wrap(
                                crossAxisAlignment: WrapCrossAlignment.center,
                                children: [
                                  Text(
                                    "Didn't get it?",
                                    style: theme.textTheme.bodyMedium,
                                  ),
                                  TextButton(
                                    onPressed: state.isLoading
                                        ? null
                                        : () => _sendOtp(resend: true),
                                    child: const Text('Resend code'),
                                  ),
                                ],
                              ),
                            )
                          else
                            Text.rich(
                              TextSpan(
                                children: [
                                  const TextSpan(
                                    text:
                                        'freeCodeCamp is free and your account is private by default. '
                                        'We use your email address to connect you to your account. '
                                        'You must be at least 13 years old to create an account. '
                                        'By continuing, you agree to our ',
                                  ),
                                  TextSpan(
                                    text: 'Terms of Service',
                                    style: TextStyle(
                                      color: colors.primary,
                                      decoration: TextDecoration.underline,
                                    ),
                                    recognizer: _termsRecognizer,
                                  ),
                                  const TextSpan(text: ' and '),
                                  TextSpan(
                                    text: 'Privacy Policy',
                                    style: TextStyle(
                                      color: colors.primary,
                                      decoration: TextDecoration.underline,
                                    ),
                                    recognizer: _privacyRecognizer,
                                  ),
                                  const TextSpan(text: '.'),
                                ],
                              ),
                              style: theme.textTheme.bodySmall?.copyWith(
                                height: 1.6,
                              ),
                            ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
            if (state.isLoading) ...[
              const ModalBarrier(dismissible: false, color: Colors.black38),
              const Center(child: CircularProgressIndicator()),
            ],
          ],
        ),
      ),
    );
  }
}

/// A single accessible text field keeps paste, selection and OS autofill intact;
/// the six cells below only present its value.
class _CodeInput extends StatefulWidget {
  const _CodeInput({
    required this.controller,
    required this.enabled,
    required this.incorrect,
    required this.onSubmitted,
  });
  final TextEditingController controller;
  final bool enabled;
  final bool incorrect;
  final ValueChanged<String> onSubmitted;

  @override
  State<_CodeInput> createState() => _CodeInputState();
}

class _CodeInputState extends State<_CodeInput> {
  final _focusNode = FocusNode();

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Stack(
          children: [
            ListenableBuilder(
              listenable: Listenable.merge([widget.controller, _focusNode]),
              builder: (context, _) => ExcludeSemantics(
                child: Row(
                  children: [
                    for (var i = 0; i < 6; i++) ...[
                      if (i > 0) const SizedBox(width: 8),
                      Expanded(
                        child: Container(
                          height: 58,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            color: colors.surface,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: widget.incorrect
                                  ? colors.error
                                  : _focusNode.hasFocus &&
                                        i == widget.controller.text.length
                                  ? colors.primary
                                  : colors.outlineVariant,
                            ),
                          ),
                          child: Text(
                            i < widget.controller.text.length
                                ? widget.controller.text[i]
                                : '',
                            style: Theme.of(context).textTheme.headlineSmall,
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ),
            Positioned.fill(
              child: Opacity(
                opacity: 0,
                alwaysIncludeSemantics: true,
                child: TextField(
                  controller: widget.controller,
                  focusNode: _focusNode,
                  enabled: widget.enabled,
                  autofocus: true,
                  keyboardType: TextInputType.number,
                  textInputAction: TextInputAction.done,
                  autofillHints: const [AutofillHints.oneTimeCode],
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                    LengthLimitingTextInputFormatter(6),
                  ],
                  decoration: const InputDecoration(
                    labelText: '6-digit sign-in code',
                  ),
                  onSubmitted: widget.onSubmitted,
                ),
              ),
            ),
          ],
        ),
        if (widget.incorrect)
          Padding(
            padding: const EdgeInsets.only(top: 8),
            child: Text(
              'That code is not valid. Check your latest email and try again.',
              style: TextStyle(color: colors.error),
            ),
          ),
      ],
    );
  }
}

class _ProviderButton extends StatelessWidget {
  const _ProviderButton({
    required this.label,
    required this.logo,
    required this.monochrome,
    required this.onPressed,
  });

  final String label;
  final String logo;
  final bool monochrome;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) => SizedBox(
    width: double.infinity,
    child: OutlinedButton.icon(
      style: OutlinedButton.styleFrom(
        minimumSize: const Size.fromHeight(52),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
      onPressed: onPressed,
      icon: Image.asset(
        logo,
        cacheWidth: 96,
        height: 22,
        width: 22,
        color: monochrome ? Theme.of(context).colorScheme.onSurface : null,
      ),
      label: Text(label),
    ),
  );
}
