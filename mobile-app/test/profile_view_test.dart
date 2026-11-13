import 'package:audio_service/audio_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:freecodecamp/auth/models/user_model.dart';
import 'package:freecodecamp/auth/ui/profile/profile_view.dart';
import 'package:freecodecamp/fcc_theme.dart';
import 'package:freecodecamp/services/audio_service.dart';
import 'package:freecodecamp/services/auth_service.dart';

class _MemoryAuth extends AuthNotifier {
  _MemoryAuth(this._user);
  final FccUserModel _user;

  @override
  Future<FccUserModel?> build() async => _user;

  @override
  Future<void> refresh() async {}
}

class _SilentAudioHandler extends BaseAudioHandler
    implements AudioPlayerHandler {
  @override
  String? get codeRadioSongId => null;

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

FccUserModel _user(
  ProfileUI profileUI, {
  bool donating = true,
  List<String> topContributor = const ['2023'],
}) => FccUserModel(
  id: 'profile-user',
  email: 'profile@example.invalid',
  username: 'profile-learner',
  name: 'Profile Learner',
  joinDate: DateTime(2024),
  isDonating: donating,
  yearsTopContributor: topContributor,
  profileUI: profileUI,
);

Future<void> _pump(WidgetTester tester, FccUserModel user) async {
  tester.view.physicalSize = const Size(390, 2400);
  tester.view.devicePixelRatio = 1;
  addTearDown(tester.view.resetPhysicalSize);
  addTearDown(tester.view.resetDevicePixelRatio);
  await tester.pumpWidget(
    ProviderScope(
      overrides: [
        authProvider.overrideWith(() => _MemoryAuth(user)),
        audioHandlerProvider.overrideWithValue(_SilentAudioHandler()),
      ],
      child: MaterialApp(theme: FccTheme.themeDark, home: const ProfileView()),
    ),
  );
  await tester.pumpAndSettle();
}

void _test(String name, Future<void> Function(WidgetTester tester) body) {
  testWidgets(name, (tester) async {
    final semantics = tester.ensureSemantics();
    await body(tester);
    semantics.dispose();
  });
}

Finder _sectionLock() =>
    find.bySemanticsLabel('Private, only you can see this section');

Finder _pillLock() => find.bySemanticsLabel('Private, only you can see this');

const _unlockedAllOff = ProfileUI(isLocked: false);
const _unlockedAllOn = ProfileUI(
  isLocked: false,
  showCerts: true,
  showDonation: true,
  showHeatMap: true,
  showPoints: true,
);

void main() {
  _test('should lock Stats, Activity and Certifications when private', (
    tester,
  ) async {
    await _pump(tester, _user(_unlockedAllOff));
    expect(find.text('Stats'), findsOneWidget);
    expect(find.text('Activity'), findsOneWidget);
    expect(find.text('Certifications'), findsOneWidget);
    expect(_sectionLock(), findsNWidgets(3));
  });

  _test('should show no section locks when every flag is on', (tester) async {
    await _pump(tester, _user(_unlockedAllOn));
    expect(_sectionLock(), findsNothing);
    expect(_pillLock(), findsNothing);
    expect(find.text('Supporter'), findsOneWidget);
  });

  _test('should lock the Supporter pill only while showDonation is off', (
    tester,
  ) async {
    await _pump(tester, _user(_unlockedAllOff));
    expect(find.text('Supporter'), findsOneWidget);
    expect(_pillLock(), findsOneWidget);
  });

  _test('should show both pills for a donor who is a top contributor', (
    tester,
  ) async {
    await _pump(tester, _user(_unlockedAllOn));
    expect(find.text('Supporter'), findsOneWidget);
    expect(find.text('Top contributor'), findsOneWidget);
  });

  _test('should not lock Top contributor', (tester) async {
    await _pump(tester, _user(_unlockedAllOff, donating: false));
    expect(find.text('Top contributor'), findsOneWidget);
    expect(find.text('Supporter'), findsNothing);
    expect(_pillLock(), findsNothing);
  });

  _test('should show all sections without locks when profile is locked', (
    tester,
  ) async {
    await _pump(tester, _user(const ProfileUI()));
    expect(find.text('Your profile is private.'), findsOneWidget);
    expect(find.text('Stats'), findsOneWidget);
    expect(find.text('Activity'), findsOneWidget);
    expect(find.text('Certifications'), findsOneWidget);
    expect(find.text('Supporter'), findsOneWidget);
    expect(_sectionLock(), findsNothing);
    expect(_pillLock(), findsNothing);
  });

  _test('should show only the private placeholder in View as others', (
    tester,
  ) async {
    await _pump(tester, _user(const ProfileUI()));
    await tester.tap(find.text('View as others'));
    await tester.pumpAndSettle();
    expect(find.text('This profile is private'), findsOneWidget);
    expect(find.text('Stats'), findsNothing);
    expect(find.text('Supporter'), findsNothing);
    expect(_sectionLock(), findsNothing);
    expect(_pillLock(), findsNothing);
  });
}
