import 'dart:async';
import 'dart:io';
import 'dart:ui' as ui;
import 'package:flutter/rendering.dart';
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
import 'package:package_info_plus/package_info_plus.dart';
import 'package:mobile_app_new/services/audio_service.dart';
import 'package:mobile_app_new/settings/services/app_preferences.dart';
import 'package:mobile_app_new/settings/services/local_data_service.dart';
import 'package:mobile_app_new/settings/services/learning_reminder_service.dart';
import 'package:mobile_app_new/services/notification_service.dart';
import 'package:mobile_app_new/settings/ui/settings/delete_account/delete_account_view.dart';
import 'package:mobile_app_new/settings/ui/settings/delete_account/delete_account_viewmodel.dart';
import 'support/fake_audio_handler.dart';

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
  double scale = 1,
  double keyboard = 0,
  _FakeReminder? reminder,
  LocalDataResetService? reset,
  _FakeDelete? deletion,
  Future<SharedPreferences> Function()? preferencesLoader,
  bool settle = true,
}) async {
  final router = GoRouter(
    routes: [
      GoRoute(path: '/', builder: (_, _) => screen),
      GoRoute(
        path: '/learn',
        builder: (_, _) => const Scaffold(body: Text('Learning home')),
      ),
      GoRoute(
        path: '/profile',
        builder: (_, _) => const Scaffold(body: Text('Profile home')),
      ),
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
        if (preferencesLoader != null)
          settingsPreferencesStoreProvider.overrideWith(
            (ref) => preferencesLoader(),
          ),
        audioHandlerProvider.overrideWithValue(FakeAudioHandler()),
        downloadedStorageBytesProvider.overrideWith((ref) async => 134217728),
        appVersionProvider.overrideWith(
          (ref) async => PackageInfo(
            appName: 'freeCodeCamp',
            packageName: 'test',
            version: '8.0.0',
            buildNumber: '42',
          ),
        ),
        learningReminderServiceProvider.overrideWithValue(
          reminder ?? _FakeReminder(),
        ),
        localDataResetServiceProvider.overrideWithValue(reset ?? _mockReset()),
        if (deletion != null)
          deleteAccountProvider.overrideWith(() => deletion),
        authProvider.overrideWith(() => _FakeAuth(user)),
        if (login != null) loginProvider.overrideWith(() => login),
      ],
      child: RepaintBoundary(
        key: _capture,
        child: MaterialApp.router(
          theme: FccTheme.themeLight,
          darkTheme: FccTheme.themeDark,
          themeMode: dark ? ThemeMode.dark : ThemeMode.light,
          routerConfig: router,
          debugShowCheckedModeBanner: false,
          builder: (context, child) => MediaQuery(
            data: MediaQuery.of(context).copyWith(
              textScaler: TextScaler.linear(scale),
              viewInsets: EdgeInsets.only(bottom: keyboard),
            ),
            child: child!,
          ),
        ),
      ),
    ),
  );
  if (settle) {
    await tester.pumpAndSettle();
  } else {
    await tester.pump();
  }
}

final _capture = GlobalKey();

class _FakeReminder extends LearningReminderService {
  _FakeReminder() : super(NotificationService());
  int enables = 0;
  int cancels = 0;
  bool denied = false;
  @override
  Future<void> enable() async {
    if (denied) throw ReminderPermissionDenied();
    enables++;
  }

  @override
  Future<void> cancel() async {
    cancels++;
  }
}

class _FakeDelete extends DeleteAccountNotifier {
  int calls = 0;
  @override
  bool build() => false;
  @override
  Future<String> deleteAccount() async {
    calls++;
    return 'Deletion failed. Please try again.';
  }
}

