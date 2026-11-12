// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'settings_viewmodel.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(appVersion)
final appVersionProvider = AppVersionProvider._();

final class AppVersionProvider
    extends
        $FunctionalProvider<
          AsyncValue<PackageInfo>,
          PackageInfo,
          FutureOr<PackageInfo>
        >
    with $FutureModifier<PackageInfo>, $FutureProvider<PackageInfo> {
  AppVersionProvider._()
    : super(
        from: null,
        argument: null,
        retry: noRetry,
        name: r'appVersionProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$appVersionHash();

  @$internal
  @override
  $FutureProviderElement<PackageInfo> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<PackageInfo> create(Ref ref) {
    return appVersion(ref);
  }
}

String _$appVersionHash() => r'd5b98cdd0df3f88e1fcc1d9b0b477c9d82ef7e9d';

@ProviderFor(downloadedStorageBytes)
final downloadedStorageBytesProvider = DownloadedStorageBytesProvider._();

final class DownloadedStorageBytesProvider
    extends $FunctionalProvider<AsyncValue<int>, int, FutureOr<int>>
    with $FutureModifier<int>, $FutureProvider<int> {
  DownloadedStorageBytesProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'downloadedStorageBytesProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$downloadedStorageBytesHash();

  @$internal
  @override
  $FutureProviderElement<int> $createElement($ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<int> create(Ref ref) {
    return downloadedStorageBytes(ref);
  }
}

String _$downloadedStorageBytesHash() =>
    r'3502d7d6df7b1d98ed8961c3cee54771c394762a';

@ProviderFor(LocalDataResetNotifier)
final localDataResetProvider = LocalDataResetNotifierProvider._();

final class LocalDataResetNotifierProvider
    extends $NotifierProvider<LocalDataResetNotifier, void> {
  LocalDataResetNotifierProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'localDataResetProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$localDataResetNotifierHash();

  @$internal
  @override
  LocalDataResetNotifier create() => LocalDataResetNotifier();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(void value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<void>(value),
    );
  }
}

String _$localDataResetNotifierHash() =>
    r'8d6efc08637c3ede2da9351e995c22c31f914be0';

abstract class _$LocalDataResetNotifier extends $Notifier<void> {
  void build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<void, void>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<void, void>,
              void,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}
