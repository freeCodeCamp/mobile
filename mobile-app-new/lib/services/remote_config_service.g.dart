// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'remote_config_service.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(RemoteConfigNotifier)
final remoteConfigProvider = RemoteConfigNotifierProvider._();

final class RemoteConfigNotifierProvider
    extends $NotifierProvider<RemoteConfigNotifier, RemoteConfig> {
  RemoteConfigNotifierProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'remoteConfigProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$remoteConfigNotifierHash();

  @$internal
  @override
  RemoteConfigNotifier create() => RemoteConfigNotifier();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(RemoteConfig value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<RemoteConfig>(value),
    );
  }
}

String _$remoteConfigNotifierHash() =>
    r'57a4319c84867773353ffbfb431ca7016b9367e9';

abstract class _$RemoteConfigNotifier extends $Notifier<RemoteConfig> {
  RemoteConfig build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<RemoteConfig, RemoteConfig>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<RemoteConfig, RemoteConfig>,
              RemoteConfig,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}
