import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:freecodecamp/auth/models/user_model.dart';
import 'package:freecodecamp/auth/ui/profile_visibility/profile_visibility_viewmodel.dart';
import 'package:freecodecamp/routing/auth.dart';
import 'package:freecodecamp/services/auth_service.dart';
import 'package:freecodecamp/widgets/app_bottom_navigation.dart';
import 'package:freecodecamp/widgets/error_retry.dart';
import 'package:freecodecamp/widgets/segmented_tabs.dart';
import 'package:go_router/go_router.dart';

class ProfileVisibilityView extends ConsumerStatefulWidget {
  const ProfileVisibilityView({super.key});

  @override
  ConsumerState<ProfileVisibilityView> createState() =>
      _ProfileVisibilityViewState();
}

class _ProfileVisibilityViewState extends ConsumerState<ProfileVisibilityView> {
  Future<void> _save([ProfileUI? draft]) async {
    final notifier = ref.read(profileVisibilityProvider.notifier);
    if (draft != null) notifier.update(draft);
    if (await notifier.save() && mounted) {
      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(const SnackBar(content: Text('Saved')));
    }
  }

  @override
  Widget build(BuildContext context) {
    final auth = ref.watch(authProvider);
    final state = ref.watch(profileVisibilityProvider);
    final notifier = ref.read(profileVisibilityProvider.notifier);
    final theme = Theme.of(context);
    final sectionTitle = theme.textTheme.titleMedium?.copyWith(
      fontSize: 14,
      fontWeight: FontWeight.w700,
      color: theme.colorScheme.onSurfaceVariant,
    );
    final enabled = state != null && !state.saving && !state.needsRefresh;
    return PopScope(
      canPop: !(state?.saving ?? false),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Profile visibility'),
          leading: BackButton(
            onPressed: state?.saving ?? false
                ? null
                : () => context.canPop()
                      ? context.pop()
                      : const ProfileRoute().go(context),
          ),
        ),
        bottomNavigationBar: AppNavigationFooter(
          selected: AppDestination.account,
          beforeNavigate: () async =>
              !(ref.read(profileVisibilityProvider)?.saving ?? false),
        ),
        body: SafeArea(
          top: false,
          child: Align(
            alignment: Alignment.topCenter,
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 640),
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
                            margin: EdgeInsets.zero,
                            message: state.error!,
                            onRetry: state.saving
                                ? null
                                : () async {
                                    if (state.needsRefresh) {
                                      await notifier.refresh();
                                    } else {
                                      await _save();
                                    }
                                  },
                          ),
                          const SizedBox(height: 16),
                        ],
                        Card(
                          margin: EdgeInsets.zero,
                          child: Padding(
                            padding: const EdgeInsets.all(14),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Who can see your profile',
                                  style: sectionTitle,
                                ),
                                const SizedBox(height: 12),
                                SegmentedTabs<bool>(
                                  tabs: const [
                                    (
                                      value: false,
                                      label: 'Public',
                                      icon: Icons.public,
                                    ),
                                    (
                                      value: true,
                                      label: 'Private',
                                      icon: Icons.lock_outline,
                                    ),
                                  ],
                                  selected: state.draft.isLocked,
                                  onSelected: enabled
                                      ? (isLocked) => _save(
                                          state.draft.copyWith(
                                            isLocked: isLocked,
                                          ),
                                        )
                                      : null,
                                ),
                                const SizedBox(height: 12),
                                Text(
                                  state.draft.isLocked
                                      ? 'Only you can see your profile.'
                                      : 'Anyone can see your profile at\u00A0freecodecamp.org/${state.original.username}.',
                                  style: theme.textTheme.bodyMedium?.copyWith(
                                    color: theme.colorScheme.onSurfaceVariant,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(height: 24),
                        Text(
                          'Show on your public profile',
                          style: sectionTitle,
                        ),
                        if (state.draft.isLocked) ...[
                          const SizedBox(height: 8),
                          Text(
                            'These choices apply when your profile is public.',
                            style: theme.textTheme.bodyMedium,
                          ),
                        ],
                        for (final group in _visibilityGroups) ...[
                          const SizedBox(height: 16),
                          Text(
                            group.title,
                            style: theme.textTheme.labelLarge?.copyWith(
                              color: theme.colorScheme.onSurfaceVariant,
                            ),
                          ),
                          const SizedBox(height: 8),
                          _VisibilityCard(
                            children: [
                              for (final (index, field)
                                  in group.fields.indexed) ...[
                                if (index > 0) const Divider(height: 1),
                                SwitchListTile.adaptive(
                                  title: Text(
                                    field.label,
                                    style: theme.textTheme.bodyLarge?.copyWith(
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                  subtitle: field.subtitle == null
                                      ? null
                                      : Text(
                                          field.subtitle!,
                                          style: theme.textTheme.bodySmall,
                                        ),
                                  value: field.value(state.draft),
                                  onChanged: enabled
                                      ? (value) => _save(
                                          field.update(state.draft, value),
                                        )
                                      : null,
                                ),
                              ],
                            ],
                          ),
                        ],
                      ],
                    ),
            ),
          ),
        ),
      ),
    );
  }
}

