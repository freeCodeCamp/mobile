import 'package:freecodecamp/settings/repositories/local_files_repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'local_data_service.g.dart';

@riverpod
SettingsLocalDataService settingsLocalDataService(Ref ref) {
  return SettingsLocalDataService(
    ref.watch(settingsLocalFilesRepositoryProvider),
  );
}

class SettingsLocalDataService {
  SettingsLocalDataService(this._files);

  final SettingsLocalFilesRepository _files;

  Future<int> downloadedBytes() => _files.downloadedBytes();

  Future<void> clearDownloads() => _files.clearDownloads();
}
