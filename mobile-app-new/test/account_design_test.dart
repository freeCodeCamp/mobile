import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:mobile_app_new/auth/models/user_model.dart';
import 'package:mobile_app_new/auth/ui/login/login_view.dart';
import 'package:mobile_app_new/auth/ui/login/login_viewmodel.dart';
import 'package:mobile_app_new/auth/ui/profile/profile_view.dart';
import 'package:mobile_app_new/fcc_theme.dart';
import 'package:mobile_app_new/services/auth_service.dart';
import 'package:mobile_app_new/settings/ui/settings/settings_view.dart';
import 'package:shared_preferences/shared_preferences.dart';

class _FakeAuth extends AuthNotifier {
  _FakeAuth(this.user);
  final FccUserModel? user;
  int refreshes = 0;

  @override
  Future<FccUserModel?> build() async => user;

  @override
  Future<void> refresh() async {
    refreshes++;
  }

  @override
  Future<void> signOut() async {
    state = const AsyncData(null);
  }
}

class _FakeLogin extends LoginNotifier {
  final sentEmails = <String>[];
  final providers = <String>[];
  final verifiedCodes = <String>[];

  @override
  LoginState build() => const LoginState();

  @override
  Future<String?> sendOtp(String email) async {
    sentEmails.add(email);
    state = state.copyWith(showOtpField: true);
    return null;
  }

  @override
  Future<String?> verifyOtp(String email, String otp) async {
    verifiedCodes.add(otp);
    state = state.copyWith(incorrectOtp: true);
    return null;
  }

  @override
  Future<String?> loginWithProvider(String connection) async {
    providers.add(connection);
    return 'Login cancelled';
  }
}

Future<void> _pump(
  WidgetTester tester,
  Widget screen, {
  FccUserModel? user,
  _FakeLogin? login,
  bool dark = false,
}) async {
  final router = GoRouter(
    routes: [
      GoRoute(path: '/', builder: (_, _) => screen),
      GoRoute(path: '/login', builder: (_, _) => const LoginView()),
      GoRoute(path: '/settings', builder: (_, _) => const SettingsView()),
      GoRoute(
        path: '/podcasts/downloads',
        builder: (_, _) =>
            const Scaffold(body: Text('Your downloaded episodes')),
      ),
    ],
  );
  addTearDown(router.dispose);
  await tester.pumpWidget(
    ProviderScope(
      overrides: [
        authProvider.overrideWith(() => _FakeAuth(user)),
        if (login != null) loginProvider.overrideWith(() => login),
      ],
      child: MaterialApp.router(
        theme: FccTheme.themeLight,
        darkTheme: FccTheme.themeDark,
        themeMode: dark ? ThemeMode.dark : ThemeMode.light,
        routerConfig: router,
      ),
    ),
  );
  await tester.pumpAndSettle();
}

