// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'code_service.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(learnCodeService)
final learnCodeServiceProvider = LearnCodeServiceProvider._();

final class LearnCodeServiceProvider
    extends
        $FunctionalProvider<
          LearnCodeService,
          LearnCodeService,
          LearnCodeService
        >
    with $Provider<LearnCodeService> {
  LearnCodeServiceProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'learnCodeServiceProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$learnCodeServiceHash();

  @$internal
  @override
  $ProviderElement<LearnCodeService> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  LearnCodeService create(Ref ref) {
    return learnCodeService(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(LearnCodeService value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<LearnCodeService>(value),
    );
  }
}

String _$learnCodeServiceHash() => r'd4a83ca552e225bb114024b250f18a9e25473cd6';
