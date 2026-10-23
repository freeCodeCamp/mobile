import 'package:flutter/material.dart';
import 'package:freecodecamp/auth/ui/login/login_view.dart';
import 'package:freecodecamp/auth/ui/profile/profile_view.dart';
import 'package:go_router/go_router.dart';

part 'auth.g.dart';

const loginPath = '/login';
const profilePath = '/profile';

@TypedGoRoute<LoginRoute>(path: loginPath)
class LoginRoute extends GoRouteData with $LoginRoute {
  const LoginRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) => const LoginView();
}

@TypedGoRoute<ProfileRoute>(path: profilePath)
class ProfileRoute extends GoRouteData with $ProfileRoute {
  const ProfileRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) =>
      const ProfileView();
}