class _VisibilityCard extends StatelessWidget {
  const _VisibilityCard({required this.children});
  final List<Widget> children;

  @override
  Widget build(BuildContext context) => Material(
    clipBehavior: Clip.antiAlias,
    color: Theme.of(context).colorScheme.surface,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(12),
      side: BorderSide(color: Theme.of(context).colorScheme.outlineVariant),
    ),
    child: Column(children: children),
  );
}

typedef _VisibilityField = ({
  String label,
  String? subtitle,
  bool Function(ProfileUI) value,
  ProfileUI Function(ProfileUI, bool) update,
});

typedef _VisibilityGroup = ({String title, List<_VisibilityField> fields});

final List<_VisibilityGroup> _visibilityGroups = [
  (
    title: 'About you',
    fields: [
      (
        label: 'Name',
        subtitle: null,
        value: (p) => p.showName,
        update: (p, v) => p.copyWith(showName: v),
      ),
      (
        label: 'About',
        subtitle: null,
        value: (p) => p.showAbout,
        update: (p, v) => p.copyWith(showAbout: v),
      ),
      (
        label: 'Location',
        subtitle: null,
        value: (p) => p.showLocation,
        update: (p, v) => p.copyWith(showLocation: v),
      ),
    ],
  ),
  (
    title: 'Progress',
    fields: [
      (
        label: 'Points',
        subtitle: null,
        value: (p) => p.showPoints,
        update: (p, v) => p.copyWith(showPoints: v),
      ),
      (
        label: 'Activity heatmap',
        subtitle: null,
        value: (p) => p.showHeatMap,
        update: (p, v) => p.copyWith(showHeatMap: v),
      ),
      (
        label: 'Certifications',
        subtitle: null,
        value: (p) => p.showCerts,
        update: (p, v) => p.copyWith(showCerts: v),
      ),
      (
        label: 'Timeline',
        subtitle: null,
        value: (p) => p.showTimeLine,
        update: (p, v) => p.copyWith(showTimeLine: v),
      ),
    ],
  ),
  (
    title: 'Work',
    fields: [
      (
        label: 'Portfolio',
        subtitle: null,
        value: (p) => p.showPortfolio,
        update: (p, v) => p.copyWith(showPortfolio: v),
      ),
      (
        label: 'Experience',
        subtitle: null,
        value: (p) => p.showExperience,
        update: (p, v) => p.copyWith(showExperience: v),
      ),
    ],
  ),
  (
    title: 'Support',
    fields: [
      (
        label: 'Supporter badge',
        subtitle: 'Shows that you donate to freeCodeCamp',
        value: (p) => p.showDonation,
        update: (p, v) => p.copyWith(showDonation: v),
      ),
    ],
  ),
];
