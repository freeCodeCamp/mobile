import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LocaleService {
  Locale locale = const Locale('en');

  // supported locales
  List<Locale> locales = [
    // Enlish
    const Locale('en'),
    // Spanish
    const Locale('es'),
    // Portuguese
    const Locale('pt'),
  ];

  List<String> localeNames = [
    'English',
    'Spanish',
    'Portuguese',
  ];

  String currentLocaleName = 'English';

  Stream<Locale> get localeStream => _localeController.stream;
  final _localeController = StreamController<Locale>.broadcast();

  void changeLocale(String locale, {isLocaleCode = false}) {
    int localeIndex = 0;

    if (!isLocaleCode) {
      localeIndex = localeNames.indexWhere((element) {
        return locale == element;
      });

      currentLocaleName = localeNames[localeIndex];
    } else {
      int index = locales.indexWhere((element) {
        return locale == element.languageCode;
      });

      currentLocaleName = localeNames[index];
    }

    this.locale = Locale.fromSubtags(
      languageCode: isLocaleCode ? locale : locales[localeIndex].languageCode,
    );

    SharedPreferences.getInstance().then((prefs) {
      prefs.setString(
        'locale',
        isLocaleCode ? locale : locales[localeIndex].languageCode,
      );
    });

    _localeController.sink.add(this.locale);
  }

  void init() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? locale = prefs.getString('locale');

    if (locale != null) {
      changeLocale(locale, isLocaleCode: true);
    }
  }
}