LocalDataResetService _mockReset() => LocalDataResetService(
  downloadsInProgress: () => false,
  stopPlayback: () async {},
  clearBookmarks: () async {},
  clearDownloads: () async {},
  cancelReminder: () async {},
  signOut: () async {},
  clearPreferences: () async {
    await (await SharedPreferences.getInstance()).clear();
  },
  refreshState: () {},
);
Future<void> _screenshot(WidgetTester tester, String name) async {
  const dir = String.fromEnvironment('UI_SCREENSHOT_DIR');
  if (dir.isEmpty) return;
  await tester.runAsync(() async {
    final image =
        await (_capture.currentContext!.findRenderObject()
                as RenderRepaintBoundary)
            .toImage(pixelRatio: 2);
    final bytes = await image.toByteData(format: ui.ImageByteFormat.png);
    final file = await File('$dir/$name.png').create(recursive: true);
    await file.writeAsBytes(bytes!.buffer.asUint8List());
    image.dispose();
  });
}

void main() {
  setUpAll(() async {
    TestWidgetsFlutterBinding.ensureInitialized();
    await (FontLoader(
      'Lato',
    )..addFont(rootBundle.load('assets/fonts/Lato-Regular.ttf'))).load();
    await (FontLoader(
      'monospace',
    )..addFont(rootBundle.load('assets/fonts/Hack-Regular.ttf'))).load();
    await (FontLoader(
      'MaterialIcons',
    )..addFont(rootBundle.load('fonts/MaterialIcons-Regular.otf'))).load();
  });
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
    expect(
      find.descendant(
        of: find.byType(AppBar),
        matching: find.byTooltip('Settings'),
      ),
      findsNothing,
    );
    expect(find.widgetWithText(ListTile, 'Settings'), findsOneWidget);
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
    await tester.scrollUntilVisible(find.text('Reset app data'), 250);
    await tester.pumpAndSettle();
    await tester.tap(find.text('Reset app data'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Cancel'));
    await tester.pumpAndSettle();
    expect(
      (await SharedPreferences.getInstance()).getString('progress'),
      'saved',
    );
    await tester.scrollUntilVisible(find.text('Reset app data'), 250);
    await tester.pumpAndSettle();
    await tester.tap(find.text('Reset app data'));
    await tester.pumpAndSettle();
    await tester.tap(find.widgetWithText(FilledButton, 'Reset app data'));
    await tester.pumpAndSettle();
    expect(
      (await SharedPreferences.getInstance()).getString('progress'),
      isNull,
    );
  });
  testWidgets(
    'theme selection persists and reminders report denied permission',
    (tester) async {
      final reminder = _FakeReminder()..denied = true;
      await _pump(tester, const SettingsView(), reminder: reminder);
      await tester.tap(find.widgetWithText(OutlinedButton, 'Dark'));
      await tester.pumpAndSettle();
      expect(
        (await SharedPreferences.getInstance()).getString(
          AppPreferencesNotifier.themeKey,
        ),
        'dark',
      );
      await tester.tap(find.byType(SwitchListTile));
      await tester.pumpAndSettle();
      expect(
        tester.widget<SwitchListTile>(find.byType(SwitchListTile)).value,
        isFalse,
      );
      expect(
        find.text(
          'Allow notifications in your device settings to enable reminders.',
        ),
        findsOneWidget,
      );
      reminder.denied = false;
      await tester.tap(find.byType(SwitchListTile));
      await tester.pumpAndSettle();
      expect(reminder.enables, 1);
      expect(
        (await SharedPreferences.getInstance()).getBool(
          AppPreferencesNotifier.reminderKey,
        ),
        isTrue,
      );
      await tester.tap(find.byType(SwitchListTile));
      await tester.pumpAndSettle();
      expect(reminder.cancels, 1);
      expect(
        (await SharedPreferences.getInstance()).getBool(
          AppPreferencesNotifier.reminderKey,
        ),
        isFalse,
      );
      await tester.tap(find.text('Language'));
      await tester.pumpAndSettle();
      expect(
        find.textContaining('English is currently the supported app language'),
        findsOneWidget,
      );
      await tester.tap(find.text('Done'));
      await tester.pumpAndSettle();
      expect(tester.takeException(), isNull);
    },
  );

  testWidgets(
    'delete requires certainty and confirmation and keeps account on cancel',
    (tester) async {
      final deletion = _FakeDelete();
      final user = FccUserModel(
        id: 'test',
        username: 'camper',
        email: 'camper@example.com',
        joinDate: DateTime(2020),
      );
      await _pump(
        tester,
        const DeleteAccountView(),
        user: user,
        deletion: deletion,
      );
      final deleteButton = find.widgetWithText(
        FilledButton,
        'Delete my account',
      );
      expect(tester.widget<FilledButton>(deleteButton).onPressed, isNull);
      await tester.scrollUntilVisible(
        find.byType(CheckboxListTile),
        250,
        scrollable: find.byType(Scrollable).first,
      );
      await tester.pumpAndSettle();
      await tester.tap(find.byType(CheckboxListTile));
      await tester.pumpAndSettle();
      expect(tester.widget<FilledButton>(deleteButton).onPressed, isNotNull);
      await tester.tap(deleteButton);
      await tester.pumpAndSettle();
      await tester.tap(find.text('Cancel'));
      await tester.pumpAndSettle();
      expect(deletion.calls, 0);
      await tester.tap(deleteButton);
      await tester.pumpAndSettle();
      await tester.tap(find.widgetWithText(FilledButton, 'Delete account'));
      await tester.pumpAndSettle();
      expect(deletion.calls, 1);
      expect(find.text('Deletion failed. Please try again.'), findsOneWidget);
      await tester.tap(find.text('Keep my account'));
      await tester.pumpAndSettle();
      expect(find.text('Settings'), findsOneWidget);
      expect(tester.takeException(), isNull);
    },
  );

  for (final dark in [false, true]) {
    for (final dimensions in [
      (width: 390.0, height: 844.0, scale: 1.0),
      (width: 320.0, height: 640.0, scale: 2.0),
      (width: 844.0, height: 390.0, scale: 2.0),
    ]) {
      for (final page in <Widget>[
        const SettingsView(),
        const DeleteAccountView(),
      ]) {
        final name =
            '${page is SettingsView ? 'settings' : 'delete'}-${dark ? 'dark' : 'light'}-${dimensions.width.toInt()}';
        testWidgets('$name remains usable at ${dimensions.scale} text scale', (
          tester,
        ) async {
          tester.view.physicalSize = Size(dimensions.width, dimensions.height);
          tester.view.devicePixelRatio = 1;
          addTearDown(tester.view.resetPhysicalSize);
          addTearDown(tester.view.resetDevicePixelRatio);
          final user = FccUserModel(
            id: 'test',
            username: 'camper',
            email: 'camper@example.com',
            joinDate: DateTime(2020),
          );
          await _pump(
            tester,
            page,
            user: user,
            dark: dark,
            scale: dimensions.scale,
          );
          await _screenshot(tester, name);
          expect(tester.takeException(), isNull);
          if (page is DeleteAccountView) {
            await tester.scrollUntilVisible(
              find.byType(CheckboxListTile),
              250,
              scrollable: find.byType(Scrollable).first,
            );
            await tester.pumpAndSettle();
            await tester.tap(find.byType(CheckboxListTile));
            await tester.pumpAndSettle();
            expect(
              tester
                  .widget<FilledButton>(
                    find.widgetWithText(FilledButton, 'Delete my account'),
                  )
                  .onPressed,
              isNotNull,
            );
            expect(
              tester.getRect(find.text('Keep my account')).bottom,
              lessThanOrEqualTo(dimensions.height),
            );
          } else {
            await tester.scrollUntilVisible(
              find.text('Version 8.0.0 (42)'),
              350,
            );
            expect(find.text('Delete account'), findsOneWidget);
          }
          await _screenshot(tester, '$name-bottom');
          expect(tester.takeException(), isNull);
        });
      }
    }
  }
  testWidgets('settings loading and retry recover the preference store', (
    tester,
  ) async {
    final pending = Completer<SharedPreferences>();
    var requests = 0;
    await _pump(
      tester,
      const SettingsView(),
      settle: false,
      preferencesLoader: () {
        requests++;
        return requests == 1 ? pending.future : SharedPreferences.getInstance();
      },
    );
    expect(find.byType(LinearProgressIndicator), findsOneWidget);
    expect(
      tester.widget<SwitchListTile>(find.byType(SwitchListTile)).onChanged,
      isNull,
    );
    pending.completeError(StateError('test preference load failed'));
    await tester.pump();
    await tester.pump();
    expect(find.text('Could not load settings. Retry'), findsOneWidget);
    await tester.tap(find.text('Could not load settings. Retry'));
    await tester.pumpAndSettle();
    expect(requests, 2);
    expect(find.widgetWithText(OutlinedButton, 'System'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets(
    'settings protects an in-progress reset and surfaces partial failure',
    (tester) async {
      final pending = Completer<void>();
      var calls = 0;
      final reset = LocalDataResetService(
        downloadsInProgress: () => false,
        stopPlayback: () async {},
        clearBookmarks: () {
          calls++;
          return pending.future;
        },
        clearDownloads: () async {},
        cancelReminder: () async {},
        signOut: () async {},
        clearPreferences: () async {},
        refreshState: () {},
      );
      await _pump(tester, const SettingsView(), reset: reset);
      await tester.scrollUntilVisible(find.text('Reset app data'), 250);
      await tester.pumpAndSettle();
      await tester.tap(find.text('Reset app data'));
      await tester.pumpAndSettle();
      await tester.tap(find.widgetWithText(FilledButton, 'Reset app data'));
      await tester.pump(const Duration(milliseconds: 300));
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
      expect(find.byType(ModalBarrier), findsWidgets);
      expect(calls, 1);
      pending.completeError(StateError('test reset failure'));
      await tester.pumpAndSettle();
      expect(
        find.text('Some local data could not be cleared. Please try again.'),
        findsOneWidget,
      );
      expect(find.byType(CircularProgressIndicator), findsNothing);
      expect(find.text('Settings'), findsOneWidget);
      expect(tester.takeException(), isNull);
    },
  );
  for (final dark in [false, true]) {
    testWidgets(
      'settings dialogs remain reachable at 200 percent with keyboard in ${dark ? 'dark' : 'light'}',
      (tester) async {
        tester.view.physicalSize = const Size(320, 640);
        tester.view.devicePixelRatio = 1;
        addTearDown(tester.view.resetPhysicalSize);
        addTearDown(tester.view.resetDevicePixelRatio);
        await _pump(
          tester,
          const SettingsView(),
          dark: dark,
          scale: 2,
          keyboard: 200,
        );
        await tester.scrollUntilVisible(find.text('Language'), 200);
        await tester.pumpAndSettle();
        await tester.tap(find.text('Language'));
        await tester.pumpAndSettle();
        await _screenshot(
          tester,
          'settings-language-${dark ? 'dark' : 'light'}-keyboard',
        );
        expect(tester.takeException(), isNull);
        await tester.tap(find.text('Done'));
        await tester.pumpAndSettle();
        await tester.scrollUntilVisible(find.text('Reset app data'), 200);
        await tester.pumpAndSettle();
        await tester.tap(find.text('Reset app data'));
        await tester.pumpAndSettle();
        await _screenshot(
          tester,
          'settings-reset-${dark ? 'dark' : 'light'}-keyboard',
        );
        expect(tester.takeException(), isNull);
        await tester.tap(find.text('Cancel'));
        await tester.pumpAndSettle();
        expect(find.byType(AlertDialog), findsNothing);
        expect(tester.takeException(), isNull);
      },
    );
  }
}