void main() {
  setUp(() {
    SharedPreferences.setMockInitialValues({});
  });

  testWidgets(
    'email sign-in validates, resends, rejects invalid codes and changes email',
    (tester) async {
      final login = _FakeLogin();
      await _pump(tester, const LoginView(), login: login);
      final submit = find.widgetWithText(
        FilledButton,
        'Email me a sign-in code',
      );
      expect(tester.widget<FilledButton>(submit).onPressed, isNull);
      await tester.enterText(find.byType(TextField), 'camper@example.com');
      await tester.pump();
      await tester.ensureVisible(submit);
      await tester.tap(submit);
      await tester.pumpAndSettle();
      expect(login.sentEmails, ['camper@example.com']);
      expect(find.text('Check your email'), findsOneWidget);
      expect(find.text('Continue with Google'), findsNothing);
      await tester.enterText(find.byType(TextField), '12x34567');
      await tester.pump();
      final codeField = tester.widget<TextField>(find.byType(TextField));
      expect(codeField.controller!.text, '123456');
      await tester.ensureVisible(find.widgetWithText(FilledButton, 'Sign in'));
      await tester.tap(find.widgetWithText(FilledButton, 'Sign in'));
      await tester.pumpAndSettle();
      expect(login.verifiedCodes, ['123456']);
      expect(
        find.text(
          'That code is not valid. Check your latest email and try again.',
        ),
        findsOneWidget,
      );
      await tester.ensureVisible(find.text('Resend code'));
      await tester.tap(find.text('Resend code'));
      await tester.pumpAndSettle();
      expect(login.sentEmails, ['camper@example.com', 'camper@example.com']);
      await tester.ensureVisible(find.text('Change email'));
      await tester.tap(find.text('Change email'));
      await tester.pumpAndSettle();
      expect(find.text('Email me a sign-in code'), findsOneWidget);
      expect(
        tester.widget<TextField>(find.byType(TextField)).controller!.text,
        'camper@example.com',
      );
    },
  );

  testWidgets('social buttons retain their Auth0 provider connections', (
    tester,
  ) async {
    final login = _FakeLogin();
    await _pump(tester, const LoginView(), login: login, dark: true);
    for (final provider in ['Google', 'GitHub', 'Apple']) {
      await tester.ensureVisible(find.text('Continue with $provider'));
      await tester.tap(find.text('Continue with $provider'));
      await tester.pumpAndSettle();
    }
    expect(login.providers, ['google-oauth2', 'github', 'apple']);
    expect(tester.takeException(), isNull);
  });

  testWidgets('code paste validates clipboard content', (tester) async {
    final login = _FakeLogin();
    await _pump(tester, const LoginView(), login: login);
    await tester.enterText(find.byType(TextField), 'camper@example.com');
    await tester.pump();
    await tester.ensureVisible(find.text('Email me a sign-in code'));
    await tester.tap(find.text('Email me a sign-in code'));
    await tester.pumpAndSettle();
    tester.binding.defaultBinaryMessenger.setMockMethodCallHandler(
      SystemChannels.platform,
      (call) async {
        if (call.method == 'Clipboard.getData') return {'text': '654321'};
        return null;
      },
    );
    addTearDown(
      () => tester.binding.defaultBinaryMessenger.setMockMethodCallHandler(
        SystemChannels.platform,
        null,
      ),
    );
    await tester.tap(find.text('Paste code'));
    await tester.pumpAndSettle();
    expect(
      tester.widget<TextField>(find.byType(TextField)).controller!.text,
      '654321',
    );
  });

  testWidgets('guest profile offers real sign-in and downloads routes', (
    tester,
  ) async {
    await _pump(tester, const ProfileView(), login: _FakeLogin());
    expect(find.text("You're learning as a guest"), findsOneWidget);
    expect(find.text('Activity'), findsNothing);
    await tester.tap(find.text('Downloads'));
    await tester.pumpAndSettle();
    expect(find.text('Your downloaded episodes'), findsOneWidget);
  });

  testWidgets(
    'profile renders real points, streaks and earned certifications on a narrow screen',
    (tester) async {
      tester.view.physicalSize = const Size(320, 850);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);
      final now = DateTime.now();
      final today = DateTime(now.year, now.month, now.day);
      final yesterday = DateTime(now.year, now.month, now.day - 1);
      final user = FccUserModel(
        id: 'test',
        email: 'camper@example.com',
        username: 'camper',
        name: 'Camper',
        joinDate: DateTime(2020, 4),
        points: 123,
        isRespWebDesignCert: true,
        isFrontEndCert: true,
        calendar: {
          '${today.millisecondsSinceEpoch ~/ 1000}': 8,
          '${yesterday.millisecondsSinceEpoch ~/ 1000}': 4,
          '${DateTime(now.year, now.month, now.day - 2).millisecondsSinceEpoch ~/ 1000}':
              0,
        },
      );
      await _pump(tester, const ProfileView(), user: user, dark: true);
      expect(find.text('123'), findsOneWidget);
      expect(find.text('2'), findsNWidgets(2));
      expect(find.text('Activity'), findsOneWidget);
      await tester.scrollUntilVisible(find.text('Legacy certifications'), 180);
      expect(find.text('Responsive Web Design'), findsOneWidget);
      expect(find.text('Legacy certifications'), findsOneWidget);
      expect(tester.takeException(), isNull);
    },
  );

  testWidgets('resetting local data requires explicit confirmation', (
    tester,
  ) async {
    SharedPreferences.setMockInitialValues({'progress': 'saved'});
    await _pump(tester, const SettingsView());
    expect(find.text('Delete account'), findsNothing);
    await tester.tap(find.text('Reset app data'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Cancel'));
    await tester.pumpAndSettle();
    expect(
      (await SharedPreferences.getInstance()).getString('progress'),
      'saved',
    );
    await tester.tap(find.text('Reset app data'));
    await tester.pumpAndSettle();
    await tester.tap(find.widgetWithText(FilledButton, 'Reset app data'));
    await tester.pumpAndSettle();
    expect(
      (await SharedPreferences.getInstance()).getString('progress'),
      isNull,
    );
  });
}
