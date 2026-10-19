// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'daily_challenge_service.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(learnDailyChallengeService)
final learnDailyChallengeServiceProvider =
    LearnDailyChallengeServiceProvider._();

final class LearnDailyChallengeServiceProvider
    extends
        $FunctionalProvider<
          LearnDailyChallengeService,
          LearnDailyChallengeService,
          LearnDailyChallengeService
        >
    with $Provider<LearnDailyChallengeService> {
  LearnDailyChallengeServiceProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'learnDailyChallengeServiceProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$learnDailyChallengeServiceHash();

  @$internal
  @override
  $ProviderElement<LearnDailyChallengeService> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  LearnDailyChallengeService create(Ref ref) {
    return learnDailyChallengeService(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(LearnDailyChallengeService value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<LearnDailyChallengeService>(value),
    );
  }
}

String _$learnDailyChallengeServiceHash() =>
    r'7634a3a37e1d72c66a9785151e642013fd24b5b9';
