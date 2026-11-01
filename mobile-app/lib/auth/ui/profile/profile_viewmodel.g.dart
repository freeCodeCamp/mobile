// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'profile_viewmodel.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(profileStreak)
final profileStreakProvider = ProfileStreakProvider._();

final class ProfileStreakProvider
    extends
        $FunctionalProvider<
          ({int current, int longest}),
          ({int current, int longest}),
          ({int current, int longest})
        >
    with $Provider<({int current, int longest})> {
  ProfileStreakProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'profileStreakProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$profileStreakHash();

  @$internal
  @override
  $ProviderElement<({int current, int longest})> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  ({int current, int longest}) create(Ref ref) {
    return profileStreak(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(({int current, int longest}) value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<({int current, int longest})>(value),
    );
  }
}

String _$profileStreakHash() => r'24ac10a7e8e78c1d4e6fb034773dbd88c01c78f1';
