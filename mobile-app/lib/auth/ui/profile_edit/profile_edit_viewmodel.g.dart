// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'profile_edit_viewmodel.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(profileEditPresentation)
final profileEditPresentationProvider = ProfileEditPresentationProvider._();

final class ProfileEditPresentationProvider
    extends
        $FunctionalProvider<
          ProfileEditPresentation?,
          ProfileEditPresentation?,
          ProfileEditPresentation?
        >
    with $Provider<ProfileEditPresentation?> {
  ProfileEditPresentationProvider._()
    : super(
        from: null,
        argument: null,
        retry: noRetry,
        name: r'profileEditPresentationProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$profileEditPresentationHash();

  @$internal
  @override
  $ProviderElement<ProfileEditPresentation?> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  ProfileEditPresentation? create(Ref ref) {
    return profileEditPresentation(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(ProfileEditPresentation? value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<ProfileEditPresentation?>(value),
    );
  }
}

String _$profileEditPresentationHash() =>
    r'635eb82ba10e4a9e75009092b63a96663e8d4609';
