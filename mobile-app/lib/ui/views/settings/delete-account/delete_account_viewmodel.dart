import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:freecodecamp/app/app.locator.dart';
import 'package:freecodecamp/enums/dialog_type.dart';
import 'package:freecodecamp/extensions/i18n_extension.dart';
import 'package:freecodecamp/service/authentication/authentication_service.dart';
import 'package:freecodecamp/service/dio_service.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

class DeleteAccountViewModel extends BaseViewModel {
  final _authenticationService = locator<AuthenticationService>();
  final _navigator = locator<NavigationService>();
  final _snackbar = locator<SnackbarService>();
  final _dialogService = locator<DialogService>();

  final Dio _dio = DioService.dio;
  bool processing = false;

  void deleteAccount(BuildContext context) async {
    processing = true;
    DialogResponse? res = await _dialogService.showCustomDialog(
      barrierDismissible: true,
      variant: DialogType.deleteAccount,
      title: context.t.settings_delete_account,
      description: context.t.delete_account_are_you_sure,
      mainButtonTitle: context.t.settings_delete_account,
    );

    if (res?.confirmed == true) {
      showDialog(
        context: context,
        barrierDismissible: false,
        routeSettings: const RouteSettings(
          name: 'Delete account processing',
        ),
        builder: (context) {
          return WillPopScope(
            onWillPop: () async => false,
            child: SimpleDialog(
              title: Text(
                context.t.delete_account_deleting,
              ),
              contentPadding: const EdgeInsets.fromLTRB(0.0, 12.0, 0.0, 24.0),
              backgroundColor: const Color(0xFF2A2A40),
              children: const [
                Center(
                  child: CircularProgressIndicator(),
                ),
              ],
            ),
          );
        },
      );
      notifyListeners();

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
          _navigator.clearStackAndShow('/');
          _snackbar.showSnackbar(
            title: context.t.delete_success,
            message: '',
          );
        } else {
          log('Account deletion failed');
          _navigator.back();
          _snackbar.showSnackbar(
            title: context.t.delete_failed,
            message: '',
          );
        }
      } catch (err) {
        _navigator.back();
        _snackbar.showSnackbar(
          title: context.t.delete_failed,
          message: '',
        );
      }
    }

    processing = false;
    notifyListeners();
  }
}
