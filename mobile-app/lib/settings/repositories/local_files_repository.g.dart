// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'local_files_repository.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(localFilesRepository)
final localFilesRepositoryProvider = LocalFilesRepositoryProvider._();

final class LocalFilesRepositoryProvider
    extends
        $FunctionalProvider<
          LocalFilesRepository,
          LocalFilesRepository,
          LocalFilesRepository
        >
    with $Provider<LocalFilesRepository> {
  LocalFilesRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'localFilesRepositoryProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$localFilesRepositoryHash();

  @$internal
  @override
  $ProviderElement<LocalFilesRepository> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  LocalFilesRepository create(Ref ref) {
    return localFilesRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(LocalFilesRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<LocalFilesRepository>(value),
    );
  }
}

String _$localFilesRepositoryHash() =>
    r'ddcd0ffd8cfff527d52c0dcab9ced62c47f8cbf1';
