import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:freecodecamp/auth/models/user_model.dart';
import 'package:freecodecamp/auth/ui/profile_visibility/profile_visibility_viewmodel.dart';
import 'package:freecodecamp/auth/ui/widgets/profile_form.dart';
import 'package:freecodecamp/fcc_theme.dart';
import 'package:freecodecamp/routing/auth.dart';
import 'package:freecodecamp/services/auth_service.dart';
import 'package:freecodecamp/widgets/error_retry.dart';
import 'package:freecodecamp/widgets/fcc_switch.dart';
import 'package:freecodecamp/widgets/segmented_tabs.dart';

class ProfileVisibilityView extends ConsumerStatefulWidget {
  const ProfileVisibilityView({super.key});

  @override
  ConsumerState<ProfileVisibilityView> createState() =>
      _ProfileVisibilityViewState();
}

class _ProfileVisibilityViewState extends ConsumerState<ProfileVisibilityView> {
  final _scaffold = GlobalKey<ProfileFormScaffoldState>();
  final _scroll = ScrollController();

  @override
  void dispose() {
    _scroll.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    final saved = await ref.read(profileVisibilityProvider.notifier).save();
    if (!mounted) return;
    if (saved) {
      await _scaffold.currentState?.close();
    } else if (_scroll.hasClients) {
      await _scroll.animateTo(
        0,
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeOut,
      );
    }
  }

  void _update(ProfileUI draft) =>
      ref.read(profileVisibilityProvider.notifier).update(draft);

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
    final locked = state?.draft.isLocked ?? false;
    return ProfileFormScaffold(
      key: _scaffold,
      title: 'Profile visibility',
      showNavigation: false,
      isDirty: state?.isDirty ?? false,
      saving: state?.saving ?? false,
      onSave: enabled && state.isDirty ? _save : null,
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
              controller: _scroll,
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
                        Text('Who can see your profile', style: sectionTitle),
                        const SizedBox(height: 12),
                        SegmentedTabs<bool>(
                          tabs: const [
                            (value: false, label: 'Public', icon: Icons.public),
                            (
                              value: true,
                              label: 'Private',
                              icon: Icons.lock_outline,
                            ),
                          ],
                          selected: state.draft.isLocked,
                          onSelected: enabled
                              ? (isLocked) => _update(
                                  state.draft.copyWith(isLocked: isLocked),
                                )
                              : null,
                        ),
                        const SizedBox(height: 12),
                        if (state.draft.isLocked)
                          Text(
                            'Only you can see your profile.',
                            style: theme.textTheme.bodyMedium?.copyWith(
                              color: theme.colorScheme.onSurfaceVariant,
                            ),
                          )
                        else
                          LayoutBuilder(
                            builder: (context, constraints) {
                              final style = theme.textTheme.bodyMedium
                                  ?.copyWith(
                                    color: theme.colorScheme.onSurfaceVariant,
                                  );
                              return Text.rich(
                                TextSpan(
                                  children: [
                                    const TextSpan(
                                      text: 'Anyone can see your profile at ',
                                    ),
                                    WidgetSpan(
                                      alignment: PlaceholderAlignment.baseline,
                                      baseline: TextBaseline.alphabetic,
                                      child: ConstrainedBox(
                                        constraints: BoxConstraints(
                                          maxWidth: constraints.maxWidth,
                                        ),
                                        child: FittedBox(
                                          fit: BoxFit.scaleDown,
                                          child: Text(
                                            'freecodecamp.org/${state.original.username}.',
                                            style: style,
                                            maxLines: 1,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                style: style,
                              );
                            },
                          ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                Text('Show on your public profile', style: sectionTitle),
                if (state.draft.isLocked) ...[
                  const SizedBox(height: 4),
                  Text(
                    'These choices apply when your profile is public. Switch to Public to change them.',
                    style: theme.textTheme.bodySmall?.copyWith(
                      fontSize: 13,
                      height: 1.4,
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
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
                      for (final (index, field) in group.fields.indexed) ...[
                        if (index > 0) const Divider(height: 1),
                        _VisibilitySwitchRow(
                          label: field.label,
                          subtitle: field.subtitle,
                          locked: locked,
                          value: field.value(state.draft),
                          onChanged: enabled && !locked
                              ? (value) =>
                                    _update(field.update(state.draft, value))
                              : null,
                        ),
                      ],
                    ],
                  ),
                ],
              ],
            ),
    );
  }
}

class _VisibilitySwitchRow extends StatelessWidget {
  const _VisibilitySwitchRow({
    required this.label,
    required this.subtitle,
    required this.locked,
    required this.value,
    required this.onChanged,
  });
  final String label;
  final String? subtitle;
  final bool locked;
  final bool value;
  final ValueChanged<bool>? onChanged;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final muted = theme.colorScheme.onSurfaceVariant;
    final onChanged = this.onChanged;
    return MergeSemantics(
      child: InkWell(
        onTap: onChanged == null ? null : () => onChanged(!value),
        child: ConstrainedBox(
          constraints: const BoxConstraints(minHeight: 56),
          child: Padding(
            padding: const EdgeInsetsDirectional.fromSTEB(14, 4, 12, 4),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        label,
                        style: theme.textTheme.bodyLarge?.copyWith(
                          fontWeight: FontWeight.w700,
                          color: locked ? muted : null,
                        ),
                      ),
                      if (subtitle != null)
                        Text(
                          subtitle!,
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: muted,
                          ),
                        ),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                if (locked) ...[
                  ExcludeSemantics(
                    child: Icon(Icons.lock_outline, size: 16, color: muted),
                  ),
                  const SizedBox(width: 12),
                ],
                FccSwitch(
                  value: value,
                  onChanged: onChanged,
                  semanticLabel: label,
                ),
              ],
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
    shape: FccTheme.cardShape(context),
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
        label: 'Location',
        subtitle: null,
        value: (p) => p.showLocation,
        update: (p, v) => p.copyWith(showLocation: v),
      ),
      (
        label: 'About',
        subtitle: null,
        value: (p) => p.showAbout,
        update: (p, v) => p.copyWith(showAbout: v),
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
