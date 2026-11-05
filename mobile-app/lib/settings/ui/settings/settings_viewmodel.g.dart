// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'settings_viewmodel.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(SettingsNotifier)
final settingsProvider = SettingsNotifierProvider._();

final class SettingsNotifierProvider
    extends $NotifierProvider<SettingsNotifier, SettingsState> {
  SettingsNotifierProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'settingsProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$settingsNotifierHash();

  @$internal
  @override
  SettingsNotifier create() => SettingsNotifier();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(SettingsState value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<SettingsState>(value),
    );
  }
}

String _$settingsNotifierHash() => r'70781e982e066a87adcc060fd8b3bb33bc50f1d1';

abstract class _$SettingsNotifier extends $Notifier<SettingsState> {
  SettingsState build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<SettingsState, SettingsState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<SettingsState, SettingsState>,
              SettingsState,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}
