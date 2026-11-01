import 'dart:async';
import 'dart:math';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:freecodecamp/auth/models/user_model.dart';
import 'package:freecodecamp/auth/services/profile_service.dart';
import 'package:freecodecamp/services/auth_service.dart';
import 'package:freecodecamp/utils/riverpod.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'profile_editor_controller.freezed.dart';
part 'profile_editor_controller.g.dart';

@freezed
abstract class ProfileEditorState with _$ProfileEditorState {
  const ProfileEditorState._();

  const factory ProfileEditorState({
    required FccUserModel original,
    required FccUserModel draft,
    @Default(false) bool saving,
    @Default({}) Map<String, String> errors,
    String? errorMessage,
    @Default(false) bool needsRefresh,
    @Default(false) bool usernameChecking,
    bool? usernameAvailable,
  }) = _ProfileEditorState;

  bool get isDirty => draft != original;
}

@Riverpod(retry: noRetry)
class ProfileEditorNotifier extends _$ProfileEditorNotifier {
  Timer? _usernameTimer;
  var _usernameRequest = 0;
  var _session = 0;
  List<ProfileSection> _pendingSavedSections = const [];

  @override
  ProfileEditorState? build() {
    _session++;
    final userId = ref.watch(authProvider.select((value) => value.value?.id));
    final user = ref.read(authProvider).value;
    _pendingSavedSections = const [];
    ref.onDispose(() {
      _usernameTimer?.cancel();
      _usernameRequest++;
    });
    if (user == null || user.id != userId) return null;
    return ProfileEditorState(original: user, draft: user);
  }

  ProfileService get _service => ref.read(profileServiceProvider);

  void updateField(String field, String value) {
    final draft = state?.draft;
    if (draft == null) return;
    final updated = switch (field) {
      'username' => draft.copyWith(username: value),
      'name' => draft.copyWith(name: value),
      'location' => draft.copyWith(location: value),
      'about' => draft.copyWith(about: value),
      'githubProfile' => draft.copyWith(githubProfile: value),
      'linkedin' => draft.copyWith(linkedin: value),
      'twitter' => draft.copyWith(twitter: value),
      'bluesky' => draft.copyWith(bluesky: value),
      'website' => draft.copyWith(website: value),
      _ => draft,
    };
    updateDraft(updated);
  }

  void updateDraft(FccUserModel draft) {
    final current = state;
    if (current == null || current.saving || current.needsRefresh) return;
    if (draft.id != current.original.id) return;
    final before = current.draft.toJson();
    final after = draft.toJson();
    final errors = {...current.errors}
      ..removeWhere(
        (field, _) => !const DeepCollectionEquality().equals(
          before[field.split('.').first],
          after[field.split('.').first],
        ),
      );
    final usernameChanged = draft.username != current.draft.username;
    state = current.copyWith(
      draft: draft,
      errors: errors,
      errorMessage: null,
      usernameAvailable: usernameChanged ? null : current.usernameAvailable,
      usernameChecking: usernameChanged ? false : current.usernameChecking,
    );
    if (usernameChanged) {
      _usernameTimer?.cancel();
      _usernameRequest++;
      if (draft.username.trim().toLowerCase() !=
              current.original.username.toLowerCase() &&
          ProfileService.usernameError(draft.username) == null) {
        _usernameTimer = Timer(
          const Duration(milliseconds: 600),
          checkUsername,
        );
      }
    }
  }

  Future<void> checkUsername() async {
    final current = state;
    if (current == null || current.saving || current.needsRefresh) return;
    final username = current.draft.username;
    if (ProfileService.usernameError(username) != null) return;
    final request = ++_usernameRequest;
    state = current.copyWith(usernameChecking: true, usernameAvailable: null);
    try {
      final available = await _service.usernameAvailable(
        username,
        currentUsername: current.original.username,
      );
      if (!_sameSession(current.original.id) || request != _usernameRequest) {
        return;
      }
      final latest = state;
      if (latest == null || latest.draft.username != username) return;
      final errors = {...latest.errors}..remove('username');
      if (!available) {
        errors['username'] =
            'This username is unavailable. Choose another one.';
      }
      state = latest.copyWith(
        usernameChecking: false,
        usernameAvailable: available,
        errors: errors,
      );
    } catch (error) {
      if (!_sameSession(current.original.id) || request != _usernameRequest) {
        return;
      }
      state = state?.copyWith(
        usernameChecking: false,
        errorMessage: error is ProfileUpdateException
            ? error.message
            : 'Could not check this username. You can try again when saving.',
      );
    }
  }

  String _newId() {
    final random = Random.secure();
    return List.generate(
      12,
      (_) => random.nextInt(256).toRadixString(16).padLeft(2, '0'),
    ).join();
  }

  Portfolio newProject() => Portfolio(id: _newId());

  Experience newExperience() => Experience(
    id: _newId(),
    title: '',
    company: '',
    startDate: '',
    description: '',
  );

