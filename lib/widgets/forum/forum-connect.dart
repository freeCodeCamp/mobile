import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'dart:developer' as dev;

class ForumConnect {
  static Future<dynamic> connectAndGet(String endpoint) async {
    String baseUrl = 'https://forum.freecodecamp.org';

    await dotenv.load(fileName: ".env");

    var response = await http.get(Uri.parse(baseUrl + endpoint),
        headers: <String, String>{'Accept': 'application/json'});
    //dev.log(endpoint);
    //dev.log(response.body);
    return response;
  }
}
