import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'prefs_repository.g.dart';

@riverpod
LearnPrefsRepository learnPrefsRepository(Ref ref) => LearnPrefsRepository();

class LearnPrefsRepository {
  Future<String?> read(String key) async =>
      (await SharedPreferences.getInstance()).getString(key);

  Future<void> write(String key, String value) async =>
      (await SharedPreferences.getInstance()).setString(key, value);

  Future<void> remove(String key) async =>
      (await SharedPreferences.getInstance()).remove(key);
}