  Map<String, String> saveProject(Portfolio project) {
    final current = state;
    if (current == null || current.saving || current.needsRefresh) {
      return {'form': 'Reopen your profile to edit this project.'};
    }
    final projects = [...current.draft.portfolio];
    final index = projects.indexWhere((item) => item.id == project.id);
    if (index < 0) {
      projects.add(project);
    } else {
      projects[index] = project;
    }
    final draft = current.draft.copyWith(portfolio: projects);
    final errors = _rowErrors(draft, 'portfolio.${project.id}.');
    if (errors.isEmpty) updateDraft(draft);
    return errors;
  }

  void deleteProject(String id) {
    final current = state;
    if (current == null) return;
    updateDraft(
      current.draft.copyWith(
        portfolio: current.draft.portfolio
            .where((item) => item.id != id)
            .toList(),
      ),
    );
  }

  Map<String, String> saveExperience(Experience experience) {
    final current = state;
    if (current == null || current.saving || current.needsRefresh) {
      return {'form': 'Reopen your profile to edit this experience.'};
    }
    final entries = [...current.draft.experience];
    final index = entries.indexWhere((item) => item.id == experience.id);
    if (index < 0) {
      entries.add(experience);
    } else {
      entries[index] = experience;
    }
    final draft = current.draft.copyWith(experience: entries);
    final errors = _rowErrors(draft, 'experience.${experience.id}.');
    if (errors.isEmpty) updateDraft(draft);
    return errors;
  }

  void deleteExperience(String id) {
    final current = state;
    if (current == null) return;
    updateDraft(
      current.draft.copyWith(
        experience: current.draft.experience
            .where((item) => item.id != id)
            .toList(),
      ),
    );
  }

  Map<String, String> _rowErrors(FccUserModel draft, String prefix) => {
    for (final entry
        in _service.validate(draft, original: state?.original).entries)
      if (entry.key.startsWith(prefix))
        entry.key.substring(prefix.length): entry.value,
  };

  Future<bool> save() async {
    var current = state;
    if (current == null || current.saving) return false;
    _usernameTimer?.cancel();
    _usernameRequest++;
    final userId = current.original.id;
    final session = _session;
    state = current.copyWith(
      saving: true,
      usernameChecking: false,
      errorMessage: null,
    );
    try {
      if (current.needsRefresh) {
        await ref.read(authProvider.notifier).refresh();
        if (!_sameSession(userId, session)) return false;
        final canonical = ref.read(authProvider).value;
        if (canonical == null || canonical.id != current.original.id) {
          throw const ProfileUpdateException(
            'Your session changed. Reopen your profile.',
          );
        }
        current = current.copyWith(
          original: canonical,
          draft: _service.rebaseDraft(
            original: current.original,
            draft: current.draft,
            canonical: canonical,
            savedSections: _pendingSavedSections,
          ),
          needsRefresh: false,
          errorMessage: null,
        );
        _pendingSavedSections = const [];
        state = current.copyWith(saving: true);
      }
      final errors = _service.validate(
        current.draft,
        original: current.original,
      );
      if (errors.isNotEmpty) {
        state = current.copyWith(
          errors: errors,
          saving: false,
          errorMessage: null,
        );
        return false;
      }
      if (!current.isDirty) {
        state = current.copyWith(
          saving: false,
          errors: const {},
          errorMessage: null,
        );
        return true;
      }
      final result = await ref
          .read(authProvider.notifier)
          .saveProfile(original: current.original, draft: current.draft);
      if (!_sameSession(userId, session)) return false;
      _pendingSavedSections = result.savedSections;
      state = state?.copyWith(needsRefresh: true);
      final canonical = result.user;
      if (canonical != null) {
        state = current.copyWith(
          original: canonical,
          draft: _service.rebaseDraft(
            original: current.original,
            draft: current.draft,
            canonical: canonical,
            savedSections: result.savedSections,
          ),
          saving: false,
          errors: const {},
          errorMessage: result.savedSections.isNotEmpty && !result.isSuccess
              ? 'Some changes were saved. ${result.errorMessage ?? 'Please retry the remaining changes.'}'
              : result.errorMessage,
          needsRefresh: false,
        );
        _pendingSavedSections = const [];
      } else {
        state = current.copyWith(
          saving: false,
          needsRefresh: true,
          errorMessage:
              '${result.errorMessage ?? 'Could not refresh your profile.'} Tap Save to refresh and retry any remaining changes.',
        );
      }
      return result.isSuccess && canonical != null;
    } on ProfileValidationException catch (error) {
      if (_sameSession(userId, session)) {
        state = state?.copyWith(
          saving: false,
          errors: error.errors,
          errorMessage: null,
        );
      }
    } catch (error) {
      if (_sameSession(userId, session)) {
        state = state?.copyWith(
          saving: false,
          errorMessage: error is ProfileUpdateException
              ? error.message
              : 'Unable to save your profile. Please try again.',
        );
      }
    }
    return false;
  }

  bool _sameSession(String userId, [int? session]) =>
      ref.mounted &&
      state?.original.id == userId &&
      (session == null || session == _session) &&
      ref.read(authProvider).value?.id == userId;
}
