// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'settings_service.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(settingsService)
final settingsServiceProvider = SettingsServiceProvider._();

final class SettingsServiceProvider
    extends
        $FunctionalProvider<
          AsyncValue<SettingsService>,
          SettingsService,
          FutureOr<SettingsService>
        >
    with $FutureModifier<SettingsService>, $FutureProvider<SettingsService> {
  SettingsServiceProvider._()
    : super(
        from: null,
        argument: null,
        retry: noRetry,
        name: r'settingsServiceProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$settingsServiceHash();

  @$internal
  @override
  $FutureProviderElement<SettingsService> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<SettingsService> create(Ref ref) {
    return settingsService(ref);
  }
}

String _$settingsServiceHash() => r'139dd7e514d77336db55ea5ee57b29ac3f4de409';
