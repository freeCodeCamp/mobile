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

String _$appVersionHash() => r'd09088f5a5379239d66c6e3222456b2a89289643';

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

@ProviderFor(localDataReset)
final localDataResetProvider = LocalDataResetProvider._();

final class LocalDataResetProvider
    extends $FunctionalProvider<LocalDataReset, LocalDataReset, LocalDataReset>
    with $Provider<LocalDataReset> {
  LocalDataResetProvider._()
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
  String debugGetCreateSourceHash() => _$localDataResetHash();

  @$internal
  @override
  $ProviderElement<LocalDataReset> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  LocalDataReset create(Ref ref) {
    return localDataReset(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(LocalDataReset value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<LocalDataReset>(value),
    );
  }
}

String _$localDataResetHash() => r'9ae3d5b18feb488af8b492f50468bd72a0bf4aa2';
