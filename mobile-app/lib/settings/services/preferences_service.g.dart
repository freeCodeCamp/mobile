// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'preferences_service.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(settingsPreferencesService)
final settingsPreferencesServiceProvider =
    SettingsPreferencesServiceProvider._();

final class SettingsPreferencesServiceProvider
    extends
        $FunctionalProvider<
          SettingsPreferencesService,
          SettingsPreferencesService,
          SettingsPreferencesService
        >
    with $Provider<SettingsPreferencesService> {
  SettingsPreferencesServiceProvider._()
    : super(
        from: null,
        argument: null,
        retry: noRetry,
        name: r'settingsPreferencesServiceProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$settingsPreferencesServiceHash();

  @$internal
  @override
  $ProviderElement<SettingsPreferencesService> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  SettingsPreferencesService create(Ref ref) {
    return settingsPreferencesService(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(SettingsPreferencesService value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<SettingsPreferencesService>(value),
    );
  }
}

String _$settingsPreferencesServiceHash() =>
    r'c04348232a295611bc5850656d9881fc652419b6';
