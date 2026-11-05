// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'local_data_service.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(localDataService)
final localDataServiceProvider = LocalDataServiceProvider._();

final class LocalDataServiceProvider
    extends
        $FunctionalProvider<
          LocalDataService,
          LocalDataService,
          LocalDataService
        >
    with $Provider<LocalDataService> {
  LocalDataServiceProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'localDataServiceProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$localDataServiceHash();

  @$internal
  @override
  $ProviderElement<LocalDataService> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  LocalDataService create(Ref ref) {
    return localDataService(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(LocalDataService value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<LocalDataService>(value),
    );
  }
}

String _$localDataServiceHash() => r'1fbf05b9e863279c68a0a780e96565b565f22870';
