import 'package:freecodecamp/auth/models/user_model.dart';

enum ProfileSection { username, about, socials, portfolio, experience, privacy }

class ProfileValidationException implements Exception {
  ProfileValidationException(Map<String, String> errors)
    : errors = Map.unmodifiable(errors);

  final Map<String, String> errors;
}

class ProfileUpdateException implements Exception {
  const ProfileUpdateException(this.message, {this.field});

  final String message;
  final String? field;

  @override
  String toString() => message;
}

class ProfileSaveResult {
  ProfileSaveResult({
    this.user,
    List<ProfileSection> savedSections = const [],
    this.failedSection,
    this.errorMessage,
    this.refreshFailed = false,
  }) : savedSections = List.unmodifiable(savedSections);

  final FccUserModel? user;
  final List<ProfileSection> savedSections;
  final ProfileSection? failedSection;
  final String? errorMessage;
  final bool refreshFailed;

  bool get isSuccess => errorMessage == null && !refreshFailed;
}
