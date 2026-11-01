import 'package:collection/collection.dart';
import 'package:dio/dio.dart';
import 'package:freecodecamp/auth/models/profile_save_result.dart';
import 'package:freecodecamp/auth/models/user_model.dart';
import 'package:freecodecamp/auth/repositories/profile_repository.dart';
import 'package:freecodecamp/auth/repositories/session_repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

export 'package:freecodecamp/auth/models/profile_save_result.dart';

part 'profile_service.g.dart';

@Riverpod(keepAlive: true)
ProfileService profileService(Ref ref) =>
    ProfileService(ref.watch(profileRepositoryProvider));

class ProfileService {
  ProfileService(this._repo);

  final ProfileRepository _repo;
  static const _equal = DeepCollectionEquality();

  FccUserModel rebaseDraft({
    required FccUserModel original,
    required FccUserModel draft,
    required FccUserModel canonical,
    required List<ProfileSection> savedSections,
  }) {
    if (original.id != draft.id || canonical.id != original.id) {
      throw const ProfileUpdateException(
        'Your session changed. Reopen your profile.',
      );
    }
    final saved = savedSections.toSet();
    var rebased = canonical;
    if (!saved.contains(ProfileSection.username) &&
        draft.username.trim().toLowerCase() !=
            original.username.toLowerCase()) {
      rebased = rebased.copyWith(username: draft.username);
    }
    if (!saved.contains(ProfileSection.about)) {
      rebased = rebased.copyWith(
        name: draft.name != original.name ? draft.name : canonical.name,
        location: draft.location != original.location
            ? draft.location
            : canonical.location,
        about: draft.about != original.about ? draft.about : canonical.about,
      );
    }
    if (!saved.contains(ProfileSection.socials)) {
      final changed = _changedFields(_socials(original), _socials(draft));
      if (changed.isNotEmpty) {
        rebased = rebased.copyWith(
          githubProfile: changed.containsKey('githubProfile')
              ? changed['githubProfile'] as String
              : canonical.githubProfile,
          linkedin: changed.containsKey('linkedin')
              ? changed['linkedin'] as String
              : canonical.linkedin,
          twitter: changed.containsKey('twitter')
              ? changed['twitter'] as String
              : canonical.twitter,
          bluesky: changed.containsKey('bluesky')
              ? changed['bluesky'] as String
              : canonical.bluesky,
          website: changed.containsKey('website')
              ? changed['website'] as String
              : canonical.website,
        );
      }
    }
    if (!saved.contains(ProfileSection.portfolio)) {
      final rows = _mergeRows(
        canonical.portfolio.map((item) => item.toJson()).toList(),
        original.portfolio.map((item) => item.toJson()).toList(),
        draft.portfolio.map((item) => item.toJson()).toList(),
        fields: const ['title', 'description', 'url'],
      );
      if (rows != null) {
        rebased = rebased.copyWith(
          portfolio: rows.map(Portfolio.fromJson).toList(),
        );
      }
    }
    if (!saved.contains(ProfileSection.experience)) {
      final rows = _mergeRows(
        canonical.experience.map((item) => item.toJson()).toList(),
        original.experience.map((item) => item.toJson()).toList(),
        draft.experience.map((item) => item.toJson()).toList(),
        fields: const [
          'title',
          'company',
          'location',
          'startDate',
          'endDate',
          'description',
        ],
      );
      if (rows != null) {
        rebased = rebased.copyWith(
          experience: rows.map(Experience.fromJson).toList(),
        );
      }
    }
    if (!saved.contains(ProfileSection.privacy)) {
      rebased = rebased.copyWith(
        profileUI: ProfileUI.fromJson({
          ...canonical.profileUI.toJson(),
          ..._changedFields(
            original.profileUI.toJson(),
            draft.profileUI.toJson(),
          ),
        }),
      );
    }
    return rebased;
  }

  Future<bool> usernameAvailable(
    String username, {
    String? currentUsername,
  }) async {
    final canonical = username.trim().toLowerCase();
    if (usernameError(canonical) != null) return false;
    if (canonical == currentUsername?.trim().toLowerCase()) return true;
    try {
      return !await _repo.usernameExists(canonical);
    } catch (error) {
      throw ProfileUpdateException(_errorMessage(error));
    }
  }

