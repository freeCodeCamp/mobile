import 'dart:convert';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'dart:developer' as dev;

import 'package:shared_preferences/shared_preferences.dart';
// get, post, put and delete methods based in one file for connecting to the Discourse api

class ForumConnect {
  static Future<String> getCurrentUrl() async {
    await dotenv.load(fileName: ".env");

    String clientInDevMode =
        dotenv.get('DEVELOPMENTMODE', fallback: 'false').toLowerCase();

    return clientInDevMode == 'true'
        ? 'https://mobilefccinstance.com'
        : 'https://forum.freecodecamp.org';
  }

  static Future<bool> checkLoggedIn() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getBool('loggedIn') ?? false;
  }

  static Future<Map<String, String>> setHeaderValues() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    Map<String, String> headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json'
    };

    await dotenv.load(fileName: ".env");

    String clientInDevMode =
        dotenv.get('DEVELOPMENTMODE', fallback: 'false').toLowerCase();

    headers['Api-Username'] = prefs.getString('username') as String;

    bool noApiKeyProvided = dotenv.env['DISCOURSE_PROD'] == null &&
        dotenv.env['DISCOURSE_TEST'] == null;

    if (noApiKeyProvided) {
      throw Exception(
          'No Discourse api key provided, did you copy the sample.env?');
    }

    headers['Api-Key'] = dotenv.env[clientInDevMode == 'true'
        ? 'DISCOURSE_TEST'
        : 'DISCOURSE_PROD'] as String;

    return headers;
  }

  static Future<dynamic> connectAndGet(String endpoint) async {
    String url = await getCurrentUrl();
    Map<String, String> headers = await setHeaderValues();

    final res = await http.get(Uri.parse(url + endpoint), headers: headers);

    dev.log(url + endpoint);

    if (res.statusCode == 200) {
      return res;
    } else {
      throw Exception(res.body);
    }
  }

  static Future<dynamic> connectAndPost(
      String endpoint, Map<String, String> headers) async {
    String url = await getCurrentUrl();
    Map<String, String> headers = await setHeaderValues();

    final res = await http.post(Uri.parse(url + endpoint), headers: headers);

    dev.log(url + endpoint);

    if (res.statusCode == 200) {
      return res;
    } else {
      throw Exception(res.body);
    }
  }

  static Future<dynamic> connectAndPut(
      String endpoint, Map<String, dynamic> body) async {
    String url = await getCurrentUrl();
    Map<String, String> headers = await setHeaderValues();

    final res = await http.put(Uri.parse(url + endpoint),
        headers: headers, body: jsonEncode(body));

    dev.log(url + endpoint);

    if (res.statusCode == 200) {
      return res;
    } else {
      throw Exception(res.body);
    }
  }

  static Future<dynamic> connectAnDelete(
      String endpoint, Map<String, String> body) async {
    String url = await getCurrentUrl();
    Map<String, String> headers = await setHeaderValues();

    final res = await http.delete(Uri.parse(url + endpoint),
        headers: headers, body: jsonEncode(body));

    dev.log(url + endpoint);

    if (res.statusCode == 200) {
      return res;
    } else {
      throw Exception(res.body);
    }
  }
}
