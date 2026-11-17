// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'preferences_repository.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(settingsPreferencesRepository)
final settingsPreferencesRepositoryProvider =
    SettingsPreferencesRepositoryProvider._();

final class SettingsPreferencesRepositoryProvider
    extends
        $FunctionalProvider<
          AsyncValue<SettingsPreferencesRepository>,
          SettingsPreferencesRepository,
          FutureOr<SettingsPreferencesRepository>
        >
    with
        $FutureModifier<SettingsPreferencesRepository>,
        $FutureProvider<SettingsPreferencesRepository> {
  SettingsPreferencesRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: noRetry,
        name: r'settingsPreferencesRepositoryProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$settingsPreferencesRepositoryHash();

  @$internal
  @override
  $FutureProviderElement<SettingsPreferencesRepository> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<SettingsPreferencesRepository> create(Ref ref) {
    return settingsPreferencesRepository(ref);
  }
}

String _$settingsPreferencesRepositoryHash() =>
    r'6d8812c2744294b7c09f4352ace892783553b2cb';
