import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:freecodecamp/auth/models/user_model.dart';
import 'package:freecodecamp/auth/ui/profile_visibility/profile_visibility_viewmodel.dart';
import 'package:freecodecamp/auth/ui/widgets/profile_form.dart';
import 'package:freecodecamp/routing/auth.dart';
import 'package:freecodecamp/services/auth_service.dart';
import 'package:freecodecamp/widgets/error_retry.dart';

class ProfileVisibilityView extends ConsumerStatefulWidget {
  const ProfileVisibilityView({super.key});

  @override
  ConsumerState<ProfileVisibilityView> createState() =>
      _ProfileVisibilityViewState();
}

class _ProfileVisibilityViewState extends ConsumerState<ProfileVisibilityView> {
  final _scaffoldKey = GlobalKey<ProfileFormScaffoldState>();

  @override
  Widget build(BuildContext context) {
    final auth = ref.watch(authProvider);
    final state = ref.watch(profileVisibilityProvider);
    final notifier = ref.read(profileVisibilityProvider.notifier);
    return ProfileFormScaffold(
      key: _scaffoldKey,
      title: 'Profile visibility',
      isDirty: state?.isDirty ?? false,
      saving: state?.saving ?? false,
      onSave: state == null || !state.isDirty || state.needsRefresh
          ? null
          : () async {
              if (await notifier.save() && mounted) {
                await _scaffoldKey.currentState?.close();
              }
            },
      child: auth.isLoading && state == null
          ? const Center(child: CircularProgressIndicator())
          : auth.hasError
          ? ErrorRetry(
              message: 'Unable to load your profile.',
              onRetry: () => ref.invalidate(authProvider),
            )
          : state == null
          ? Center(
              child: TextButton(
                onPressed: () => const LoginRoute().go(context),
                child: const Text('Sign in to edit your profile'),
              ),
            )
          : ListView(
              padding: const EdgeInsets.all(16),
              children: [
                if (state.error != null) ...[
                  ErrorRetry(
                    message: state.error!,
                    onRetry: state.saving
                        ? null
                        : () async {
                            if (state.needsRefresh) {
                              await notifier.refresh();
                            } else {
                              await notifier.save();
                            }
                          },
                  ),
                  const SizedBox(height: 16),
                ],
                _VisibilityCard(
                  children: [
                    SwitchListTile.adaptive(
                      title: const Text('Private profile'),
                      subtitle: const Text(
                        'Only you can see your profile details when this is on.',
                      ),
                      value: state.draft.isLocked,
                      onChanged: state.saving || state.needsRefresh
                          ? null
                          : (value) => notifier.update(
                              state.draft.copyWith(isLocked: value),
                            ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                Text(
                  'Visible on your public profile',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: 8),
                if (state.draft.isLocked) ...[
                  Text(
                    'These choices apply when your profile is public.',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  const SizedBox(height: 12),
                ],
                _VisibilityCard(
                  children: [
                    for (final field in _visibilityFields) ...[
                      if (field != _visibilityFields.first)
                        const Divider(height: 1),
                      SwitchListTile.adaptive(
                        title: Text(field.label),
                        value: field.value(state.draft),
                        onChanged: state.saving || state.needsRefresh
                            ? null
                            : (value) => notifier.update(
                                field.update(state.draft, value),
                              ),
                      ),
                    ],
                  ],
                ),
              ],
            ),
    );
  }
}

class _VisibilityCard extends StatelessWidget {
  const _VisibilityCard({required this.children});
  final List<Widget> children;

  @override
  Widget build(BuildContext context) => Container(
    clipBehavior: Clip.antiAlias,
    decoration: BoxDecoration(
      color: Theme.of(context).colorScheme.surface,
      borderRadius: BorderRadius.circular(12),
      border: Border.all(color: Theme.of(context).colorScheme.outlineVariant),
    ),
    child: Column(children: children),
  );
}

typedef _VisibilityField = ({
  String label,
  bool Function(ProfileUI) value,
  ProfileUI Function(ProfileUI, bool) update,
});

final List<_VisibilityField> _visibilityFields = [
  (
    label: 'Name',
    value: (p) => p.showName,
    update: (p, v) => p.copyWith(showName: v),
  ),
  (
    label: 'About and join date',
    value: (p) => p.showAbout,
    update: (p, v) => p.copyWith(showAbout: v),
  ),
  (
    label: 'Location',
    value: (p) => p.showLocation,
    update: (p, v) => p.copyWith(showLocation: v),
  ),
  (
    label: 'Supporter status',
    value: (p) => p.showDonation,
    update: (p, v) => p.copyWith(showDonation: v),
  ),
  (
    label: 'Points',
    value: (p) => p.showPoints,
    update: (p, v) => p.copyWith(showPoints: v),
  ),
  (
    label: 'Activity and streaks',
    value: (p) => p.showHeatMap,
    update: (p, v) => p.copyWith(showHeatMap: v),
  ),
  (
    label: 'Certifications',
    value: (p) => p.showCerts,
    update: (p, v) => p.copyWith(showCerts: v),
  ),
  (
    label: 'Portfolio',
    value: (p) => p.showPortfolio,
    update: (p, v) => p.copyWith(showPortfolio: v),
  ),
  (
    label: 'Experience',
    value: (p) => p.showExperience,
    update: (p, v) => p.copyWith(showExperience: v),
  ),
  (
    label: 'Completed challenges',
    value: (p) => p.showTimeLine,
    update: (p, v) => p.copyWith(showTimeLine: v),
  ),
];
