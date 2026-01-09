import 'dart:developer';

import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter/services.dart';
import 'package:freecodecamp/utils/upgrade_controller.dart';
import 'package:upgrader/upgrader.dart';

class RemoteConfigService {
  static final RemoteConfigService _instance = RemoteConfigService._internal();

  static final remoteConfig = FirebaseRemoteConfig.instance;

  factory RemoteConfigService() {
    return _instance;
  }

  Future<void> init() async {
    try {
      await remoteConfig.setConfigSettings(
        RemoteConfigSettings(
          fetchTimeout: const Duration(minutes: 1),
          minimumFetchInterval: const Duration(hours: 1),
        ),
      );
      await remoteConfig.setDefaults({
        'min_app_version': '7.0.0',
      });

      await remoteConfig.fetchAndActivate();

      remoteConfig.onConfigUpdated.listen((event) async {
        await remoteConfig.activate();

        // Update the min app version
        UpgraderState currUpgradeState = upgraderController.state;
        upgraderController.updateState(currUpgradeState.copyWith(
          minAppVersion: Upgrader.parseVersion(
            remoteConfig.getString('min_app_version'),
            'minAppVersion',
            false,
          ),
        ));
      });
    } on PlatformException catch (exception, stack) {
      log('Platform exception - $exception');
      await FirebaseCrashlytics.instance.recordError(
        exception,
        stack,
        reason: 'Remote Config Platform Exception',
      );
    } catch (exception) {
      log('Unable to fetch remote config. Cached or default values will be used $exception');
    }
  }

  RemoteConfigService._internal();
}
