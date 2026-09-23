// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'downloads_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(PodcastDownloadsNotifier)
final podcastDownloadsProvider = PodcastDownloadsNotifierProvider._();

final class PodcastDownloadsNotifierProvider
    extends
        $NotifierProvider<
          PodcastDownloadsNotifier,
          Map<String, DownloadStatus>
        > {
  PodcastDownloadsNotifierProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'podcastDownloadsProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$podcastDownloadsNotifierHash();

  @$internal
  @override
  PodcastDownloadsNotifier create() => PodcastDownloadsNotifier();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(Map<String, DownloadStatus> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<Map<String, DownloadStatus>>(value),
    );
  }
}

String _$podcastDownloadsNotifierHash() =>
    r'b36ce1140f4480667777d8ab57418ada7ab98b98';

abstract class _$PodcastDownloadsNotifier
    extends $Notifier<Map<String, DownloadStatus>> {
  Map<String, DownloadStatus> build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref =
        this.ref
            as $Ref<Map<String, DownloadStatus>, Map<String, DownloadStatus>>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<
                Map<String, DownloadStatus>,
                Map<String, DownloadStatus>
              >,
              Map<String, DownloadStatus>,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}
