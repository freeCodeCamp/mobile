import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:stacked/stacked.dart';
import 'dart:developer' as dev;

class ForumLoginModel extends BaseViewModel {
  static String baseUrl = 'https://forum.freecodecamp.org';

  final _nameController = TextEditingController();
  TextEditingController get nameController => _nameController;

  final _passwordController = TextEditingController();
  TextEditingController get passwordController => _passwordController;

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

  void initState() async {
    _errorMessage = '';
    _isLoggedIn = await checkLoggedIn();
    notifyListeners();
  }

  Future<dynamic> getCSRF() async {
    final response =
        await http.get(Uri.parse(baseUrl + '/session/csrf'), headers: {
      'X-CSRF-Token': 'undefined',
      'Referer': baseUrl,
      'X-Requested-With': 'XMLHttpRequest'
    });

    if (response.statusCode == 200) {
      dev.log('Got CSRF token!');
      dev.log(response.headers.toString());
    } else if (response.statusCode == 403) {
      throw Exception('403 error');
    } else {
      throw Exception(
          'Error during fetch status code:' + response.statusCode.toString());
    }
    String? csrf = jsonDecode(response.body)['csrf'];
    String headers = jsonEncode(response.headers);
    dynamic cookie = jsonDecode(headers)['set-cookie'];
    return [csrf, cookie];
  }

  bool noAuthError(authBody) {
    Map<String, dynamic> body = json.decode(authBody);
    if (body.containsKey("error")) {
      return false;
    }
    return true;
  }

  Future<bool> checkLoggedIn() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getBool('loggedIn') ?? false;
  }

  Future<dynamic> discourseAuth(csrf, username, password, cookie) async {
    Map<String, String> headers = {
      "X-CSRF-Token": csrf,
      "Cookie": cookie,
      'X-Requested-With': 'XMLHttpRequest',
      'Content-Type': 'application/x-www-form-urlencoded; charset=UTF-8'
    };

    final response = await http.post(
        Uri.parse(baseUrl + '/session?login=$username&password=$password'),
        headers: headers);

    if (response.statusCode == 200) {
      if (noAuthError(response.body)) {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        prefs.setBool('loggedIn', true);
        prefs.setString('username', username);
        _isLoggedIn = prefs.getBool('loggedIn') as bool;
        notifyListeners();
      } else {
        _hasPasswordError = false;
        _hasUsernameError = false;
        _hasAuthError = true;
        _errorMessage = 'Incorrect username, email or password';
        notifyListeners();
      }

      return response.body;
    } else {
      dev.log(response.body);
    }
  }

  Future<void> login(String username, String password) async {
    if (username.isEmpty) {
      _hasPasswordError = false;
      _hasAuthError = false;
      _hasUsernameError = true;
      _errorMessage = "Please fill in a username";
      notifyListeners();
    } else if (password.isEmpty) {
      _hasUsernameError = false;
      _hasAuthError = false;
      _hasPasswordError = true;
      _errorMessage = "Please fill in a password";
      notifyListeners();
    } else {
      notifyListeners();
      getCSRF().then(
          (keys) => {discourseAuth(keys[0], username, password, keys[1])});
    }
  }

  Future<void> logout() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool('loggedIn', false);
    _isLoggedIn = prefs.getBool('loggedIn') as bool;
    notifyListeners();
  }
}
