import 'package:freecodecamp/auth/controllers/profile_editor_controller.dart';
import 'package:freecodecamp/auth/models/user_model.dart';
import 'package:freecodecamp/utils/riverpod.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'profile_project_viewmodel.freezed.dart';
part 'profile_project_viewmodel.g.dart';

@freezed
abstract class ProfileProjectState with _$ProfileProjectState {
  const ProfileProjectState._();

  const factory ProfileProjectState({
    required String userId,
    required Portfolio original,
    required Portfolio draft,
    required bool isNew,
    @Default(true) bool available,
    @Default(false) bool saving,
    @Default(false) bool navigationDirty,
    @Default({}) Map<String, String> errors,
  }) = _ProfileProjectState;

  bool get isDirty => draft != original;
}

@Riverpod(retry: noRetry)
class ProfileProjectNotifier extends _$ProfileProjectNotifier {
  @override
  ProfileProjectState? build(String? projectId) {
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
    Portfolio? project;
    if (projectId == null) {
      project = ref.read(profileEditorProvider.notifier).newProject();
    } else {
      for (final entry in editor.draft.portfolio) {
        if (entry.id == projectId) {
          project = entry;
          break;
        }
      }
    }
    if (project == null) return null;
    return ProfileProjectState(
      userId: editor.original.id,
      original: project,
      draft: project,
      isNew: projectId == null,
      saving: editor.saving,
      navigationDirty: editor.isDirty,
    );
  }

  bool _matches(ProfileProjectState current, ProfileEditorState? editor) =>
      editor != null &&
      editor.original.id == current.userId &&
      (current.isNew ||
          editor.draft.portfolio.any(
            (entry) => entry.id == current.original.id,
          ));

  void update({String? title, String? url, String? description}) {
    final current = state;
    final editor = ref.read(profileEditorProvider);
    if (current == null || !_matches(current, editor) || editor!.saving) return;
    final errors = {...current.errors};
    if (title != null) errors.remove('title');
    if (url != null) errors.remove('url');
    if (description != null) errors.remove('description');
    state = current.copyWith(
      draft: current.draft.copyWith(
        title: title ?? current.draft.title,
        url: url ?? current.draft.url,
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
        .saveProject(current.draft);
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
          'form': 'Reopen your profile to delete this project.',
        },
      );
      return false;
    }
    ref.read(profileEditorProvider.notifier).deleteProject(current.original.id);
    return true;
  }
}
