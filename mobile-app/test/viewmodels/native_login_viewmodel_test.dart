import 'package:auth0_flutter/auth0_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:freecodecamp/app/app.locator.dart';
import 'package:freecodecamp/l10n/app_localizations.dart';
import 'package:freecodecamp/service/authentication/authentication_service.dart';
import 'package:freecodecamp/service/developer_service.dart';
import 'package:freecodecamp/ui/views/login/native_login_viewmodel.dart';
import 'package:mockito/mockito.dart';
import 'package:stacked_services/stacked_services.dart';

import '../helpers/test_helpers.mocks.dart';

class _MockSnackbarService extends Mock implements SnackbarService {}

const _authChannel = MethodChannel('auth0.com/auth0_flutter/auth');

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late MockAuthenticationService authenticationService;
  late _MockSnackbarService snackbarService;
  late NativeLoginViewModel viewModel;
  Map<dynamic, dynamic>? passwordlessRequest;
  PlatformException? passwordlessError;

  setUp(() {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(_authChannel, (call) async {
      passwordlessRequest = call.arguments as Map<dynamic, dynamic>;
      if (passwordlessError != null) {
        throw passwordlessError!;
      }
      return null;
    });

    authenticationService = MockAuthenticationService();
    snackbarService = _MockSnackbarService();
    when(authenticationService.auth0)
        .thenReturn(Auth0('example.auth0.com', 'client-id'));
    when(authenticationService.snackbar).thenReturn(snackbarService);

    locator.reset();
    locator.registerSingleton<AuthenticationService>(authenticationService);
    locator.registerSingleton<DeveloperService>(DeveloperService());
    viewModel = NativeLoginViewModel();
    viewModel.emailController.text = 'camper@example.com';
  });

  tearDown(() {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(_authChannel, null);
    locator.reset();
    viewModel.emailController.dispose();
    viewModel.otpController.dispose();
  });

  Future<BuildContext> buildContext(WidgetTester tester) async {
    late BuildContext context;

    await tester.pumpWidget(
      MaterialApp(
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: Builder(
          builder: (buildContext) {
            context = buildContext;
            return const SizedBox();
          },
        ),
      ),
    );
    await tester.pump();

    return context;
  }

  testWidgets('shows the OTP field after Auth0 sends a code', (tester) async {
    final context = await buildContext(tester);

    await viewModel.sendOTPtoEmail(context);

    expect(viewModel.showOTPfield, isTrue);
    expect(passwordlessRequest?['email'], 'camper@example.com');
    expect(
        passwordlessRequest?['passwordlessType'], PasswordlessType.code.name);
    verifyZeroInteractions(snackbarService);
  });

  testWidgets('shows an error and returns to the email step when Auth0 fails',
      (tester) async {
    passwordlessError = PlatformException(
      code: 'email_provider_error',
      message: 'Email provider failed',
    );
    final context = await buildContext(tester);

    await viewModel.sendOTPtoEmail(context);

    expect(viewModel.showOTPfield, isFalse);
    verify(snackbarService.showSnackbar(
      title: 'Error',
      message: 'We couldn\'t send a sign-in code. Please try again.',
    )).called(1);
  });
}
