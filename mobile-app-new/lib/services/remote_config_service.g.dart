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
    extends $AsyncNotifierProvider<RemoteConfigNotifier, RemoteConfig> {
  RemoteConfigNotifierProvider._()
    : super(
        from: null,
        argument: null,
        retry: _noRetry,
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
}

String _$remoteConfigNotifierHash() =>
    r'232d92bceb2d38ef205a020a8a4894117a7f468b';

abstract class _$RemoteConfigNotifier extends $AsyncNotifier<RemoteConfig> {
  FutureOr<RemoteConfig> build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<AsyncValue<RemoteConfig>, RemoteConfig>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<RemoteConfig>, RemoteConfig>,
              AsyncValue<RemoteConfig>,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}
