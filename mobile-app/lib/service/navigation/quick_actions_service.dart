import 'dart:io';

import 'package:freecodecamp/app/app.locator.dart';
import 'package:freecodecamp/app/app.router.dart';
import 'package:freecodecamp/l10n/app_localizations.dart';
import 'package:freecodecamp/service/locale_service.dart';
import 'package:quick_actions/quick_actions.dart';
import 'package:stacked_services/stacked_services.dart';

class QuickActionsService {
  static final QuickActionsService _quickActionsService =
      QuickActionsService._internal();

  QuickActions quickActions = const QuickActions();

  final NavigationService _navigationService = locator<NavigationService>();

  factory QuickActionsService() {
    return _quickActionsService;
  }

  Future<void> init() async {
    final t = lookupAppLocalizations(locator<LocaleService>().locale);

    await quickActions.setShortcutItems([
      ShortcutItem(
        type: 'action_daily_challenges',
        localizedTitle: t.quick_action_daily_challenges,
      ),
      ShortcutItem(
        type: 'action_learn',
        localizedTitle: t.learn,
      ),
      ShortcutItem(
        type: 'action_tutorials',
        localizedTitle: t.tutorials,
      ),
      if (!Platform.isIOS)
        ShortcutItem(
          type: 'action_code_radio',
          localizedTitle: t.code_radio,
        ),
      ShortcutItem(
        type: 'action_podcasts',
        localizedTitle: t.podcasts,
      ),
    ]);

    await quickActions.initialize((shortcutType) {
      switch (shortcutType) {
        case 'action_tutorials':
          _navigationService.replaceWith(Routes.newsViewHandlerView);
          break;
        case 'action_learn':
          _navigationService.replaceWith(Routes.learnLandingView);
          break;
        case 'action_code_radio':
          _navigationService.replaceWith(Routes.codeRadioView);
          break;
        case 'action_podcasts':
          _navigationService.replaceWith(Routes.podcastListView);
          break;
        case 'action_daily_challenges':
          _navigationService.replaceWith(Routes.dailyChallengeView);
          break;
        default:
      }
    });
  }

  QuickActionsService._internal();
}
