import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:freecodecamp/auth/models/user_model.dart';
import 'package:freecodecamp/auth/services/session_service.dart';
import 'package:freecodecamp/auth/ui/login/login_view.dart';
import 'package:freecodecamp/fcc_theme.dart';
import 'package:freecodecamp/services/auth_service.dart';

const _invalidCodeMessage =
    'That code is not valid. Check your latest email and try again.';

class _RejectingAuth extends AuthNotifier {
  @override
  Future<FccUserModel?> build() async => null;

  @override
  Future<void> loginWithEmailOtp(String email, String otp) async {
    throw InvalidOtpException();
  }
}

class _FakeSessionService extends Fake implements AuthSessionService {
  @override
  Future<void> sendEmailOtp(String email) async {}
}

Future<void> _showRejectedCode(WidgetTester tester) async {
  tester.view.physicalSize = const Size(800, 1600);
  tester.view.devicePixelRatio = 1;
  addTearDown(tester.view.resetPhysicalSize);
  addTearDown(tester.view.resetDevicePixelRatio);
  await tester.pumpWidget(
    ProviderScope(
      overrides: [
        authProvider.overrideWith(_RejectingAuth.new),
        authSessionServiceProvider.overrideWithValue(_FakeSessionService()),
      ],
      child: MaterialApp(theme: FccTheme.themeDark, home: const LoginView()),
    ),
  );
  await tester.pumpAndSettle();

  await tester.enterText(find.byType(TextField), 'learner@example.com');
  await tester.pump();
  await tester.tap(find.byType(FilledButton));
  await tester.pumpAndSettle();

  await tester.enterText(find.byType(TextField), '123456');
  await tester.pump();
  await tester.tap(find.byType(FilledButton));
  await tester.pumpAndSettle();
}

void main() {
  testWidgets('should show the error after a rejected code', (tester) async {
    await _showRejectedCode(tester);

    expect(find.text(_invalidCodeMessage), findsOneWidget);
  });

  testWidgets('should clear the error when a new code is entered', (
    tester,
  ) async {
    await _showRejectedCode(tester);

    await tester.enterText(find.byType(TextField), '654321');
    await tester.pump();

    expect(find.text(_invalidCodeMessage), findsNothing);
  });

  testWidgets('should clear the error when a digit is erased', (tester) async {
    await _showRejectedCode(tester);

    await tester.enterText(find.byType(TextField), '12345');
    await tester.pump();

    expect(find.text(_invalidCodeMessage), findsNothing);
  });
}
