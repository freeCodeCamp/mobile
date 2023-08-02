import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LocaleService {
  Locale locale = const Locale('en');

  List<Locale> supportedLocales = [
    // Enlish
    const Locale('en'),
    // Spanish
    const Locale('es'),
    // Portuguese
    const Locale('pt'),
  ];

  List<String> supportedLocaleNames = [
    'English',
    'Spanish',
    'Portuguese',
  ];

  String currentLocaleName = 'English';

  Stream<Locale> get localeStream => _localeController.stream;
  final _localeController = StreamController<Locale>.broadcast();

  void changeLocale(String locale) {
    int localeIndex = supportedLocaleNames.indexWhere((element) {
      return locale == element;
    });

    this.locale = Locale.fromSubtags(
      languageCode: supportedLocales[localeIndex].languageCode,
    );

    currentLocaleName = supportedLocaleNames[localeIndex];

    SharedPreferences.getInstance().then((prefs) {
      prefs.setString('locale', locale[localeIndex]);
    });

    _localeController.sink.add(this.locale);
  }

  void init() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? locale = prefs.getString('locale');

    if (locale != null) {
      changeLocale(locale);
    }
  }
}
