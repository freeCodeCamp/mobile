// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'resume_service.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(learnResumeService)
final learnResumeServiceProvider = LearnResumeServiceProvider._();

final class LearnResumeServiceProvider
    extends
        $FunctionalProvider<
          LearnResumeService,
          LearnResumeService,
          LearnResumeService
        >
    with $Provider<LearnResumeService> {
  LearnResumeServiceProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'learnResumeServiceProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$learnResumeServiceHash();

  @$internal
  @override
  $ProviderElement<LearnResumeService> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  LearnResumeService create(Ref ref) {
    return learnResumeService(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(LearnResumeService value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<LearnResumeService>(value),
    );
  }
}

String _$learnResumeServiceHash() =>
    r'c45f7bcc0d923740814a0ab3bd9eba55f17318d9';
