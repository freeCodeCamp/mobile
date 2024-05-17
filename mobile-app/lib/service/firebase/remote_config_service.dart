import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:freecodecamp/utils/upgrade_controller.dart';
import 'package:upgrader/upgrader.dart';

class RemoteConfigService {
  static final RemoteConfigService _instance = RemoteConfigService._internal();

  static final remoteConfig = FirebaseRemoteConfig.instance;

  factory RemoteConfigService() {
    return _instance;
  }

  Future<void> init() async {
    await remoteConfig.setConfigSettings(
      RemoteConfigSettings(
        fetchTimeout: const Duration(minutes: 10),
        minimumFetchInterval: const Duration(seconds: 10),
      ),
    );
    await remoteConfig.setDefaults({
      'min_app_version': '4.2.1',
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
  }

  RemoteConfigService._internal();
}
