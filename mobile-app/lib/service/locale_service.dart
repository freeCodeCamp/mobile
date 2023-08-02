import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LocaleService {
  Locale locale = const Locale('en');

  Stream<Locale> get localeStream => _localeController.stream;
  final _localeController = StreamController<Locale>.broadcast();

  getLocalClassInstance({locale = 'en'}) {
    return Locale.fromSubtags(languageCode: locale);
  }

  void changeLocale(String locale) {
    this.locale = getLocalClassInstance(locale: locale);

    SharedPreferences.getInstance().then((prefs) {
      prefs.setString('locale', locale);
    });

    _localeController.sink.add(this.locale);
  }

  void init() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? locale = prefs.getString('locale');

    if (locale != null) {
      changeLocale(locale);
    }

    _localeController.sink.add(this.locale);
  }
}
