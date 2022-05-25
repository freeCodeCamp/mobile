// default can't be used as a value for an enum so suffixing with Theme
import 'package:flutter/foundation.dart';

enum Themes { nightTheme, defaultTheme }

parseThemes(String theme) {
  switch (theme) {
    case 'night':
      return Themes.nightTheme;
    case 'default':
      return Themes.defaultTheme;
    default:
      return Themes.defaultTheme;
  }
}

extension ThemesValue on Themes {
  String get value => describeEnum(this).replaceFirst('Theme', '');
}
