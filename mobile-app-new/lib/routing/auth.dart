import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mobile_app_new/auth/ui/login/login_view.dart';
import 'package:mobile_app_new/auth/ui/profile/profile_view.dart';

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
