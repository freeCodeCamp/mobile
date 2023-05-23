import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:freecodecamp/app/app.locator.dart';
import 'package:freecodecamp/service/authentication/authentication_service.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

class DeleteAccountViewModel extends BaseViewModel {
  final _authenticationService = locator<AuthenticationService>();
  final _navigator = locator<NavigationService>();
  final _snackbar = locator<SnackbarService>();

  final Dio _dio = Dio();
  bool processing = false;

  void deleteAccount() async {
    processing = true;
    notifyListeners();
    log('Deleting account');
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
        title: 'Your account has been successfully deleted',
        message: '',
      );
    } else {
      log('Account deletion failed');
      _snackbar.showSnackbar(title: 'Account deletion failed', message: '');
    }
    processing = false;
    notifyListeners();
  }
}
