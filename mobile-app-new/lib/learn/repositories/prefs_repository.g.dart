// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'prefs_repository.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(learnPrefsRepository)
final learnPrefsRepositoryProvider = LearnPrefsRepositoryProvider._();

final class LearnPrefsRepositoryProvider
    extends
        $FunctionalProvider<
          LearnPrefsRepository,
          LearnPrefsRepository,
          LearnPrefsRepository
        >
    with $Provider<LearnPrefsRepository> {
  LearnPrefsRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'learnPrefsRepositoryProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$learnPrefsRepositoryHash();

  @$internal
  @override
  $ProviderElement<LearnPrefsRepository> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  LearnPrefsRepository create(Ref ref) {
    return learnPrefsRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(LearnPrefsRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<LearnPrefsRepository>(value),
    );
  }
}

String _$learnPrefsRepositoryHash() =>
    r'9b057548f8008b07ab08e85db12f9bbb6c358efe';
