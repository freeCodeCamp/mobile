import 'package:freecodecamp/constants/string_constants.dart';
import 'package:freecodecamp/service/firebase/remote_config_service.dart';
import 'package:upgrader/upgrader.dart';

var upgraderController = Upgrader(
  minAppVersion: RemoteConfigService.remoteConfig.getString(StringConstants.minAppVersion),
);
