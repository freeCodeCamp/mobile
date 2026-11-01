// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'profile_visibility_viewmodel.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(ProfileVisibilityNotifier)
final profileVisibilityProvider = ProfileVisibilityNotifierProvider._();

final class ProfileVisibilityNotifierProvider
    extends
        $NotifierProvider<ProfileVisibilityNotifier, ProfileVisibilityState?> {
  ProfileVisibilityNotifierProvider._()
    : super(
        from: null,
        argument: null,
        retry: noRetry,
        name: r'profileVisibilityProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$profileVisibilityNotifierHash();

  @$internal
  @override
  ProfileVisibilityNotifier create() => ProfileVisibilityNotifier();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(ProfileVisibilityState? value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<ProfileVisibilityState?>(value),
    );
  }
}

String _$profileVisibilityNotifierHash() =>
    r'31e0c3db265a18a268cec1b13b86a7240da65d17';

abstract class _$ProfileVisibilityNotifier
    extends $Notifier<ProfileVisibilityState?> {
  ProfileVisibilityState? build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref =
        this.ref as $Ref<ProfileVisibilityState?, ProfileVisibilityState?>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<ProfileVisibilityState?, ProfileVisibilityState?>,
              ProfileVisibilityState?,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}
