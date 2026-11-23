// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'daily_challenge_viewmodel.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(dailyChallenge)
final dailyChallengeProvider = DailyChallengeFamily._();

final class DailyChallengeProvider
    extends
        $FunctionalProvider<
          AsyncValue<DailyChallenge>,
          DailyChallenge,
          FutureOr<DailyChallenge>
        >
    with $FutureModifier<DailyChallenge>, $FutureProvider<DailyChallenge> {
  DailyChallengeProvider._({
    required DailyChallengeFamily super.from,
    required String super.argument,
  }) : super(
         retry: noRetry,
         name: r'dailyChallengeProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$dailyChallengeHash();

  @override
  String toString() {
    return r'dailyChallengeProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $FutureProviderElement<DailyChallenge> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<DailyChallenge> create(Ref ref) {
    final argument = this.argument as String;
    return dailyChallenge(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is DailyChallengeProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$dailyChallengeHash() => r'b7653c96f7f7f441eb9cb86a5f15434c7c4dc6d5';

final class DailyChallengeFamily extends $Family
    with $FunctionalFamilyOverride<FutureOr<DailyChallenge>, String> {
  DailyChallengeFamily._()
    : super(
        retry: noRetry,
        name: r'dailyChallengeProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  DailyChallengeProvider call(String day) =>
      DailyChallengeProvider._(argument: day, from: this);

  @override
  String toString() => r'dailyChallengeProvider';
}

@ProviderFor(DailyChallengeLanguageNotifier)
final dailyChallengeLanguageProvider =
    DailyChallengeLanguageNotifierProvider._();

final class DailyChallengeLanguageNotifierProvider
    extends
        $AsyncNotifierProvider<
          DailyChallengeLanguageNotifier,
          DailyChallengeLanguage
        > {
  DailyChallengeLanguageNotifierProvider._()
    : super(
        from: null,
        argument: null,
        retry: noRetry,
        name: r'dailyChallengeLanguageProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$dailyChallengeLanguageNotifierHash();

  @$internal
  @override
  DailyChallengeLanguageNotifier create() => DailyChallengeLanguageNotifier();
}

String _$dailyChallengeLanguageNotifierHash() =>
    r'600b06ea9057e910095a0f01df454512d54bbecb';

abstract class _$DailyChallengeLanguageNotifier
    extends $AsyncNotifier<DailyChallengeLanguage> {
  FutureOr<DailyChallengeLanguage> build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref =
        this.ref
            as $Ref<AsyncValue<DailyChallengeLanguage>, DailyChallengeLanguage>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<
                AsyncValue<DailyChallengeLanguage>,
                DailyChallengeLanguage
              >,
              AsyncValue<DailyChallengeLanguage>,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}
