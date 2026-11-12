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
          AsyncValue<SettingsPreferencesService>,
          SettingsPreferencesService,
          FutureOr<SettingsPreferencesService>
        >
    with
        $FutureModifier<SettingsPreferencesService>,
        $FutureProvider<SettingsPreferencesService> {
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
  $FutureProviderElement<SettingsPreferencesService> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<SettingsPreferencesService> create(Ref ref) {
    return settingsPreferencesService(ref);
  }
}

String _$settingsPreferencesServiceHash() =>
    r'31092d3da9651023edf9801b7518acb0b8000f14';
