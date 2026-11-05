import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:freecodecamp/auth/models/user_model.dart';
import 'package:freecodecamp/auth/services/profile_service.dart';
import 'package:freecodecamp/services/auth_service.dart';
import 'package:freecodecamp/utils/riverpod.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'profile_visibility_viewmodel.freezed.dart';
part 'profile_visibility_viewmodel.g.dart';

@freezed
abstract class ProfileVisibilityState with _$ProfileVisibilityState {
  const ProfileVisibilityState._();

  const factory ProfileVisibilityState({
    required FccUserModel original,
    required ProfileUI draft,
    @Default(false) bool saving,
    @Default(false) bool needsRefresh,
    String? error,
  }) = _ProfileVisibilityState;

  bool get isDirty => original.profileUI != draft;
}

@Riverpod(retry: noRetry)
class ProfileVisibilityNotifier extends _$ProfileVisibilityNotifier {
  var _session = 0;
  List<ProfileSection> _pendingSavedSections = const [];

  @override
  ProfileVisibilityState? build() {
    _session++;
    ref.watch(authProvider.select((value) => value.value?.id));
    final user = ref.read(authProvider).value;
    _pendingSavedSections = const [];
    return user == null
        ? null
        : ProfileVisibilityState(original: user, draft: user.profileUI);
  }

  void update(ProfileUI draft) {
    final current = state;
    if (current == null || current.saving || current.needsRefresh) return;
    state = current.copyWith(draft: draft, error: null);
  }

  Future<bool> save() async {
    final current = state;
    if (current == null || current.saving || current.needsRefresh) return false;
    final session = _session;
    state = current.copyWith(saving: true, error: null);
    try {
      final result = await ref
          .read(authProvider.notifier)
          .saveProfile(
            original: current.original,
            draft: current.original.copyWith(profileUI: current.draft),
          );
      if (!_sameSession(current.original.id, session)) return false;
      final canonical = result.user;
      _pendingSavedSections = result.refreshFailed
          ? result.savedSections
          : const [];
      var next = current.copyWith(
        saving: false,
        needsRefresh: result.refreshFailed,
        error: result.errorMessage,
      );
      if (canonical != null) {
        final rebased = ref
            .read(profileServiceProvider)
            .rebaseDraft(
              original: current.original,
              draft: current.original.copyWith(profileUI: current.draft),
              canonical: canonical,
              savedSections: result.savedSections,
            );
        next = next.copyWith(original: canonical, draft: rebased.profileUI);
      }
      state = next;
      return result.isSuccess;
    } catch (_) {
      if (_sameSession(current.original.id, session)) {
        state = current.copyWith(
          error: 'Could not save your visibility settings. Please try again.',
        );
      }
      return false;
    }
  }

  Future<void> refresh() async {
    final current = state;
    if (current == null || current.saving) return;
    final session = _session;
    state = current.copyWith(saving: true, error: null);
    try {
      await ref.read(authProvider.notifier).refresh();
      if (!_sameSession(current.original.id, session)) return;
      final canonical = ref.read(authProvider).value;
      if (canonical == null || canonical.id != current.original.id) return;
      final rebased = ref
          .read(profileServiceProvider)
          .rebaseDraft(
            original: current.original,
            draft: current.original.copyWith(profileUI: current.draft),
            canonical: canonical,
            savedSections: _pendingSavedSections,
          );
      _pendingSavedSections = const [];
      state = current.copyWith(
        original: canonical,
        draft: rebased.profileUI,
        saving: false,
        needsRefresh: false,
        error: null,
      );
    } catch (_) {
      if (_sameSession(current.original.id, session)) {
        state = current.copyWith(
          error: 'Could not refresh your profile. Please try again.',
        );
      }
    }
  }

  bool _sameSession(String userId, int session) =>
      ref.mounted &&
      session == _session &&
      state?.original.id == userId &&
      ref.read(authProvider).value?.id == userId;
}
