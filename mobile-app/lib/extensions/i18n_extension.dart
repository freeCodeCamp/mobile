import 'package:flutter/widgets.dart';
import 'package:freecodecamp/l10n/app_localizations.dart';

extension I18nContext on BuildContext {
  AppLocalizations get t => AppLocalizations.of(this);
}
