import 'dart:async';

import 'package:audio_service/audio_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:freecodecamp/auth/models/user_model.dart';
import 'package:freecodecamp/auth/repositories/profile_repository.dart';
import 'package:freecodecamp/auth/services/profile_service.dart';
import 'package:freecodecamp/auth/ui/account/account_view.dart';
import 'package:freecodecamp/auth/ui/login/login_view.dart';
import 'package:freecodecamp/auth/ui/profile/profile_view.dart';
import 'package:freecodecamp/auth/ui/profile_edit/profile_edit_view.dart';
import 'package:freecodecamp/auth/ui/profile_experience/profile_experience_view.dart';
import 'package:freecodecamp/auth/ui/profile_project/profile_project_view.dart';
import 'package:freecodecamp/auth/ui/profile_visibility/profile_visibility_view.dart';
import 'package:freecodecamp/auth/ui/widgets/profile_form.dart';
import 'package:freecodecamp/fcc_theme.dart';
import 'package:freecodecamp/routing/auth.dart';
import 'package:freecodecamp/services/audio_service.dart';
import 'package:freecodecamp/services/auth_service.dart';
import 'package:freecodecamp/settings/services/app_preferences.dart';
import 'package:freecodecamp/settings/services/local_data_service.dart';
import 'package:freecodecamp/settings/ui/settings/settings_view.dart';
import 'package:go_router/go_router.dart';
import 'package:package_info_plus/package_info_plus.dart';

final _user = FccUserModel(
  id: 'audit-user',
  email: 'audit@example.invalid',
  username: 'audit-learner',
  name: 'Audit Learner',
  joinDate: DateTime(2024),
  profileUI: const ProfileUI(isLocked: true),
);

class _MemoryAuth extends AuthNotifier {
  _MemoryAuth({FccUserModel? user}) : _initialUser = user ?? _user;
  final FccUserModel _initialUser;
  int _saves = 0;
  bool _failSave = false;
  Completer<void>? _saveGate;

  @override
  Future<FccUserModel?> build() async => _initialUser;

  @override
  Future<void> refresh() async {}

  @override
  Future<ProfileSaveResult> saveProfile({
    required FccUserModel original,
    required FccUserModel draft,
  }) async {
    _saves++;
    await _saveGate?.future;
    if (_failSave) throw StateError('Offline');
    state = AsyncData(draft);
    return ProfileSaveResult(
      user: draft,
      savedSections: [ProfileSection.privacy],
    );
  }
}

class _UnusedProfileRepository extends Fake implements ProfileRepository {}

