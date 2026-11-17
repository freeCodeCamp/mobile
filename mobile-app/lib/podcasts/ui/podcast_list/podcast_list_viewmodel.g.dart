// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'podcast_list_viewmodel.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(podcastList)
final podcastListProvider = PodcastListProvider._();

final class PodcastListProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<Podcast>>,
          List<Podcast>,
          FutureOr<List<Podcast>>
        >
    with $FutureModifier<List<Podcast>>, $FutureProvider<List<Podcast>> {
  PodcastListProvider._()
    : super(
        from: null,
        argument: null,
        retry: noRetry,
        name: r'podcastListProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$podcastListHash();

  @$internal
  @override
  $FutureProviderElement<List<Podcast>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<List<Podcast>> create(Ref ref) {
    return podcastList(ref);
  }
}

String _$podcastListHash() => r'5e7572080296d84ddcb619e9bbdd4ce84990b15b';
