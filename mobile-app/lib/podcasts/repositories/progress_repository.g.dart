// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'progress_repository.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(podcastProgressRepository)
final podcastProgressRepositoryProvider = PodcastProgressRepositoryProvider._();

final class PodcastProgressRepositoryProvider
    extends
        $FunctionalProvider<
          PodcastProgressRepository,
          PodcastProgressRepository,
          PodcastProgressRepository
        >
    with $Provider<PodcastProgressRepository> {
  PodcastProgressRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'podcastProgressRepositoryProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$podcastProgressRepositoryHash();

  @$internal
  @override
  $ProviderElement<PodcastProgressRepository> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  PodcastProgressRepository create(Ref ref) {
    return podcastProgressRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(PodcastProgressRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<PodcastProgressRepository>(value),
    );
  }
}

String _$podcastProgressRepositoryHash() =>
    r'a8f9cbfc928b77ef4a7c73639a57ba9dfa9628c1';
