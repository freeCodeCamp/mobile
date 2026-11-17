import 'package:freecodecamp/auth/controllers/profile_editor_controller.dart';
import 'package:freecodecamp/utils/riverpod.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:jiffy/jiffy.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'profile_edit_viewmodel.freezed.dart';
part 'profile_edit_viewmodel.g.dart';

@freezed
abstract class ProfileEditPresentation with _$ProfileEditPresentation {
  const factory ProfileEditPresentation({
    required Map<String, String> fields,
    required String usernameHint,
    required Map<String, String> experienceDetails,
    String? errorMessage,
  }) = _ProfileEditPresentation;
}

@Riverpod(retry: noRetry)
ProfileEditPresentation? profileEditPresentation(Ref ref) {
  final editor = ref.watch(profileEditorProvider);
  if (editor == null) return null;
  final user = editor.draft;
  final errors = editor.errors.length;
  return ProfileEditPresentation(
    fields: {
      'username': user.username,
      'name': user.name,
      'location': user.location ?? '',
      'about': user.about ?? '',
      'githubProfile': user.githubProfile ?? '',
      'linkedin': user.linkedin ?? '',
      'twitter': user.twitter ?? '',
      'bluesky': user.bluesky ?? '',
      'website': user.website ?? '',
    },
    usernameHint: [
      'Your profile link: freecodecamp.org/${user.username}',
      if (editor.usernameChecking) 'Checking availability…',
      if (editor.usernameAvailable == true &&
          user.username != editor.original.username)
        'Username available.',
    ].join('\n'),
    experienceDetails: {
      for (final experience in user.experience)
        experience.id: [
          experience.company,
          if (experience.startDate.isNotEmpty)
            '${_monthYear(experience.startDate)} – ${experience.endDate.isEmpty ? 'Present' : _monthYear(experience.endDate)}',
        ].where((value) => value.isNotEmpty).join(' · '),
    },
    errorMessage:
        editor.errorMessage ??
        (errors == 0
            ? null
            : '$errors ${errors == 1 ? 'field needs' : 'fields need'} a fix before you can save.'),
  );
}

String _monthYear(String value) {
  final parts = value.split('/');
  final month = parts.length == 2 ? int.tryParse(parts[0]) : null;
  final year = parts.length == 2 ? int.tryParse(parts[1]) : null;
  if (month == null || year == null || month < 1 || month > 12) return value;
  return Jiffy.parseFromDateTime(
    DateTime(year, month),
  ).format(pattern: 'MMM yyyy');
}
