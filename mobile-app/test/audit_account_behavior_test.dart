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
import 'package:freecodecamp/auth/ui/widgets/image_url_dialog.dart';
import 'package:freecodecamp/auth/ui/widgets/profile_form.dart';
import 'package:freecodecamp/auth/ui/widgets/profile_photo_options.dart';
import 'package:freecodecamp/fcc_theme.dart';
import 'package:freecodecamp/routing/auth.dart';
import 'package:freecodecamp/routing/settings.dart' as settings_routes;
import 'package:freecodecamp/services/audio_service.dart';
import 'package:freecodecamp/services/auth_service.dart';
import 'package:freecodecamp/settings/services/app_preferences.dart';
import 'package:freecodecamp/settings/services/local_data_service.dart';
import 'package:freecodecamp/settings/ui/settings/delete_account/delete_account_view.dart';
import 'package:freecodecamp/settings/ui/settings/settings_view.dart';
import 'package:freecodecamp/widgets/app_bottom_navigation.dart';
import 'package:freecodecamp/widgets/fcc_switch.dart';
import 'package:freecodecamp/widgets/segmented_tabs.dart';
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
  _MemoryAuth.guest() : _initialUser = null;
  final FccUserModel? _initialUser;
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
  bool realAccountRoutes = false,
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
      if (realAccountRoutes) ...[
        ...$appRoutes,
        ...settings_routes.$appRoutes,
      ] else
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

Finder _switch(String label) => find.byWidgetPredicate(
  (widget) => widget is FccSwitch && widget.semanticLabel == label,
);

