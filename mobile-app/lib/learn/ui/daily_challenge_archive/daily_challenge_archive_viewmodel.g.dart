// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'daily_challenge_archive_viewmodel.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(dailyChallengeArchive)
final dailyChallengeArchiveProvider = DailyChallengeArchiveProvider._();

final class DailyChallengeArchiveProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<DailyChallengeMonth>>,
          List<DailyChallengeMonth>,
          FutureOr<List<DailyChallengeMonth>>
        >
    with
        $FutureModifier<List<DailyChallengeMonth>>,
        $FutureProvider<List<DailyChallengeMonth>> {
  DailyChallengeArchiveProvider._()
    : super(
        from: null,
        argument: null,
        retry: noRetry,
        name: r'dailyChallengeArchiveProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$dailyChallengeArchiveHash();

  @$internal
  @override
  $FutureProviderElement<List<DailyChallengeMonth>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<List<DailyChallengeMonth>> create(Ref ref) {
    return dailyChallengeArchive(ref);
  }
}

String _$dailyChallengeArchiveHash() =>
    r'a9cbb9cdb238d21e7528544b48f7ed37f00c4220';
