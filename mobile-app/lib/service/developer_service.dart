import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:freecodecamp/constants/string_constants.dart';

class DeveloperService {
  Future<bool> developmentMode() async {
    await dotenv.load();
    return dotenv.get(StringConstants.developmentMode, fallback: '').toLowerCase() == 'true';
  }
}
