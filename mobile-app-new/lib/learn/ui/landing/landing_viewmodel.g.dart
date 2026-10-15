// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'landing_viewmodel.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(dailyChallengeToday)
final dailyChallengeTodayProvider = DailyChallengeTodayProvider._();

final class DailyChallengeTodayProvider
    extends
        $FunctionalProvider<
          AsyncValue<DailyChallengeOverview>,
          DailyChallengeOverview,
          FutureOr<DailyChallengeOverview>
        >
    with
        $FutureModifier<DailyChallengeOverview>,
        $FutureProvider<DailyChallengeOverview> {
  DailyChallengeTodayProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'dailyChallengeTodayProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$dailyChallengeTodayHash();

  @$internal
  @override
  $FutureProviderElement<DailyChallengeOverview> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<DailyChallengeOverview> create(Ref ref) {
    return dailyChallengeToday(ref);
  }
}

String _$dailyChallengeTodayHash() =>
    r'deb320db8627a5fdc11f65c4c8cd99c72a253765';

@ProviderFor(motivationalQuote)
final motivationalQuoteProvider = MotivationalQuoteProvider._();

final class MotivationalQuoteProvider
    extends
        $FunctionalProvider<
          AsyncValue<MotivationalQuote>,
          MotivationalQuote,
          FutureOr<MotivationalQuote>
        >
    with
        $FutureModifier<MotivationalQuote>,
        $FutureProvider<MotivationalQuote> {
  MotivationalQuoteProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'motivationalQuoteProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$motivationalQuoteHash();

  @$internal
  @override
  $FutureProviderElement<MotivationalQuote> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<MotivationalQuote> create(Ref ref) {
    return motivationalQuote(ref);
  }
}

String _$motivationalQuoteHash() => r'92f518bd2c1edf843c6598880e5bd945610a7c59';
