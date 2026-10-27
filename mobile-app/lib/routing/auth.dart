import 'package:flutter/material.dart';
import 'package:freecodecamp/auth/ui/account/account_view.dart';
import 'package:freecodecamp/auth/ui/login/login_view.dart';
import 'package:freecodecamp/auth/ui/profile/profile_view.dart';
import 'package:go_router/go_router.dart';

part 'auth.g.dart';

const loginPath = '/login';
const accountPath = '/account';
const profilePath = '/profile';

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