  Map<String, String> validate(FccUserModel user, {FccUserModel? original}) {
    final errors = <String, String>{};
    void add(String field, String? error) {
      if (error != null) errors[field] = error;
    }

    if (original == null || user.username != original.username) {
      add('username', usernameError(user.username));
    }
    final socials = _socials(user);
    final before = original == null ? null : _socials(original);
    for (final entry in socials.entries) {
      if (before == null || before[entry.key] != entry.value) {
        add(entry.key, socialUrlError(entry.value, entry.key));
      }
    }

    final portfolioIds = <String>{};
    final portfolio = _equal.equals(user.portfolio, original?.portfolio)
        ? const <Portfolio>[]
        : user.portfolio;
    for (final item in portfolio) {
      final prefix = 'portfolio.${item.id}';
      if (item.id.isEmpty || !portfolioIds.add(item.id)) {
        add('$prefix.id', 'Each project needs a unique ID.');
      }
      final old = original?.portfolio.firstWhereOrNull((p) => p.id == item.id);
      if (old == item) continue;
      add('$prefix.title', _requiredText(item.title ?? '', 'Title'));
      if ((item.description ?? '').length > 500) {
        add('$prefix.description', 'Use 500 characters or fewer.');
      }
      add('$prefix.url', _urlError(item.url ?? ''));
    }

    final experienceIds = <String>{};
    final experience = _equal.equals(user.experience, original?.experience)
        ? const <Experience>[]
        : user.experience;
    for (final item in experience) {
      final prefix = 'experience.${item.id}';
      if (item.id.isEmpty || !experienceIds.add(item.id)) {
        add('$prefix.id', 'Each experience needs a unique ID.');
      }
      final old = original?.experience.firstWhereOrNull((p) => p.id == item.id);
      if (old == item) continue;
      add('$prefix.title', _requiredText(item.title, 'Job title'));
      add('$prefix.company', _requiredText(item.company, 'Company'));
      if (item.description.length > 500) {
        add('$prefix.description', 'Use 500 characters or fewer.');
      }
      add('$prefix.startDate', _dateError(item.startDate, isRequired: true));
      add('$prefix.endDate', _dateError(item.endDate, isRequired: false));
      final start = _month(item.startDate);
      final end = _month(item.endDate);
      if (start != null && end != null && end < start) {
        add('$prefix.endDate', 'End date must be on or after start date.');
      }
    }
    return errors;
  }

