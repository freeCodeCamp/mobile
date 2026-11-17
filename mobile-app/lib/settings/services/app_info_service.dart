import 'package:freecodecamp/settings/repositories/app_info_repository.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'app_info_service.g.dart';

@riverpod
SettingsAppInfoService settingsAppInfoService(Ref ref) {
  return SettingsAppInfoService(ref.watch(settingsAppInfoRepositoryProvider));
}

class SettingsAppInfoService {
  SettingsAppInfoService(this._repo);

  final SettingsAppInfoRepository _repo;

  Future<PackageInfo> getAppInfo() => _repo.getAppInfo();
}