class _SilentAudioHandler extends BaseAudioHandler
    implements AudioPlayerHandler {
  @override
  String? get codeRadioSongId => null;

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

class _MemoryPreferences extends AppPreferencesNotifier {
  @override
  Future<AppPreferences> build() async => const AppPreferences();
}

Future<GoRouter> _pumpScreen(
  WidgetTester tester,
  Widget screen,
  _MemoryAuth auth, {
  Brightness brightness = Brightness.dark,
  double textScale = 1,
}) async {
  final router = GoRouter(
    initialLocation: '/test',
    routes: [
      GoRoute(
        path: '/test',
        builder: (_, _) => Consumer(
          builder: (context, ref, _) => ref.watch(authProvider).isLoading
              ? const Scaffold(body: Center(child: CircularProgressIndicator()))
              : screen,
        ),
      ),
      GoRoute(
        path: profileVisibilityPath,
        builder: (_, _) => const ProfileVisibilityView(),
      ),
    ],
  );
  addTearDown(router.dispose);
  await tester.pumpWidget(
    ProviderScope(
      overrides: [
        authProvider.overrideWith(() => auth),
        audioHandlerProvider.overrideWithValue(_SilentAudioHandler()),
        profileServiceProvider.overrideWithValue(
          ProfileService(_UnusedProfileRepository()),
        ),
        appPreferencesProvider.overrideWith(_MemoryPreferences.new),
        downloadedStorageBytesProvider.overrideWith((ref) async => 0),
        appVersionProvider.overrideWith(
          (ref) async => PackageInfo(
            appName: 'Audit',
            packageName: 'audit',
            version: '1',
            buildNumber: '1',
          ),
        ),
      ],
      child: MaterialApp.router(
        theme: brightness == Brightness.dark
            ? FccTheme.themeDark
            : FccTheme.themeLight,
        routerConfig: router,
        builder: (context, child) => MediaQuery(
          data: MediaQuery.of(
            context,
          ).copyWith(textScaler: TextScaler.linear(textScale)),
          child: child!,
        ),
      ),
    ),
  );
  await tester.pumpAndSettle();
  return router;
}

Finder _switch(String label) =>
    find.ancestor(of: find.text(label), matching: find.byType(SwitchListTile));

void main() {
  testWidgets(
    'EF1 change photo opens the options sheet without account writes',
    (tester) async {
      final auth = _MemoryAuth();
      await _pumpScreen(tester, const ProfileEditView(), auth);
      final save = tester.widget<FilledButton>(
        find.widgetWithText(FilledButton, 'Save'),
      );
      expect(save.onPressed, isNotNull);
      await tester.tap(find.widgetWithText(OutlinedButton, 'Change photo'));
      await tester.pumpAndSettle();
      for (final label in [
        'Take photo',
        'Choose from library',
        'Remove photo',
      ]) {
        final tile = tester.widget<ListTile>(
          find.widgetWithText(ListTile, label),
        );
        expect(tile.enabled, isFalse);
        expect(tile.onTap, isNull);
      }
      expect(
        find.text('Photo changes are not available in the app yet.'),
        findsOneWidget,
      );
      expect(auth._saves, 0);
    },
  );

  testWidgets('PV1 and PV2 save visibility immediately and announce Saved', (
    tester,
  ) async {
    final auth = _MemoryAuth();
    await _pumpScreen(tester, const ProfileVisibilityView(), auth);
    expect(find.byType(BackButton), findsOneWidget);
    expect(find.text('Cancel'), findsNothing);
    expect(find.text('Save'), findsNothing);
    expect(find.text('Only you can see your profile.'), findsOneWidget);
    expect(
      tester
          .widget<SegmentedButton<bool>>(find.byType(SegmentedButton<bool>))
          .selected,
      {true},
    );
    await tester.tap(find.text('Public'));
    await tester.pumpAndSettle();
    expect(auth._saves, 1);
    expect(find.text('Saved'), findsOneWidget);
    expect(
      find.text(
        'Anyone can see your profile at freecodecamp.org/audit-learner.',
      ),
      findsOneWidget,
    );
    expect(
      tester
          .widget<SegmentedButton<bool>>(find.byType(SegmentedButton<bool>))
          .selected,
      {false},
    );
    await tester.tap(_switch('Name'));
    await tester.pumpAndSettle();
    expect(auth._saves, 2);
    expect(tester.widget<SwitchListTile>(_switch('Name')).value, isTrue);
  });

  testWidgets(
    'PV1 failed immediate save is retryable and never announces success',
    (tester) async {
      final auth = _MemoryAuth().._failSave = true;
      await _pumpScreen(tester, const ProfileVisibilityView(), auth);
      await tester.tap(find.text('Public'));
      await tester.pumpAndSettle();
      expect(auth._saves, 1);
      expect(find.text('Saved'), findsNothing);
      expect(
        find.text('Could not save your visibility settings. Please try again.'),
        findsOneWidget,
      );
      auth._failSave = false;
      await tester.tap(find.text('Try again'));
      await tester.pumpAndSettle();
      expect(auth._saves, 2);
      expect(find.text('Saved'), findsOneWidget);
    },
  );

  testWidgets('PV1 disables repeated changes while saving', (tester) async {
    final auth = _MemoryAuth().._saveGate = Completer<void>();
    await _pumpScreen(tester, const ProfileVisibilityView(), auth);
    await tester.tap(find.text('Public'));
    await tester.pump();
    expect(auth._saves, 1);
    expect(
      tester
          .widget<SegmentedButton<bool>>(find.byType(SegmentedButton<bool>))
          .onSelectionChanged,
      isNull,
    );
    auth._saveGate!.complete();
    await tester.pumpAndSettle();
    expect(find.text('Saved'), findsOneWidget);
  });

  testWidgets('ST3 exposes unavailable modes and opens profile visibility', (
    tester,
  ) async {
    final auth = _MemoryAuth();
    await _pumpScreen(tester, const SettingsView(), auth);
    for (final label in ['Socrates mode', 'Campfire mode']) {
      await tester.scrollUntilVisible(
        find.text(label),
        180,
        scrollable: find.byType(Scrollable).first,
      );
      final tile = tester.widget<SwitchListTile>(_switch(label));
      expect(tile.onChanged, isNull);
      expect(tile.value, isFalse);
    }
    await tester.scrollUntilVisible(
      find.text('Profile visibility'),
      180,
      scrollable: find.byType(Scrollable).first,
    );
    await tester.ensureVisible(find.text('Profile visibility'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Profile visibility'));
    await tester.pumpAndSettle();
    expect(find.byType(ProfileVisibilityView), findsOneWidget);
    expect(auth._saves, 0);
  });

  for (final brightness in Brightness.values) {
    testWidgets(
      'Account forms and settings fit 360dp at 1.3 scale in ${brightness.name}',
      (tester) async {
        tester.view.physicalSize = const Size(360, 800);
        tester.view.devicePixelRatio = 1;
        addTearDown(tester.view.resetPhysicalSize);
        addTearDown(tester.view.resetDevicePixelRatio);
        for (final screen in [
          const AccountView(),
          const LoginView(),
          const ProfileView(),
          const ProfileEditView(),
          const ProfileProjectView(),
          const ProfileExperienceView(),
          const ProfileVisibilityView(),
          const SettingsView(),
        ]) {
          await _pumpScreen(
            tester,
            screen,
            _MemoryAuth(
              user: _user.copyWith(
                isDonating: true,
                isRespWebDesignCert: true,
                githubProfile: 'https://github.com/example',
                about: 'A learner building projects and sharing progress.',
                profileUI: const ProfileUI(
                  isLocked: false,
                  showName: true,
                  showAbout: true,
                  showLocation: true,
                  showDonation: true,
                  showPoints: true,
                  showHeatMap: true,
                  showCerts: true,
                  showPortfolio: true,
                  showExperience: true,
                ),
                portfolio: [
                  const Portfolio(
                    id: 'test-project',
                    title: 'Weather dashboard',
                    description: 'A weather dashboard using public data.',
                    url: 'https://example.invalid',
                  ),
                ],
                experience: [
                  const Experience(
                    id: 'test-work',
                    title: 'Developer',
                    company: 'Example',
                    startDate: '01/2024',
                    description: 'Built accessible interfaces.',
                  ),
                ],
              ),
            ),
            brightness: brightness,
            textScale: 1.3,
          );
          expect(
            tester.takeException(),
            isNull,
            reason: screen.runtimeType.toString(),
          );
          final scrollables = find.byType(Scrollable);
          if (scrollables.evaluate().isNotEmpty) {
            for (var step = 0; step < 6; step++) {
              await tester.drag(scrollables.first, const Offset(0, -500));
              await tester.pumpAndSettle();
              expect(
                tester.takeException(),
                isNull,
                reason: screen.runtimeType.toString(),
              );
            }
          }
          await tester.pumpWidget(const SizedBox.shrink());
          await tester.pumpAndSettle();
        }
      },
    );
  }

  testWidgets('PP2 PP3 PP4 fields use the control edge and readable counters', (
    tester,
  ) async {
    final controller = TextEditingController(text: 'Hello');
    addTearDown(controller.dispose);
    await tester.pumpWidget(
      MaterialApp(
        theme: FccTheme.themeDark,
        home: Scaffold(
          body: ProfileFormField(
            label: 'Description',
            controller: controller,
            maxLength: 288,
            maxLines: 4,
          ),
        ),
      ),
    );
    expect(find.text('5 / 288 characters'), findsOneWidget);
    final field = tester.widget<TextField>(find.byType(TextField));
    expect(field.style?.letterSpacing, 0);
    expect(
      (field.decoration!.enabledBorder! as OutlineInputBorder).borderSide.color,
      FccTheme.themeDark.colorScheme.outline,
    );
    expect(
      tester.widget<Text>(find.text('5 / 288 characters')).style?.fontSize,
      13,
    );
  });
}
