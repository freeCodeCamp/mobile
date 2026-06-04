import 'dart:async';

import 'package:freecodecamp/service/authentication/authentication_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CurriculumLanguage {
  final String slug;
  final String name;
  const CurriculumLanguage({required this.slug, required this.name});
}

class CurriculumLanguageService {
  static const List<CurriculumLanguage> languages = [
    CurriculumLanguage(slug: 'english', name: 'English'),
    CurriculumLanguage(slug: 'espanol', name: 'Spanish'),
    CurriculumLanguage(slug: 'chinese', name: 'Chinese (Simplified)'),
    CurriculumLanguage(
        slug: 'chinese-traditional', name: 'Chinese (Traditional)'),
    CurriculumLanguage(slug: 'italian', name: 'Italian'),
    CurriculumLanguage(slug: 'portuguese', name: 'Portuguese'),
    CurriculumLanguage(slug: 'ukrainian', name: 'Ukrainian'),
    CurriculumLanguage(slug: 'japanese', name: 'Japanese'),
    CurriculumLanguage(slug: 'german', name: 'German'),
    CurriculumLanguage(slug: 'swahili', name: 'Swahili'),
    CurriculumLanguage(slug: 'korean', name: 'Korean'),
  ];

  static const String _prefKey = 'curriculumLanguage';

  CurriculumLanguage _current = languages[0];
  CurriculumLanguage get current => _current;

  final _controller = StreamController<CurriculumLanguage>.broadcast();
  Stream<CurriculumLanguage> get stream => _controller.stream;

  String get baseUrl {
    final domain = AuthenticationService.baseURL;
    if (_current.slug == 'english') {
      return '$domain/curriculum-data/v2';
    }
    return '$domain/${_current.slug}/curriculum-data/v2';
  }

  Future<void> init() async {
    final prefs = await SharedPreferences.getInstance();
    final slug = prefs.getString(_prefKey) ?? 'english';
    _current = languages.firstWhere(
      (l) => l.slug == slug,
      orElse: () => languages[0],
    );
  }

  Future<void> setLanguage(String slug) async {
    _current = languages.firstWhere(
      (l) => l.slug == slug,
      orElse: () => languages[0],
    );
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_prefKey, _current.slug);
    _controller.sink.add(_current);
  }
}
