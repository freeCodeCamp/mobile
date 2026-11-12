// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_info_service.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(settingsAppInfoService)
final settingsAppInfoServiceProvider = SettingsAppInfoServiceProvider._();

final class SettingsAppInfoServiceProvider
    extends
        $FunctionalProvider<
          SettingsAppInfoService,
          SettingsAppInfoService,
          SettingsAppInfoService
        >
    with $Provider<SettingsAppInfoService> {
  SettingsAppInfoServiceProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'settingsAppInfoServiceProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$settingsAppInfoServiceHash();

  @$internal
  @override
  $ProviderElement<SettingsAppInfoService> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  SettingsAppInfoService create(Ref ref) {
    return settingsAppInfoService(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(SettingsAppInfoService value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<SettingsAppInfoService>(value),
    );
  }
}

String _$settingsAppInfoServiceHash() =>
    r'dc53c4cf13faa70f5b4f02d70fc11ea8f9f01d48';
