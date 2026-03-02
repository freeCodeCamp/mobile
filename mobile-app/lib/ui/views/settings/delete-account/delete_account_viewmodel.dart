import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:freecodecamp/core/navigation/app_navigator.dart';
import 'package:freecodecamp/core/navigation/app_snackbar.dart';
import 'package:freecodecamp/core/providers/service_providers.dart';
import 'package:freecodecamp/extensions/i18n_extension.dart';
import 'package:freecodecamp/service/authentication/authentication_service.dart';
import 'package:freecodecamp/service/dio_service.dart';

class DeleteAccountState {
  const DeleteAccountState({this.processing = false});

  final bool processing;

  DeleteAccountState copyWith({bool? processing}) {
    return DeleteAccountState(processing: processing ?? this.processing);
  }
}

class DeleteAccountNotifier extends Notifier<DeleteAccountState> {
  late AuthenticationService _authenticationService;
  final Dio _dio = DioService.dio;

  @override
  DeleteAccountState build() {
    _authenticationService = ref.watch(authenticationServiceProvider);
    return const DeleteAccountState();
  }

  void deleteAccount(BuildContext context) async {
    state = state.copyWith(processing: true);

    final confirmed = await showDialog<bool>(
      context: context,
      barrierDismissible: true,
      builder: (dialogContext) => AlertDialog(
        backgroundColor: const Color(0xFF0a0a23),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(0)),
        title: Text(context.t.settings_delete_account),
        content: Text(context.t.delete_account_are_you_sure),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(false),
            child: const Text('Cancel'),
          ),
          TextButton(
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            onPressed: () => Navigator.of(dialogContext).pop(true),
            child: Text(context.t.settings_delete_account),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      if (context.mounted) {
        showDialog(
          context: context,
          barrierDismissible: false,
          routeSettings: const RouteSettings(
            name: '/delete-account-dialog',
          ),
          builder: (context) {
            return PopScope(
              canPop: false,
              child: SimpleDialog(
                title: Text(
                  context.t.delete_account_deleting,
                ),
                contentPadding:
                    const EdgeInsets.fromLTRB(0.0, 12.0, 0.0, 24.0),
                backgroundColor: const Color(0xFF2A2A40),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(0),
                ),
                children: const [
                  Center(
                    child: CircularProgressIndicator(),
                  ),
                ],
              ),
            );
          },
        );
      }

      try {
        Response res = await _dio.post(
          '${AuthenticationService.baseApiURL}/account/delete',
          options: Options(
            headers: {
              'CSRF-Token': _authenticationService.csrfToken,
              'Cookie':
                  'jwt_access_token=${_authenticationService.jwtAccessToken}; _csrf=${_authenticationService.csrf};',
            },
          ),
        );

        if (res.statusCode == 200) {
          log('Account deleted');
          await _authenticationService.logout();
          AppNavigator.popUntil((route) => route.isFirst);
          AppSnackbar.show(
            title: context.t.delete_success,
            message: '',
          );
        } else {
          log('Account deletion failed');
          AppNavigator.pop();
          AppSnackbar.show(
            title: context.t.delete_failed,
            message: '',
          );
        }
      } catch (err) {
        AppNavigator.pop();
        AppSnackbar.show(
          title: context.t.delete_failed,
          message: '',
        );
      }
    }

    state = state.copyWith(processing: false);
  }
}

final deleteAccountProvider =
    NotifierProvider<DeleteAccountNotifier, DeleteAccountState>(
  DeleteAccountNotifier.new,
);
