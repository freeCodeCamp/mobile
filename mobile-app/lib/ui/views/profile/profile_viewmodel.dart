import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:freecodecamp/core/providers/service_providers.dart';
import 'package:freecodecamp/service/authentication/authentication_service.dart';

class ProfileViewModel {
  ProfileViewModel(this.auth);

  final AuthenticationService auth;
}

final profileViewModelProvider = Provider<ProfileViewModel>((ref) {
  final auth = ref.watch(authenticationServiceProvider);
  return ProfileViewModel(auth);
});
