// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'library_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(PodcastLibraryNotifier)
final podcastLibraryProvider = PodcastLibraryNotifierProvider._();

final class PodcastLibraryNotifierProvider
    extends $AsyncNotifierProvider<PodcastLibraryNotifier, PodcastLibrary> {
  PodcastLibraryNotifierProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'podcastLibraryProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$podcastLibraryNotifierHash();

  @$internal
  @override
  PodcastLibraryNotifier create() => PodcastLibraryNotifier();
}

String _$podcastLibraryNotifierHash() =>
    r'eea18b471341bc853fac6f5e169b55277f2967b5';

abstract class _$PodcastLibraryNotifier extends $AsyncNotifier<PodcastLibrary> {
  FutureOr<PodcastLibrary> build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<AsyncValue<PodcastLibrary>, PodcastLibrary>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<PodcastLibrary>, PodcastLibrary>,
              AsyncValue<PodcastLibrary>,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}

@ProviderFor(podcastDownloadedSize)
final podcastDownloadedSizeProvider = PodcastDownloadedSizeFamily._();

final class PodcastDownloadedSizeProvider
    extends $FunctionalProvider<AsyncValue<int?>, int?, FutureOr<int?>>
    with $FutureModifier<int?>, $FutureProvider<int?> {
  PodcastDownloadedSizeProvider._({
    required PodcastDownloadedSizeFamily super.from,
    required (String, String) super.argument,
  }) : super(
         retry: null,
         name: r'podcastDownloadedSizeProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$podcastDownloadedSizeHash();

  @override
  String toString() {
    return r'podcastDownloadedSizeProvider'
        ''
        '$argument';
  }

  @$internal
  @override
  $FutureProviderElement<int?> $createElement($ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<int?> create(Ref ref) {
    final argument = this.argument as (String, String);
    return podcastDownloadedSize(ref, argument.$1, argument.$2);
  }

  @override
  bool operator ==(Object other) {
    return other is PodcastDownloadedSizeProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$podcastDownloadedSizeHash() =>
    r'992b8be0de75f3de64843508fe3da0a08fc8ce58';

final class PodcastDownloadedSizeFamily extends $Family
    with $FunctionalFamilyOverride<FutureOr<int?>, (String, String)> {
  PodcastDownloadedSizeFamily._()
    : super(
        retry: null,
        name: r'podcastDownloadedSizeProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  PodcastDownloadedSizeProvider call(String podcastId, String episodeId) =>
      PodcastDownloadedSizeProvider._(
        argument: (podcastId, episodeId),
        from: this,
      );

  @override
  String toString() => r'podcastDownloadedSizeProvider';
}
