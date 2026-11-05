import 'package:freecodecamp/auth/controllers/profile_editor_controller.dart';
import 'package:freecodecamp/auth/models/user_model.dart';
import 'package:freecodecamp/utils/riverpod.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'profile_experience_viewmodel.freezed.dart';
part 'profile_experience_viewmodel.g.dart';

@freezed
abstract class ProfileExperienceState with _$ProfileExperienceState {
  const ProfileExperienceState._();

  const factory ProfileExperienceState({
    required String userId,
    required Experience original,
    required Experience draft,
    required bool isNew,
    @Default(true) bool available,
    @Default(false) bool saving,
    @Default(false) bool navigationDirty,
    @Default({}) Map<String, String> errors,
  }) = _ProfileExperienceState;

  bool get isDirty => draft != original;
}

@Riverpod(retry: noRetry)
class ProfileExperienceNotifier extends _$ProfileExperienceNotifier {
  @override
  ProfileExperienceState? build(String? experienceId) {
    final editor = ref.read(profileEditorProvider);
    ref.listen(profileEditorProvider, (_, next) {
      final current = state;
      if (current == null) return;
      state = current.copyWith(
        available: _matches(current, next),
        saving: next?.saving ?? false,
        navigationDirty: next?.isDirty ?? false,
      );
    });
    if (editor == null) return null;
    Experience? experience;
    if (experienceId == null) {
      experience = ref.read(profileEditorProvider.notifier).newExperience();
    } else {
      for (final entry in editor.draft.experience) {
        if (entry.id == experienceId) {
          experience = entry;
          break;
        }
      }
    }
    if (experience == null) return null;
    return ProfileExperienceState(
      userId: editor.original.id,
      original: experience,
      draft: experience,
      isNew: experienceId == null,
      saving: editor.saving,
      navigationDirty: editor.isDirty,
    );
  }

  bool _matches(ProfileExperienceState current, ProfileEditorState? editor) =>
      editor != null &&
      editor.original.id == current.userId &&
      (current.isNew ||
          editor.draft.experience.any(
            (entry) => entry.id == current.original.id,
          ));

  void update({
    String? title,
    String? company,
    String? location,
    String? startDate,
    String? endDate,
    String? description,
  }) {
    final current = state;
    final editor = ref.read(profileEditorProvider);
    if (current == null || !_matches(current, editor) || editor!.saving) return;
    final errors = {...current.errors};
    if (title != null) errors.remove('title');
    if (company != null) errors.remove('company');
    if (location != null) errors.remove('location');
    if (startDate != null) errors.remove('startDate');
    if (endDate != null) errors.remove('endDate');
    if (description != null) errors.remove('description');
    state = current.copyWith(
      draft: current.draft.copyWith(
        title: title ?? current.draft.title,
        company: company ?? current.draft.company,
        location: location ?? current.draft.location,
        startDate: startDate ?? current.draft.startDate,
        endDate: endDate ?? current.draft.endDate,
        description: description ?? current.draft.description,
      ),
      errors: errors,
    );
  }

  void dismissError() {
    final current = state;
    if (current == null) return;
    state = current.copyWith(errors: {...current.errors}..remove('form'));
  }

  bool save() {
    final current = state;
    if (current == null ||
        !_matches(current, ref.read(profileEditorProvider))) {
      return false;
    }
    final errors = ref
        .read(profileEditorProvider.notifier)
        .saveExperience(current.draft);
    state = state?.copyWith(errors: errors);
    return errors.isEmpty;
  }

  bool delete() {
    final current = state;
    final editor = ref.read(profileEditorProvider);
    if (current == null || current.isNew || !_matches(current, editor)) {
      return false;
    }
    if (editor!.saving || editor.needsRefresh) {
      state = current.copyWith(
        errors: {
          ...current.errors,
          'form': 'Reopen your profile to delete this experience.',
        },
      );
      return false;
    }
    ref
        .read(profileEditorProvider.notifier)
        .deleteExperience(current.original.id);
    return true;
  }
}
