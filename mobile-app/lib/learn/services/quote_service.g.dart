// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'quote_service.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(learnQuoteService)
final learnQuoteServiceProvider = LearnQuoteServiceProvider._();

final class LearnQuoteServiceProvider
    extends
        $FunctionalProvider<
          LearnQuoteService,
          LearnQuoteService,
          LearnQuoteService
        >
    with $Provider<LearnQuoteService> {
  LearnQuoteServiceProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'learnQuoteServiceProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$learnQuoteServiceHash();

  @$internal
  @override
  $ProviderElement<LearnQuoteService> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  LearnQuoteService create(Ref ref) {
    return learnQuoteService(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(LearnQuoteService value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<LearnQuoteService>(value),
    );
  }
}

String _$learnQuoteServiceHash() => r'8dc7e1cb9a76a8d1df48b44215bc416a49dd2c15';
