import 'package:flutter/material.dart';
import 'package:freecodecamp/widgets/dialog/confirm_dialog.dart';

Future<bool> showLogOutDialog(BuildContext context) => showConfirmDialog(
  context,
  title: 'Log out?',
  description: 'You’ll need to sign in again to access your account.',
  confirmLabel: 'Log out',
);
