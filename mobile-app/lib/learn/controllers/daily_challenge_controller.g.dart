// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'daily_challenge_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(DailyChallengeTodayNotifier)
final dailyChallengeTodayProvider = DailyChallengeTodayNotifierProvider._();

final class DailyChallengeTodayNotifierProvider
    extends
        $AsyncNotifierProvider<
          DailyChallengeTodayNotifier,
          DailyChallengeOverview
        > {
  DailyChallengeTodayNotifierProvider._()
    : super(
        from: null,
        argument: null,
        retry: noRetry,
        name: r'dailyChallengeTodayProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$dailyChallengeTodayNotifierHash();

  @$internal
  @override
  DailyChallengeTodayNotifier create() => DailyChallengeTodayNotifier();
}

String _$dailyChallengeTodayNotifierHash() =>
    r'8b49ed72e9c752e4700af5cf6592a4a3436a399a';

abstract class _$DailyChallengeTodayNotifier
    extends $AsyncNotifier<DailyChallengeOverview> {
  FutureOr<DailyChallengeOverview> build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref =
        this.ref
            as $Ref<AsyncValue<DailyChallengeOverview>, DailyChallengeOverview>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<
                AsyncValue<DailyChallengeOverview>,
                DailyChallengeOverview
              >,
              AsyncValue<DailyChallengeOverview>,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}
