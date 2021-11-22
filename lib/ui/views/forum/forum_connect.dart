import 'dart:convert';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'dart:developer' as dev;

import 'package:shared_preferences/shared_preferences.dart';
// get, post, put and delete methods based in one file for connecting to the Discourse api

class ForumConnect {
  static String baseUrl = '';

  static Future<String> getCurrentUrl() async {
    await dotenv.load(fileName: ".env");

    bool clientInDevMode =
        dotenv.env['DEVELOPMENTMODE']!.toLowerCase() == 'true';

    return clientInDevMode
        ? 'https://mobilefccinstance.com'
        : 'https://forum.freecodecamp.org/';
  }

  static Future<Map<String, String>> setHeaderValues() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    Map<String, String> headers = {'Accept': 'application/json'};

    await dotenv.load(fileName: ".env");

    bool clientInDevMode =
        dotenv.env['DEVELOPMENTMODE']!.toLowerCase() == 'true';

    headers['Api-Key'] = dotenv
        .env[clientInDevMode ? 'DISCOURSE_TEST' : 'DISCOURSE_PROD'] as String;
    headers['Api-Username'] = prefs.getString('username') as String;
    return headers;
  }

  static Future<dynamic> connectAndGet(String endpoint) async {
    String url = await getCurrentUrl();
    Map<String, String> headers = await setHeaderValues();

    final res = await http.get(Uri.parse(url + endpoint), headers: headers);

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
    if (res.statusCode == 200) {
      return res;
    } else {
      throw Exception(res.body);
    }
  }
}
