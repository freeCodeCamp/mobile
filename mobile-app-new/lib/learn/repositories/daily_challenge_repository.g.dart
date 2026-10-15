// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'daily_challenge_repository.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(learnDailyChallengeRepository)
final learnDailyChallengeRepositoryProvider =
    LearnDailyChallengeRepositoryProvider._();

final class LearnDailyChallengeRepositoryProvider
    extends
        $FunctionalProvider<
          LearnDailyChallengeRepository,
          LearnDailyChallengeRepository,
          LearnDailyChallengeRepository
        >
    with $Provider<LearnDailyChallengeRepository> {
  LearnDailyChallengeRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'learnDailyChallengeRepositoryProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$learnDailyChallengeRepositoryHash();

  @$internal
  @override
  $ProviderElement<LearnDailyChallengeRepository> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  LearnDailyChallengeRepository create(Ref ref) {
    return learnDailyChallengeRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(LearnDailyChallengeRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<LearnDailyChallengeRepository>(
        value,
      ),
    );
  }
}

String _$learnDailyChallengeRepositoryHash() =>
    r'f0b3449fec3dd27a62ca11a3751026067c2a57a6';
