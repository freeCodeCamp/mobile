// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'reset_service.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(settingsResetService)
final settingsResetServiceProvider = SettingsResetServiceProvider._();

final class SettingsResetServiceProvider
    extends
        $FunctionalProvider<
          SettingsResetService,
          SettingsResetService,
          SettingsResetService
        >
    with $Provider<SettingsResetService> {
  SettingsResetServiceProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'settingsResetServiceProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$settingsResetServiceHash();

  @$internal
  @override
  $ProviderElement<SettingsResetService> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  SettingsResetService create(Ref ref) {
    return settingsResetService(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(SettingsResetService value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<SettingsResetService>(value),
    );
  }
}

String _$settingsResetServiceHash() =>
    r'0f747e92fff81c5e33f739ba5700966ae0f3ce90';
