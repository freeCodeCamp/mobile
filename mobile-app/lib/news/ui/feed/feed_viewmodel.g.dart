// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'feed_viewmodel.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(newsFeedTags)
final newsFeedTagsProvider = NewsFeedTagsProvider._();

final class NewsFeedTagsProvider
    extends $FunctionalProvider<List<Tag>, List<Tag>, List<Tag>>
    with $Provider<List<Tag>> {
  NewsFeedTagsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'newsFeedTagsProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$newsFeedTagsHash();

  @$internal
  @override
  $ProviderElement<List<Tag>> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  List<Tag> create(Ref ref) {
    return newsFeedTags(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(List<Tag> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<List<Tag>>(value),
    );
  }
}

String _$newsFeedTagsHash() => r'2ab1a0182d331907d0f0c86fc0768f79a4b92de2';
