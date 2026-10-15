import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mobile_app_new/settings/ui/settings/delete_account/delete_account_view.dart';
import 'package:mobile_app_new/settings/ui/settings/settings_view.dart';

part 'settings.g.dart';

const settingsPath = '/settings';
const settingsDeleteAccountPath = '/settings/delete-account';

@TypedGoRoute<SettingsRoute>(path: settingsPath)
class SettingsRoute extends GoRouteData with $SettingsRoute {
  const SettingsRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) =>
      const SettingsView();
}

@TypedGoRoute<SettingsDeleteAccountRoute>(path: settingsDeleteAccountPath)
class SettingsDeleteAccountRoute extends GoRouteData
    with $SettingsDeleteAccountRoute {
  const SettingsDeleteAccountRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) =>
      const DeleteAccountView();
}