void main() {
  testWidgets(
    'account and profile cards keep one-pixel borders and design radii',
    (tester) async {
      tester.view.physicalSize = const Size(390, 844);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);
      for (final auth in [_MemoryAuth.guest(), _MemoryAuth()]) {
        await _pumpScreen(tester, const AccountView(), auth);
        for (final element in find.byType(Card).evaluate()) {
          final card = element.widget as Card;
          final shape =
              (card.shape ?? Theme.of(element).cardTheme.shape)
                  as RoundedRectangleBorder;
          expect(shape.borderRadius, BorderRadius.circular(16));
          expect(shape.side.width, 1);
          expect(
            shape.side.color,
            FccTheme.themeDark.colorScheme.outlineVariant,
          );
        }
        await tester.pumpWidget(const SizedBox.shrink());
      }
      await _pumpScreen(tester, const ProfileView(), _MemoryAuth());
      expect(find.byType(Card), findsWidgets);
      for (final element in find.byType(Card).evaluate()) {
        final card = element.widget as Card;
        final shape =
            (card.shape ?? Theme.of(element).cardTheme.shape)
                as RoundedRectangleBorder;
        expect(
          shape.borderRadius,
          anyOf(BorderRadius.circular(16), BorderRadius.circular(14)),
        );
        expect(shape.side.width, 1);
        expect(shape.side.color, FccTheme.themeDark.colorScheme.outlineVariant);
      }
    },
  );

  testWidgets(
    'discard and delete account action pairs measure 50px with 17px Lato labels',
    (tester) async {
      tester.view.physicalSize = const Size(390, 844);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);
      await _pumpScreen(tester, const ProfileEditView(), _MemoryAuth());
      unawaited(
        confirmProfileDiscard(tester.element(find.byType(ProfileEditView))),
      );
      await tester.pumpAndSettle();
      for (final label in ['Keep editing', 'Discard']) {
        final button = find.ancestor(
          of: find.text(label),
          matching: find.byWidgetPredicate((w) => w is ButtonStyleButton),
        );
        expect(tester.getSize(button).height, 50);
        final style = DefaultTextStyle.of(
          tester.element(find.text(label)),
        ).style;
        expect(style.fontSize, 17);
        expect(style.fontFamily, 'Lato');
        expect(
          style.fontWeight,
          label == 'Keep editing' ? FontWeight.w900 : FontWeight.w700,
        );
      }
      final dialog = tester.widget<AlertDialog>(find.byType(AlertDialog));
      expect(dialog.titleTextStyle?.fontSize, 20);
      expect(dialog.titleTextStyle?.fontWeight, FontWeight.w900);
      expect(dialog.contentTextStyle?.fontSize, 15);
      await tester.tap(find.text('Keep editing'));
      await tester.pumpAndSettle();
      await _pumpScreen(tester, const DeleteAccountView(), _MemoryAuth());
      for (final label in ['Delete my account', 'Keep my account']) {
        final button = find.ancestor(
          of: find.text(label),
          matching: find.byWidgetPredicate((w) => w is ButtonStyleButton),
        );
        expect(tester.getSize(button).height, 50);
        final style = DefaultTextStyle.of(
          tester.element(find.text(label)),
        ).style;
        expect(style.fontSize, 17);
        expect(
          style.fontWeight,
          label.startsWith('Delete') ? FontWeight.w900 : FontWeight.w700,
        );
      }
    },
  );

  testWidgets(
    'photo sheet identifies unavailable uploads and keeps URL/remove actions working',
    (tester) async {
      await _pumpScreen(tester, const ProfileEditView(), _MemoryAuth());
      final context = tester.element(find.byType(ProfileEditView));
      final action = showProfilePhotoOptions(context, hasPhoto: true);
      await tester.pumpAndSettle();
      expect(find.text('Square images work best.'), findsOneWidget);
      for (final label in ['Take photo', 'Choose from library']) {
        final tile = tester.widget<ListTile>(
          find.ancestor(of: find.text(label), matching: find.byType(ListTile)),
        );
        expect(tile.enabled, isFalse);
        expect(
          (tile.leading! as Icon).color,
          FccTheme.themeDark.colorScheme.outline,
        );
        expect(
          (tile.title! as Text).style?.color,
          FccTheme.themeDark.colorScheme.outline,
        );
      }
      final remove = tester.widget<ListTile>(
        find.ancestor(
          of: find.text('Remove photo'),
          matching: find.byType(ListTile),
        ),
      );
      expect(remove.enabled, isTrue);
      expect(
        (remove.leading! as Icon).color,
        FccTheme.themeDark.colorScheme.error,
      );
      await tester.tap(find.text('Remove photo'));
      await tester.pumpAndSettle();
      expect(await action, ProfilePhotoAction.remove);
      final url = showImageUrlDialog(
        context,
        initialUrl: '',
        validate: (value) =>
            ProfileService.imageUrlError(value, profilePhoto: true),
      );
      await tester.pumpAndSettle();
      await tester.enterText(
        find.byType(TextField).last,
        'https://example.com/photo.png',
      );
      await tester.tap(find.text('Use image'));
      await tester.pumpAndSettle();
      expect(await url, 'https://example.com/photo.png');
    },
  );

  testWidgets(
    'privacy note URL stays one line at 390dp and 1.3 scale and real routes return to Settings',
    (tester) async {
      tester.view.physicalSize = const Size(390, 844);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);
      await _pumpScreen(
        tester,
        const SettingsView(),
        _MemoryAuth(
          user: _user.copyWith(profileUI: const ProfileUI(isLocked: false)),
        ),
        textScale: 1.3,
        realAccountRoutes: true,
      );
      await tester.scrollUntilVisible(
        find.text('Profile visibility'),
        180,
        scrollable: find.byType(Scrollable).first,
      );
      await tester.tap(find.text('Profile visibility'));
      await tester.pumpAndSettle();
      expect(find.byType(ProfileVisibilityView), findsOneWidget);
      expect(find.byType(NavigationBar), findsNothing);
      expect(find.byType(AppNavigationFooter), findsNothing);
      final url = tester.widget<Text>(
        find.text('freecodecamp.org/audit-learner.'),
      );
      expect(url.maxLines, 1);
      final rect = tester.getRect(find.text('freecodecamp.org/audit-learner.'));
      expect(rect.right, lessThanOrEqualTo(374));
      expect(tester.takeException(), isNull);
      await tester.tap(find.byType(BackButton));
      await tester.pumpAndSettle();
      expect(find.byType(SettingsView), findsOneWidget);
    },
  );

  testWidgets(
    'sign-in divider is centered and provider gaps and Email label match',
    (tester) async {
      tester.view.physicalSize = const Size(390, 844);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);
      await _pumpScreen(tester, const LoginView(), _MemoryAuth.guest());
      final label = find.text('or use your email');
      final row = find.ancestor(of: label, matching: find.byType(Row)).first;
      final rules = find.descendant(of: row, matching: find.byType(Divider));
      expect(
        tester.getRect(label).center.dx,
        closeTo(tester.getRect(row).center.dx, .01),
      );
      expect(tester.getRect(rules.first).left, tester.getRect(row).left);
      expect(tester.getRect(rules.last).right, tester.getRect(row).right);
      expect(tester.widget<Text>(label).style?.fontSize, 13);
      expect(tester.widget<Text>(find.text('Email')).style?.fontSize, 14);
      expect(
        tester.widget<Text>(find.text('Email')).style?.fontWeight,
        FontWeight.w700,
      );
      final buttons = [
        for (final name in ['Google', 'GitHub', 'Apple'])
          find.ancestor(
            of: find.text('Continue with $name'),
            matching: find.byType(OutlinedButton),
          ),
      ];
      for (var i = 1; i < buttons.length; i++) {
        expect(
          tester.getRect(buttons[i]).top -
              tester.getRect(buttons[i - 1]).bottom,
          10,
        );
      }
    },
  );

  testWidgets(
    'profile Save and Change photo are pills and About counter and helper align',
    (tester) async {
      tester.view.physicalSize = const Size(390, 844);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);
      await _pumpScreen(tester, const ProfileEditView(), _MemoryAuth());
      final save = find.ancestor(
        of: find.text('Save'),
        matching: find.byType(FilledButton),
      );
      final saveWidget = tester.widget<FilledButton>(save);
      expect(
        (saveWidget.style!.shape!.resolve({})! as RoundedRectangleBorder)
            .borderRadius,
        BorderRadius.circular(999),
      );
      expect(saveWidget.style!.minimumSize!.resolve({}), const Size(72, 44));
      expect(saveWidget.style!.textStyle!.resolve({})!.fontSize, 15);
      final change = tester.widget<OutlinedButton>(
        find.ancestor(
          of: find.text('Change photo'),
          matching: find.byType(OutlinedButton),
        ),
      );
      expect(
        (change.style!.shape!.resolve({})! as RoundedRectangleBorder)
            .borderRadius,
        BorderRadius.circular(999),
      );
      final usernameField = find.byWidgetPredicate(
        (w) => w is ProfileFormField && w.label == 'Username',
      );
      final helper = find.text(
        'Your profile link: freecodecamp.org/audit-learner',
      );
      expect(tester.getTopLeft(helper).dx, tester.getTopLeft(usernameField).dx);
      await tester.scrollUntilVisible(
        find.text('About'),
        180,
        scrollable: find.byType(Scrollable).first,
      );
      final about = tester.widget<ProfileFormField>(
        find.byWidgetPredicate(
          (w) => w is ProfileFormField && w.label == 'About',
        ),
      );
      expect(about.maxLength, 500);
      expect(
        about.hintText,
        "A sentence or two about you and what you're learning",
      );
      await tester.ensureVisible(find.text('0 / 500 characters'));
      expect(find.text('0 / 500 characters'), findsOneWidget);
    },
  );

  testWidgets('private profile preview uses learner wording', (tester) async {
    await _pumpScreen(tester, const ProfileView(), _MemoryAuth());
    await tester.tap(find.text('View as others'));
    await tester.pumpAndSettle();
    expect(
      find.text('This learner has chosen to keep their profile private.'),
      findsOneWidget,
    );
  });

  testWidgets('should open profile photo options from Edit profile', (
    tester,
  ) async {
    await _pumpScreen(tester, const ProfileEditView(), _MemoryAuth());
    await tester.tap(find.text('Change photo'));
    await tester.pumpAndSettle();
    expect(find.text('Profile photo'), findsOneWidget);
    expect(find.text('Use image URL'), findsOneWidget);
  });

  testWidgets('should save visibility immediately and announce Saved', (
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
          .widget<SegmentedTabs<bool>>(find.byType(SegmentedTabs<bool>))
          .selected,
      isTrue,
    );
    await tester.tap(find.text('Public'));
    await tester.pumpAndSettle();
    expect(auth._saves, 1);
    expect(find.text('Saved'), findsOneWidget);
    expect(find.text('freecodecamp.org/audit-learner.'), findsOneWidget);
    expect(
      tester
          .widget<SegmentedTabs<bool>>(find.byType(SegmentedTabs<bool>))
          .selected,
      isFalse,
    );
    await tester.tap(_switch('Name'));
    await tester.pumpAndSettle();
    expect(auth._saves, 2);
    expect(tester.widget<FccSwitch>(_switch('Name')).value, isTrue);
  });

  testWidgets('should retry a failed immediate save and not announce success', (
    tester,
  ) async {
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
  });

  testWidgets('should not show the bottom tab bar on Profile visibility', (
    tester,
  ) async {
    await _pumpScreen(tester, const ProfileVisibilityView(), _MemoryAuth());
    expect(find.byType(AppNavigationFooter), findsNothing);
  });

  testWidgets('should list About you as Name, Location, About', (tester) async {
    await _pumpScreen(tester, const ProfileVisibilityView(), _MemoryAuth());
    final top = [
      for (final label in ['Name', 'Location', 'About'])
        tester.getTopLeft(_switch(label)).dy,
    ];
    expect(top, orderedEquals([...top]..sort()));
  });

  testWidgets('should disable repeated changes while saving', (tester) async {
    final auth = _MemoryAuth().._saveGate = Completer<void>();
    await _pumpScreen(tester, const ProfileVisibilityView(), auth);
    await tester.tap(find.text('Public'));
    await tester.pump();
    expect(auth._saves, 1);
    expect(
      tester
          .widget<SegmentedTabs<bool>>(find.byType(SegmentedTabs<bool>))
          .onSelected,
      isNull,
    );
    auth._saveGate!.complete();
    await tester.pumpAndSettle();
    expect(find.text('Saved'), findsOneWidget);
  });

  testWidgets(
    'should omit Socrates and Campfire and open Profile visibility',
    (tester) async {
      final auth = _MemoryAuth();
      await _pumpScreen(tester, const SettingsView(), auth);
      expect(find.text('Socrates'), findsNothing);
      expect(find.text('Campfire mode'), findsNothing);
      await tester.scrollUntilVisible(
        find.text('Profile visibility'),
        180,
        scrollable: find.byType(Scrollable).first,
      );
      expect(find.text('Private'), findsOneWidget);
      await tester.ensureVisible(find.text('Profile visibility'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Profile visibility'));
      await tester.pumpAndSettle();
      expect(find.byType(ProfileVisibilityView), findsOneWidget);
      expect(auth._saves, 0);
    },
  );

  for (final brightness in Brightness.values) {
    testWidgets(
      'should fit account forms and settings in 360dp at 1.3 scale in ${brightness.name}',
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

  testWidgets(
    'should use the control edge and readable counters on profile fields',
    (tester) async {
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
        (field.decoration!.enabledBorder! as OutlineInputBorder)
            .borderSide
            .color,
        FccTheme.themeDark.colorScheme.outline,
      );
      expect(
        tester.widget<Text>(find.text('5 / 288 characters')).style?.fontSize,
        13,
      );
    },
  );
}
