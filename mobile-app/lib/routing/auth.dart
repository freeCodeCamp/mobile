import 'package:flutter/material.dart';
import 'package:freecodecamp/auth/ui/account/account_view.dart';
import 'package:freecodecamp/auth/ui/login/login_view.dart';
import 'package:freecodecamp/auth/ui/profile/profile_view.dart';
import 'package:freecodecamp/auth/ui/profile_edit/profile_edit_view.dart';
import 'package:freecodecamp/auth/ui/profile_experience/profile_experience_view.dart';
import 'package:freecodecamp/auth/ui/profile_project/profile_project_view.dart';
import 'package:freecodecamp/auth/ui/profile_visibility/profile_visibility_view.dart';
import 'package:go_router/go_router.dart';

part 'auth.g.dart';

const loginPath = '/login';
const accountPath = '/account';
const profilePath = '/profile';
const editProfilePath = '/profile/edit';
const profileProjectPath = '/profile/edit/project';
const profileExperiencePath = '/profile/edit/experience';
const profileVisibilityPath = '/profile/visibility';

@TypedGoRoute<LoginRoute>(path: loginPath)
class LoginRoute extends GoRouteData with $LoginRoute {
  const LoginRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) => const LoginView();
}

@TypedGoRoute<AccountRoute>(path: accountPath)
class AccountRoute extends GoRouteData with $AccountRoute {
  const AccountRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) =>
      const AccountView();
}

@TypedGoRoute<ProfileRoute>(path: profilePath)
class ProfileRoute extends GoRouteData with $ProfileRoute {
  const ProfileRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) =>
      const ProfileView();
}

@TypedGoRoute<EditProfileRoute>(path: editProfilePath)
class EditProfileRoute extends GoRouteData with $EditProfileRoute {
  const EditProfileRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) =>
      const ProfileEditView();
}

@TypedGoRoute<ProfileProjectRoute>(path: profileProjectPath)
class ProfileProjectRoute extends GoRouteData with $ProfileProjectRoute {
  const ProfileProjectRoute({this.projectId});

  final String? projectId;

  @override
  Widget build(BuildContext context, GoRouterState state) =>
      ProfileProjectView(projectId: projectId);
}

@TypedGoRoute<ProfileExperienceRoute>(path: profileExperiencePath)
class ProfileExperienceRoute extends GoRouteData with $ProfileExperienceRoute {
  const ProfileExperienceRoute({this.experienceId});

  final String? experienceId;

  @override
  Widget build(BuildContext context, GoRouterState state) =>
      ProfileExperienceView(experienceId: experienceId);
}

@TypedGoRoute<ProfileVisibilityRoute>(path: profileVisibilityPath)
class ProfileVisibilityRoute extends GoRouteData with $ProfileVisibilityRoute {
  const ProfileVisibilityRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) =>
      const ProfileVisibilityView();
}
