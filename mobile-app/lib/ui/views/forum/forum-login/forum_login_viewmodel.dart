import 'package:flutter/material.dart' show BuildContext, Navigator, TextEditingController;
import 'package:freecodecamp/app/app.locator.dart';
import 'package:freecodecamp/enums/dialog_type.dart';
import 'package:freecodecamp/ui/views/forum/forum_connect.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

import '../../../widgets/setup_dialog_ui.dart';

import 'dart:developer' as dev;
import 'dart:convert';

class ForumLoginModel extends BaseViewModel {
  late String _baseUrl;

  final _nameController = TextEditingController();
  TextEditingController get nameController => _nameController;

  final _passwordController = TextEditingController();
  TextEditingController get passwordController => _passwordController;

  final _dialogService = locator<DialogService>();

  bool _hasAuthError = false;
  bool get hasAuthError => _hasAuthError;

  bool _hasUsernameError = false;
  bool get hasUsernameError => _hasUsernameError;

  bool _hasPasswordError = false;
  bool get hasPasswordError => _hasPasswordError;

  late String _errorMessage;
  String get errorMessage => _errorMessage;

  bool _isLoggedIn = false;
  bool get isLoggedIn => _isLoggedIn;

  late bool _fromCreatePost;

  late BuildContext _context;

  void initState(BuildContext context, bool fromPost) async {
    _errorMessage = '';
    _isLoggedIn = await checkLoggedIn();
    _baseUrl = await ForumConnect.getCurrentUrl();
    _fromCreatePost = fromPost;
    _context = context;
    notifyListeners();
    if (!_isLoggedIn) {
      setupDialogUi();
    }
  }

  Future<dynamic> getCSRF() async {
    final response =
        await http.get(Uri.parse('$_baseUrl/session/csrf'), headers: {
      'X-CSRF-Token': 'undefined',
      'Referer': _baseUrl,
      'X-Requested-With': 'XMLHttpRequest'
    });

    if (response.statusCode == 200) {
      dev.log('Got CSRF token!');
    } else if (response.statusCode == 403) {
      throw Exception('403 error');
    } else {
      throw Exception('Error during fetch status code:${response.statusCode}');
    }
    String? csrf = jsonDecode(response.body)['csrf'];
    String headers = jsonEncode(response.headers);
    dynamic cookie = jsonDecode(headers)['set-cookie'];
    return [csrf, cookie];
  }

  Future show2AuthDialog(csrf, username, password, cookie) async {
    DialogResponse? response = await _dialogService.showCustomDialog(
        variant: DialogType.authform,
        title: 'Two-Factor Authentication',
        description: 'Please enter the authentication code from your app:',
        data: DialogType.authform);

    if (response!.confirmed && response.data.length == 6) {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String authCode = response.data;
      prefs.setString('authCode', authCode);

      discourseAuth2(csrf, username, password, cookie);
    }
  }

  Future showPasswordResetDialog() async {
    DialogResponse? res = await _dialogService.showCustomDialog(
        variant: DialogType.inputForm,
        title: 'Password Reset',
        description:
            "Enter your username or email address, and we'll send you a password reset email.",
        mainButtonTitle: 'Reset password',
        data: DialogType.inputForm);

    if (res!.confirmed) {
      String login = res.data;

      Map<String, String> payload = {'login': login};

      final response = await ForumConnect.connectAndPost(
          '/session/forgot_password', {}, payload);

      bool success = jsonDecode(response.body)['user_found'];

      showPasswodResetStateDialog(success);
    }
  }

  Future showPasswodResetStateDialog(bool success) async {
    // ignore: unused_local_variable
    DialogResponse? res = await _dialogService.showCustomDialog(
        variant: DialogType.buttonForm2,
        title: success ? 'Success' : 'Error',
        description: success
            ? 'An email will be sent shortly with instructions on how to reset your password.'
            : 'We could not find an account linked to that email address or username.',
        mainButtonTitle: 'OK',
        data: DialogType.buttonForm2);
  }

  bool noAuthError(authBody) {
    Map<String, dynamic> body = json.decode(authBody);
    if (body.containsKey('error')) {
      return false;
    }
    return true;
  }

  bool hasAuth2Enabled(authBody) {
    Map<String, dynamic> body = json.decode(authBody);

    if (body['reason'] == 'invalid_second_factor_method') {
      return true;
    }
    return false;
  }

  Future<bool> checkLoggedIn() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getBool('loggedIn') ?? false;
  }

  Future<void> discourseAuth2(csrf, username, password, cookie) async {
    Map<String, String> headers = {
      'X-CSRF-Token': csrf,
      'Cookie': cookie,
      'X-Requested-With': 'XMLHttpRequest',
      'Content-Type': 'application/x-www-form-urlencoded; charset=UTF-8'
    };

    SharedPreferences prefs = await SharedPreferences.getInstance();

    if (prefs.getString('authCode') != null) {
      String authCode = prefs.get('authCode') as String;

      String creds = '?login=$username&password=$password';
      String auth = '&second_factor_token=$authCode&second_factor_method=1';
      String paramters = '$creds$auth';

      final response = await http.post(Uri.parse('$_baseUrl/session$paramters'),
          headers: headers);

      if (response.statusCode == 200) {
        if (noAuthError(response.body)) {
          prefs.setBool('loggedIn', true);
          prefs.setString('username', username);
          _isLoggedIn = prefs.getBool('loggedIn') as bool;
          notifyListeners();
          if (!_fromCreatePost) {
            Navigator.pop(_context);
          }
        } else {
          show2AuthDialog(csrf, username, password, cookie);
        }
      } else {
        dev.log(response.body.toString());
        show2AuthDialog(csrf, username, password, cookie);
      }

      prefs.remove('authCode');
    } else {
      show2AuthDialog(csrf, username, password, cookie);
    }
  }

  Future<dynamic> discourseAuth(csrf, username, password, cookie) async {
    Map<String, String> headers = {
      'X-CSRF-Token': csrf,
      'Cookie': cookie,
      'X-Requested-With': 'XMLHttpRequest',
      'Content-Type': 'application/x-www-form-urlencoded; charset=UTF-8'
    };

    final response = await http.post(
        Uri.parse('$_baseUrl/session?login=$username&password=$password'),
        headers: headers);

    if (response.statusCode == 200) {
      if (noAuthError(response.body)) {
        SharedPreferences prefs = await SharedPreferences.getInstance();

        prefs.setBool('loggedIn', true);
        prefs.setString('username', username);
        _isLoggedIn = prefs.getBool('loggedIn') as bool;

        notifyListeners();
        if (!_fromCreatePost) {
          Navigator.pop(_context);
        }
      } else {
        if (hasAuth2Enabled(response.body)) {
          show2AuthDialog(csrf, username, password, cookie);
        }
        _hasPasswordError = false;
        _hasUsernameError = false;
        _hasAuthError = true;
        _errorMessage = json.decode(response.body)['error'];
        notifyListeners();
      }
      return response.body;
    }
  }

  Future<void> login(String username, String password) async {
    if (username.isEmpty) {
      _hasPasswordError = false;
      _hasAuthError = false;
      _hasUsernameError = true;
      _errorMessage = 'Please fill in a username';
      notifyListeners();
    } else if (password.isEmpty) {
      _hasUsernameError = false;
      _hasAuthError = false;
      _hasPasswordError = true;
      _errorMessage = 'Please fill in a password';
      notifyListeners();
    } else {
      notifyListeners();
      getCSRF().then(
          (keys) => {discourseAuth(keys[0], username, password, keys[1])});
    }
  }
}
