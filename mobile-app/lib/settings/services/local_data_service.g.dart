// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'local_data_service.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(settingsLocalDataService)
final settingsLocalDataServiceProvider = SettingsLocalDataServiceProvider._();

final class SettingsLocalDataServiceProvider
    extends
        $FunctionalProvider<
          SettingsLocalDataService,
          SettingsLocalDataService,
          SettingsLocalDataService
        >
    with $Provider<SettingsLocalDataService> {
  SettingsLocalDataServiceProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'settingsLocalDataServiceProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$settingsLocalDataServiceHash();

  @$internal
  @override
  $ProviderElement<SettingsLocalDataService> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  SettingsLocalDataService create(Ref ref) {
    return settingsLocalDataService(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(SettingsLocalDataService value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<SettingsLocalDataService>(value),
    );
  }
}

String _$settingsLocalDataServiceHash() =>
    r'e45665994d216122a84fb2fe13d159d52600c3c6';
