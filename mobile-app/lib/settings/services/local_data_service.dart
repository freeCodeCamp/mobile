import 'package:freecodecamp/settings/repositories/local_files_repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'local_data_service.g.dart';

@riverpod
LocalDataService localDataService(Ref ref) {
  return LocalDataService(ref.watch(localFilesRepositoryProvider));
}

class LocalDataService {
  LocalDataService(this._files);

  final LocalFilesRepository _files;

  Future<int> downloadedBytes() => _files.downloadedBytes();

  Future<void> clearDownloads() => _files.clearDownloads();
}
