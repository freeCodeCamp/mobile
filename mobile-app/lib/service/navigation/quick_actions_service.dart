import 'dart:io';

import 'package:freecodecamp/app/app.router.dart';
import 'package:freecodecamp/core/navigation/app_navigator.dart';
import 'package:quick_actions/quick_actions.dart';

class QuickActionsService {
  static final QuickActionsService _quickActionsService =
      QuickActionsService._internal();

  QuickActions quickActions = const QuickActions();

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
          AppNavigator.replaceWith(Routes.newsViewHandlerView);
          break;
        case 'action_learn':
          AppNavigator.replaceWith(Routes.learnLandingView);
          break;
        case 'action_code_radio':
          AppNavigator.replaceWith(Routes.codeRadioView);
          break;
        case 'action_podcasts':
          AppNavigator.replaceWith(Routes.podcastListView);
          break;
        case 'action_daily_challenges':
          AppNavigator.replaceWith(Routes.dailyChallengeView);
          break;
        default:
      }
    });
  }

  QuickActionsService._internal();
}
