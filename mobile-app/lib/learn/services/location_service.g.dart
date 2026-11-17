// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'location_service.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(learnLocationService)
final learnLocationServiceProvider = LearnLocationServiceProvider._();

final class LearnLocationServiceProvider
    extends
        $FunctionalProvider<
          LearnLocationService,
          LearnLocationService,
          LearnLocationService
        >
    with $Provider<LearnLocationService> {
  LearnLocationServiceProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'learnLocationServiceProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$learnLocationServiceHash();

  @$internal
  @override
  $ProviderElement<LearnLocationService> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  LearnLocationService create(Ref ref) {
    return learnLocationService(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(LearnLocationService value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<LearnLocationService>(value),
    );
  }
}

String _$learnLocationServiceHash() =>
    r'36a81f6d02522a1b2badcbe57a060f5101833b77';
