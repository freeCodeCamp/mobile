import 'dart:async';
import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_appauth/flutter_appauth.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:stacked/stacked.dart';
import 'package:http/http.dart' as http;
import 'package:dart_jsonwebtoken/dart_jsonwebtoken.dart';

class AuthViewModel extends BaseViewModel {
  bool isAuthBusy = false;
  bool isLoggedIn = false;
  String errorMessage = '';
  late String name;
  late String picture;
  final FlutterAppAuth appAuth = FlutterAppAuth();
  final FlutterSecureStorage secureStorage = const FlutterSecureStorage();
  final browser = FlutterWebviewPlugin();

  void initState() async {
    await dotenv.load(fileName: '.env');
  }

  Future<void> loginAction(BuildContext context) async {
    // isAuthBusy = true;
    // notifyListeners();
    browser.onUrlChanged.listen((String url) {
      log('onUrlChanged: $url');
      if (url ==
          'https://www.freecodecamp.dev/learn/?messages=success%5B0%5D%3Dflash.signin-success') {
        log('LOGGED IN');
        isLoggedIn = true;
        notifyListeners();
        browser.getCookies().then((cookies) {
          log('cookies: $cookies');
          cookies.forEach((key, value) {
            log('$key: $value');
          });
        });
        browser.close();
      }
    });
    browser.launch(
      'https://api.freecodecamp.dev/signin',
      clearCookies: true,
      clearCache: true,
      debuggingEnabled: true,
      userAgent: 'random',
    );
  }

  @override
  void dispose() {
    browser.dispose();
    super.dispose();
  }
}
