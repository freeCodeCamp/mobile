import 'package:package_info_plus/package_info_plus.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'app_info_repository.g.dart';

@riverpod
SettingsAppInfoRepository settingsAppInfoRepository(Ref ref) {
  return SettingsAppInfoRepository();
}

class SettingsAppInfoRepository {
  Future<PackageInfo> getAppInfo() => PackageInfo.fromPlatform();
}
