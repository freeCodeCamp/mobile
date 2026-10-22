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
        retry: null,
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

String _$podcastListHash() => r'050470de646ff921b6da31c2026f07ca7a8405df';
