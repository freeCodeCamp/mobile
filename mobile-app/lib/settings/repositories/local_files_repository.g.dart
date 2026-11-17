// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'local_files_repository.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(settingsLocalFilesRepository)
final settingsLocalFilesRepositoryProvider =
    SettingsLocalFilesRepositoryProvider._();

final class SettingsLocalFilesRepositoryProvider
    extends
        $FunctionalProvider<
          SettingsLocalFilesRepository,
          SettingsLocalFilesRepository,
          SettingsLocalFilesRepository
        >
    with $Provider<SettingsLocalFilesRepository> {
  SettingsLocalFilesRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'settingsLocalFilesRepositoryProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$settingsLocalFilesRepositoryHash();

  @$internal
  @override
  $ProviderElement<SettingsLocalFilesRepository> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  SettingsLocalFilesRepository create(Ref ref) {
    return settingsLocalFilesRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(SettingsLocalFilesRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<SettingsLocalFilesRepository>(value),
    );
  }
}

String _$settingsLocalFilesRepositoryHash() =>
    r'59041d705670463a1ad9fba30a4c0a1decff2146';
