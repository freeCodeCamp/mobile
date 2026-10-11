// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'quote_repository.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(learnQuoteRepository)
final learnQuoteRepositoryProvider = LearnQuoteRepositoryProvider._();

final class LearnQuoteRepositoryProvider
    extends
        $FunctionalProvider<
          LearnQuoteRepository,
          LearnQuoteRepository,
          LearnQuoteRepository
        >
    with $Provider<LearnQuoteRepository> {
  LearnQuoteRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'learnQuoteRepositoryProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$learnQuoteRepositoryHash();

  @$internal
  @override
  $ProviderElement<LearnQuoteRepository> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  LearnQuoteRepository create(Ref ref) {
    return learnQuoteRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(LearnQuoteRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<LearnQuoteRepository>(value),
    );
  }
}

String _$learnQuoteRepositoryHash() =>
    r'c041858f71da9f39927dbe81cba59105f8d9431a';