  Future<ProfileSaveResult> save({
    required FccUserModel original,
    required FccUserModel draft,
    bool Function()? isCurrentUser,
  }) async {
    if (original.id != draft.id || isCurrentUser?.call() == false) {
      throw const ProfileUpdateException(
        'Your session changed. Reopen your profile.',
      );
    }
    final errors = validate(draft, original: original);
    if (errors.isNotEmpty) throw ProfileValidationException(errors);

    final usernameChanged =
        draft.username.trim().toLowerCase() != original.username.toLowerCase();
    if (usernameChanged &&
        !await usernameAvailable(
          draft.username,
          currentUsername: original.username,
        )) {
      throw ProfileValidationException({
        'username': 'This username is unavailable. Choose another one.',
      });
    }

    final Map<String, dynamic> fresh;
    final AuthTokens session;
    try {
      session = await _repo.captureSession();
      final current = await _repo.currentUser(expectedTokens: session);
      if (current == null || current['id'] != original.id) {
        throw SessionExpiredException();
      }
      fresh = current;
    } catch (error) {
      throw ProfileUpdateException(_errorMessage(error));
    }
    if (isCurrentUser?.call() == false) {
      throw const ProfileUpdateException(
        'Your session changed. Reopen your profile.',
      );
    }

    final latest = FccUserModel.fromJson(fresh);
    final writes =
        <({ProfileSection section, String path, Map<String, Object?> body})>[];
    void add(ProfileSection section, String path, Map<String, Object?> body) {
      writes.add((section: section, path: path, body: body));
    }

    if (usernameChanged) {
      add(ProfileSection.username, '/update-my-username', {
        'username': draft.username.trim(),
      });
    }
    final about = <String, Object?>{
      if (draft.name != original.name) 'name': draft.name,
      if (draft.location != original.location) 'location': draft.location ?? '',
      if (draft.about != original.about) 'about': draft.about ?? '',
    };
    if (about.isNotEmpty) {
      add(ProfileSection.about, '/update-my-about', about);
    }
    final socials = _changedFields(_socials(original), _socials(draft));
    if (socials.isNotEmpty) {
      add(ProfileSection.socials, '/update-my-socials', {
        ..._socials(latest),
        ...socials,
      });
    }
    final oldPortfolio = original.portfolio.map((p) => p.toJson()).toList();
    final newPortfolio = draft.portfolio.map((p) => p.toJson()).toList();
    // Images are not editable here. Only text fields can change existing rows.
    final portfolio = _mergeRows(
      _rows(fresh['portfolio']),
      oldPortfolio,
      newPortfolio,
      fields: const ['title', 'description', 'url'],
    );
    if (portfolio != null) {
      add(ProfileSection.portfolio, '/update-my-portfolio', {
        'portfolio': portfolio,
      });
    }
    final experience = _mergeRows(
      _rows(fresh['experience']),
      original.experience.map((p) => p.toJson()).toList(),
      draft.experience.map((p) => p.toJson()).toList(),
      fields: const [
        'title',
        'company',
        'location',
        'startDate',
        'endDate',
        'description',
      ],
    );
    if (experience != null) {
      add(ProfileSection.experience, '/update-my-experience', {
        'experience': experience,
      });
    }
    final privacy = _changedFields(
      original.profileUI.toJson(),
      draft.profileUI.toJson(),
    );
    if (privacy.isNotEmpty) {
      add(ProfileSection.privacy, '/update-my-profileui', {
        'profileUI': {...latest.profileUI.toJson(), ...privacy},
      });
    }
    if (writes.isEmpty) return ProfileSaveResult(user: latest);

    final saved = <ProfileSection>[];
    ProfileSection? failedSection;
    String? errorMessage;
    for (final write in writes) {
      try {
        if (isCurrentUser?.call() == false) {
          throw SessionExpiredException();
        }
        final response = await _repo.update(
          write.path,
          write.body,
          expectedTokens: session,
        );
        if (response['type'] != 'success') {
          throw const ProfileUpdateException(
            'The server did not confirm this change.',
          );
        }
        saved.add(write.section);
      } catch (error) {
        failedSection = write.section;
        errorMessage = _errorMessage(error);
        break;
      }
    }

    FccUserModel? user;
    var refreshFailed = false;
    try {
      final response = await _repo.currentUser(expectedTokens: session);
      if (response == null ||
          response['id'] != original.id ||
          isCurrentUser?.call() == false) {
        throw SessionExpiredException();
      }
      user = FccUserModel.fromJson(response);
    } catch (error) {
      refreshFailed = true;
      errorMessage ??=
          'Your changes were saved, but your profile could not be refreshed. Refresh before editing again.';
    }
    return ProfileSaveResult(
      user: user,
      savedSections: saved,
      failedSection: failedSection,
      errorMessage: errorMessage,
      refreshFailed: refreshFailed,
    );
  }

  static String? usernameError(String value) {
    final username = value.trim();
    if (username.length < 3) return 'Use at least 3 characters.';
    if (username.length > 1000) return 'Use 1,000 characters or fewer.';
    if (!RegExp(r'^[a-zA-Z0-9_+\-]+$').hasMatch(username)) {
      return 'Use letters, numbers, hyphens, underscores, or plus signs.';
    }
    final prefix = RegExp(r'^[+\-]?\d+').firstMatch(username)?.group(0);
    final number = prefix == null ? null : int.tryParse(prefix);
    if (number != null && number >= 100 && number <= 599) {
      return 'Usernames starting with an HTTP status code are reserved.';
    }
    return null;
  }

  static String? socialUrlError(String value, String field) {
    if (value.length > 1024) return 'Use 1,024 characters or fewer.';
    final error = _urlError(value);
    if (error != null || value.trim().isEmpty) return error;
    final domains = switch (field) {
      'githubProfile' => const ['github.com'],
      'linkedin' => const ['linkedin.com'],
      'twitter' => const ['twitter.com', 'x.com'],
      'bluesky' => const ['bsky.app'],
      _ => const <String>[],
    };
    final host = Uri.parse(value.trim()).host.toLowerCase();
    if (domains.isNotEmpty &&
        !domains.any((domain) => host == domain || host.endsWith('.$domain'))) {
      return 'Use a ${domains.join(' or ')} profile URL.';
    }
    return null;
  }

  static String? _urlError(String value) {
    if (value.trim().isEmpty) return null;
    final uri = Uri.tryParse(value.trim());
    if (uri == null ||
        !const ['http', 'https'].contains(uri.scheme) ||
        uri.host.isEmpty ||
        uri.userInfo.isNotEmpty ||
        RegExp(r'\s').hasMatch(value.trim())) {
      return 'Enter a complete https:// or http:// URL.';
    }
    return null;
  }

