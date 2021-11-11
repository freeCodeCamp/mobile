import 'dart:convert';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'dart:developer' as dev;

import 'package:shared_preferences/shared_preferences.dart';
// get, post, put and delete methods based in one file for connecting to the Discourse api

class ForumConnect {
  static String baseUrl = 'https://forum.freecodecamp.org';

  static Future<dynamic> connectAndGet(String endpoint) async {
    await dotenv.load(fileName: ".env");
    SharedPreferences prefs = await SharedPreferences.getInstance();

    Map<String, String>? headers = {'Accept': 'application/json'};

    headers['Api-Key'] = dotenv.env['DISCOURSE_API'] as String;
    headers['Api-Username'] = prefs.getString('username') as String;

    final response =
        await http.get(Uri.parse(baseUrl + endpoint), headers: headers);
    dev.log(baseUrl + endpoint);
    //dev.log(response.body.toString());
    return response;
  }

  static Future<dynamic> connectAndPost(
      String endpoint, Map<String, String> headers) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    await dotenv.load(fileName: ".env");
    headers['Api-Key'] = dotenv.env['DISCOURSE_API'] as String;
    headers['Api-Username'] = prefs.getString('username') as String;
    final response =
        await http.post(Uri.parse(baseUrl + endpoint), headers: headers);
    dev.log(response.body);
    return response;
  }

  static Future<dynamic> connectAndPut(
      String endpoint, Map<String, dynamic> body) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    Map<String, String> headers = {'Content-Type': 'application/json'};

    await dotenv.load(fileName: ".env");
    headers['Api-Key'] = dotenv.env['DISCOURSE_API'] as String;
    headers['Api-Username'] = prefs.getString('username') as String;

    final response = await http.put(Uri.parse(baseUrl + endpoint),
        headers: headers, body: jsonEncode(body));
    dev.log(response.body);
    return response;
  }

  static Future<dynamic> connectAnDelete(
      String endpoint, Map<String, String> body) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    Map<String, String> headers = {'Content-Type': 'application/json'};

    await dotenv.load(fileName: ".env");
    headers['Api-Key'] = dotenv.env['DISCOURSE_API'] as String;
    headers['Api-Username'] = prefs.getString('username') as String;

    final response = await http.delete(Uri.parse(baseUrl + endpoint),
        headers: headers, body: jsonEncode(body));
    return response;
  }
}
