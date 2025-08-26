import 'dart:io';

import 'package:freecodecamp/app/app.locator.dart';
import 'package:freecodecamp/app/app.router.dart';
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
    await quickActions.setShortcutItems([
      const ShortcutItem(
        type: 'action_daily_challenges',
        localizedTitle: 'Daily Challenges',
      ),
      const ShortcutItem(
        type: 'action_learn',
        localizedTitle: 'Learn',
      ),
      const ShortcutItem(
        type: 'action_tutorials',
        localizedTitle: 'Tutorials',
      ),
      if (!Platform.isIOS)
        const ShortcutItem(
          type: 'action_code_radio',
          localizedTitle: 'Code Radio',
        ),
      const ShortcutItem(
        type: 'action_podcasts',
        localizedTitle: 'Podcasts',
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