  static String? _requiredText(String value, String label) {
    if (value.trim().length < 2) {
      return '$label must contain at least 2 characters.';
    }
    if (value.length > 144) return 'Use 144 characters or fewer.';
    return null;
  }

  static int? _month(String value) {
    final match = RegExp(r'^(0[1-9]|1[0-2])/(\d{4})$').firstMatch(value);
    if (match == null || int.parse(match[2]!) == 0) return null;
    return int.parse(match[2]!) * 12 + int.parse(match[1]!);
  }

  static String? _dateError(String value, {required bool isRequired}) {
    if (value.isEmpty && !isRequired) return null;
    return _month(value) == null ? 'Enter a valid date as MM/YYYY.' : null;
  }

  static Map<String, String> _socials(FccUserModel user) => {
    'githubProfile': user.githubProfile?.trim() ?? '',
    'linkedin': user.linkedin?.trim() ?? '',
    'twitter': user.twitter?.trim() ?? '',
    'bluesky': user.bluesky?.trim() ?? '',
    'website': user.website?.trim() ?? '',
  };

  static Map<String, Object?> _changedFields(
    Map<String, Object?> before,
    Map<String, Object?> after,
  ) => {
    for (final entry in after.entries)
      if (!_equal.equals(before[entry.key], entry.value))
        entry.key: entry.value,
  };

  static List<Map<String, dynamic>> _rows(Object? value) => value is List
      ? value
            .whereType<Map<Object?, Object?>>()
            .map((row) => Map<String, dynamic>.from(row))
            .toList()
      : [];

  static List<Map<String, Object?>>? _mergeRows(
    List<Map<String, dynamic>> latest,
    List<Map<String, dynamic>> original,
    List<Map<String, dynamic>> draft, {
    required List<String> fields,
  }) {
    if (_equal.equals(original, draft)) return null;
    final originals = {for (final row in original) row['id']: row};
    final drafts = {for (final row in draft) row['id']: row};
    final removed = originals.keys
        .where((id) => !drafts.containsKey(id))
        .toSet();
    final updates = <Object?, Map<String, Object?>>{};
    for (final row in draft) {
      final old = originals[row['id']];
      final changes = <String, Object?>{
        for (final field in fields)
          if (old == null || (old[field] ?? '') != (row[field] ?? ''))
            field: row[field] ?? '',
      };
      if (old == null || changes.isNotEmpty) updates[row['id']] = changes;
    }
    if (removed.isEmpty && updates.isEmpty) return null;
    final result = <Map<String, Object?>>[];
    final existing = <Object?>{};
    for (final row in latest) {
      if (removed.contains(row['id'])) continue;
      existing.add(row['id']);
      result.add({...row, ...?updates[row['id']]});
    }
    for (final row in draft) {
      if (existing.contains(row['id']) || !updates.containsKey(row['id'])) {
        continue;
      }
      if (originals.containsKey(row['id'])) {
        throw const ProfileUpdateException(
          'An item was removed elsewhere. Refresh your profile before saving.',
        );
      }
      result.add({
        'id': row['id'],
        ...updates[row['id']]!,
        if (fields.contains('url')) 'image': '',
      });
    }
    return result;
  }

  static String _errorMessage(Object error) {
    if (error is ProfileUpdateException) return error.message;
    if (error is SessionChangedException) {
      return 'Your session changed. Reopen your profile before saving.';
    }
    if (error is SessionExpiredException) {
      return 'Your session expired. Sign in again to save your profile.';
    }
    if (error is DioException) {
      final data = error.response?.data;
      final message = data is Map ? data['message'] : null;
      switch (message) {
        case 'flash.username-taken':
          return 'This username is already taken. Choose another one.';
        case 'flash.username-restricted':
          return 'This username is reserved. Choose another one.';
        case 'flash.username-used':
          return 'This username is already yours. Refresh your profile and try again.';
      }
      if (error.response?.statusCode == 403) {
        return 'Your session could not be verified. Sign in again and retry.';
      }
      if (error.response?.statusCode == 400) {
        return 'The server rejected these details. Check the fields and try again.';
      }
      if (error.response == null) {
        return 'Unable to reach freeCodeCamp. Check your connection and try again.';
      }
    }
    return 'Unable to save your profile. Please try again.';
  }
}
