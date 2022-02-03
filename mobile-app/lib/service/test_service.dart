import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'dart:developer' as dev;

class TestService {
  Future<bool> developmentMode() async {
    await dotenv.load();
    return dotenv.get('DEVELOPMENTMODE', fallback: '').toLowerCase() == 'true';
  }
}
