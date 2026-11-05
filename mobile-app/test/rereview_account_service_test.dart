import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:freecodecamp/auth/models/user_model.dart';
import 'package:freecodecamp/auth/repositories/profile_repository.dart';
import 'package:freecodecamp/auth/repositories/session_repository.dart';
import 'package:freecodecamp/auth/services/profile_service.dart';
import 'package:freecodecamp/services/app_preferences_service.dart';
import 'package:freecodecamp/settings/models/app_preferences_model.dart';
import 'package:freecodecamp/settings/repositories/settings_repository.dart';
import 'package:shared_preferences/shared_preferences.dart';

final _user = FccUserModel(
  id: 'test-learner',
  username: 'learner',
  email: 'learner@example.invalid',
  joinDate: DateTime(2024),
  picture: 'https://example.com/old.png',
  socrates: false,
  portfolio: const [
    Portfolio(
      id: 'project',
      title: 'Project',
      url: 'https://example.com',
      image: 'https://example.com/old-project.png',
    ),
  ],
);

class _ProfileRepository extends Fake implements ProfileRepository {
  _ProfileRepository(FccUserModel user)
    : current = jsonDecode(jsonEncode(user)) as Map<String, dynamic>;
  Map<String, dynamic> current;
  final writes = <({String path, Map<String, Object?> body})>[];

  @override
  Future<AuthTokens> captureSession() async =>
      (csrf: 'test', csrfToken: 'test', jwtAccessToken: 'test');

  @override
  Future<Map<String, dynamic>?> currentUser({
    AuthTokens? expectedTokens,
  }) async => current;

  @override
  Future<Map<String, dynamic>> update(
    String path,
    Map<String, Object?> body, {
    required AuthTokens expectedTokens,
  }) async {
    writes.add((path: path, body: body));
    current = {...current, ...body};
    return {'type': 'success'};
  }
}

void main() {
  test(
    'profile photo URL and removal are persisted through update-my-about',
    () async {
      final repo = _ProfileRepository(_user);
      final service = ProfileService(repo);
      final changed = _user.copyWith(picture: 'https://example.com/new.png');
      final saved = await service.save(original: _user, draft: changed);
      expect(saved.isSuccess, isTrue);
      expect(repo.writes.single.path, '/update-my-about');
      expect(repo.writes.single.body, {
        'picture': 'https://example.com/new.png',
      });
      expect(saved.user?.picture, changed.picture);
      final removed = await service.save(
        original: changed,
        draft: changed.copyWith(picture: ''),
      );
      expect(removed.user?.picture, '');
      expect(repo.writes.last.body, {'picture': ''});
    },
  );

  test(
    'project image changes preserve remote text and support image-only additions',
    () async {
      final latest = _user.copyWith(
        portfolio: [
          _user.portfolio.single.copyWith(title: 'Renamed elsewhere'),
        ],
      );
      final repo = _ProfileRepository(latest);
      final service = ProfileService(repo);
      final changed = _user.copyWith(
        portfolio: [
          _user.portfolio.single.copyWith(
            image: 'https://example.com/new-project.png',
          ),
          const Portfolio(
            id: 'new',
            title: 'Another project',
            url: 'https://example.com/another',
            image: 'https://example.com/another.png',
          ),
        ],
      );
      final result = await service.save(original: _user, draft: changed);
      expect(repo.writes.single.path, '/update-my-portfolio');
      expect(result.user!.portfolio.first.title, 'Renamed elsewhere');
      expect(
        result.user!.portfolio.first.image,
        'https://example.com/new-project.png',
      );
      expect(
        result.user!.portfolio.last.image,
        'https://example.com/another.png',
      );
      final rebased = service.rebaseDraft(
        original: _user,
        draft: changed,
        canonical: latest,
        savedSections: [],
      );
      expect(
        rebased.portfolio.first.image,
        'https://example.com/new-project.png',
      );
      expect(rebased.portfolio.first.title, 'Renamed elsewhere');
    },
  );

  test('new project without an image persists an empty image field', () async {
    final repo = _ProfileRepository(_user);
    final draft = _user.copyWith(
      portfolio: [
        ..._user.portfolio,
        const Portfolio(id: 'no-image', title: 'No image'),
      ],
    );
    await ProfileService(repo).save(original: _user, draft: draft);
    final rows = repo.writes.single.body['portfolio']! as List;
    expect(rows.last['image'], '');
  });

  test(
    'profile image validation matches accepted URL formats and rejects local files',
    () {
      expect(
        ProfileService.imageUrlError(
          'https://example.com/photo.png?size=200',
          profilePhoto: true,
        ),
        isNull,
      );
      expect(ProfileService.imageUrlError('', profilePhoto: true), isNull);
      expect(
        ProfileService.imageUrlError(
          'https://example.com/avatar',
          profilePhoto: true,
        ),
        isNotNull,
      );
      expect(ProfileService.imageUrlError('file:///local.png'), isNotNull);
      expect(
        ProfileService.imageUrlError('data:image/png;base64,abc'),
        isNotNull,
      );
    },
  );

  test(
    'first install defaults dark and saved System, Light and Dark remain explicit',
    () async {
      expect(const AppPreferences().themeMode, ThemeMode.dark);
      for (final stored in [null, 'unknown', 'system', 'light', 'dark']) {
        SharedPreferences.setMockInitialValues({'app_theme_mode': ?stored});
        final prefs = await SharedPreferences.getInstance();
        final container = ProviderContainer(
          overrides: [
            settingsRepositoryProvider.overrideWith(
              (_) async => SettingsRepository(prefs),
            ),
          ],
        );
        final value = await container.read(appPreferencesProvider.future);
        expect(value.themeMode, switch (stored) {
          'system' => ThemeMode.system,
          'light' => ThemeMode.light,
          _ => ThemeMode.dark,
        });
        await container
            .read(appPreferencesProvider.notifier)
            .setTheme(ThemeMode.system);
        expect(prefs.getString('app_theme_mode'), 'system');
        container.dispose();
      }
    },
  );
}
