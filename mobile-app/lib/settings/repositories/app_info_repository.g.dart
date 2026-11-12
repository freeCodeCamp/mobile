// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_info_repository.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(settingsAppInfoRepository)
final settingsAppInfoRepositoryProvider = SettingsAppInfoRepositoryProvider._();

final class SettingsAppInfoRepositoryProvider
    extends
        $FunctionalProvider<
          SettingsAppInfoRepository,
          SettingsAppInfoRepository,
          SettingsAppInfoRepository
        >
    with $Provider<SettingsAppInfoRepository> {
  SettingsAppInfoRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'settingsAppInfoRepositoryProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$settingsAppInfoRepositoryHash();

  @$internal
  @override
  $ProviderElement<SettingsAppInfoRepository> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  SettingsAppInfoRepository create(Ref ref) {
    return settingsAppInfoRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(SettingsAppInfoRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<SettingsAppInfoRepository>(value),
    );
  }
}

String _$settingsAppInfoRepositoryHash() =>
    r'91eb1f63a1a7deeda0b8003cbd4282648994ea35';
