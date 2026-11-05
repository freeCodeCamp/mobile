// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'daily_challenge_reminder_service.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(learnDailyChallengeReminderService)
final learnDailyChallengeReminderServiceProvider =
    LearnDailyChallengeReminderServiceProvider._();

final class LearnDailyChallengeReminderServiceProvider
    extends
        $FunctionalProvider<
          LearnDailyChallengeReminderService,
          LearnDailyChallengeReminderService,
          LearnDailyChallengeReminderService
        >
    with $Provider<LearnDailyChallengeReminderService> {
  LearnDailyChallengeReminderServiceProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'learnDailyChallengeReminderServiceProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() =>
      _$learnDailyChallengeReminderServiceHash();

  @$internal
  @override
  $ProviderElement<LearnDailyChallengeReminderService> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  LearnDailyChallengeReminderService create(Ref ref) {
    return learnDailyChallengeReminderService(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(LearnDailyChallengeReminderService value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<LearnDailyChallengeReminderService>(
        value,
      ),
    );
  }
}

String _$learnDailyChallengeReminderServiceHash() =>
    r'e87cccf4064ece8261420794c2e6e6d09d318703';
