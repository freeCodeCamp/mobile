import 'dart:developer';

import 'package:flutter_dotenv/flutter_dotenv.dart';

class TestService {
  Future<bool> developmentMode() async {
    log('Checking if in development mode');
    await dotenv.load();
    return dotenv.get('DEVELOPMENTMODE', fallback: '').toLowerCase() == 'true';
  }
}
