import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:freecodecamp/auth/controllers/profile_editor_controller.dart';
import 'package:freecodecamp/auth/ui/profile_edit/profile_edit_viewmodel.dart';
import 'package:freecodecamp/auth/ui/widgets/profile_form.dart';
import 'package:freecodecamp/auth/ui/widgets/profile_photo_options.dart';
import 'package:freecodecamp/fcc_theme.dart';
import 'package:freecodecamp/routing/auth.dart';
import 'package:freecodecamp/services/auth_service.dart';
import 'package:freecodecamp/widgets/error_retry.dart';

class ProfileEditView extends ConsumerStatefulWidget {
  const ProfileEditView({super.key});

  @override
  ConsumerState<ProfileEditView> createState() => _ProfileEditViewState();
}

class _ProfileEditViewState extends ConsumerState<ProfileEditView> {
  final _scaffold = GlobalKey<ProfileFormScaffoldState>();
  final _scroll = ScrollController();
  final _fields = <String, TextEditingController>{};
  String? _dismissedError;

  @override
  void dispose() {
    for (final field in _fields.values) {
      field.dispose();
    }
    _scroll.dispose();
    super.dispose();
  }

  void _syncFields(Map<String, String> fields) {
    for (final entry in fields.entries) {
      final controller = _fields.putIfAbsent(
        entry.key,
        TextEditingController.new,
      );
      if (controller.text != entry.value) {
        controller.value = TextEditingValue(
          text: entry.value,
          selection: TextSelection.collapsed(offset: entry.value.length),
        );
      }
    }
  }

  Future<void> _save() async {
    setState(() => _dismissedError = null);
    FocusScope.of(context).unfocus();
    final saved = await ref.read(profileEditorProvider.notifier).save();
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

  @override
  Widget build(BuildContext context) {
    final auth = ref.watch(authProvider);
    final editor = ref.watch(profileEditorProvider);
    final presentation = ref.watch(profileEditPresentationProvider);
    if (editor == null || presentation == null) {
      return ProfileFormScaffold(
        title: 'Edit profile',
        isDirty: false,
        onSave: null,
        child: auth.isLoading
            ? const Center(child: CircularProgressIndicator())
            : auth.hasError
            ? ErrorRetry(
                message: 'Unable to load your profile.',
                onRetry: () => ref.invalidate(authProvider),
              )
            : ListView(
                padding: const EdgeInsets.all(16),
                children: [
                  const ProfileFormError(
                    message: 'Sign in to edit your profile.',
                  ),
                  FilledButton(
                    onPressed: () => const LoginRoute().push<void>(context),
                    child: const Text('Sign in'),
                  ),
                ],
              ),
      );
    }
    _syncFields(presentation.fields);
    final user = editor.draft;
    final enabled = !editor.saving && !editor.needsRefresh;
    final theme = Theme.of(context);
    final colors = theme.colorScheme;
    Widget field(
      String key,
      String label, {
      String? hint,
      String? helper,
      int lines = 1,
      int? maxLength,
      TextInputType? keyboard,
    }) => ProfileFormField(
      label: label,
      controller: _fields[key]!,
      enabled: enabled,
      errorText: editor.errors[key],
      helperText: helper,
      hintText: hint,
      maxLength: maxLength,
      maxLines: lines,
      keyboardType: keyboard,
      style: key == 'username'
          ? const TextStyle(fontFamily: 'JetBrains Mono')
          : null,
      onChanged: (value) =>
          ref.read(profileEditorProvider.notifier).updateField(key, value),
    );

    return ProfileFormScaffold(
      key: _scaffold,
      title: 'Edit profile',
      isDirty: editor.isDirty,
      saving: editor.saving,
      onSave: _save,
      child: Stack(
        children: [
          ListView(
            controller: _scroll,
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 32),
            children: [
              Center(
                child: CircleAvatar(
                  radius: 48,
                  backgroundColor: colors.primaryContainer,
                  backgroundImage: user.picture.isEmpty
                      ? null
                      : CachedNetworkImageProvider(user.picture),
                  child: user.picture.isEmpty
                      ? Icon(
                          Icons.person_outline,
                          size: 42,
                          color: colors.onSurfaceVariant,
                        )
                      : null,
                ),
              ),
              const SizedBox(height: 12),
              Center(
                child: OutlinedButton.icon(
                  style: FccTheme.compactOutlineStyle(
                    context,
                  ).copyWith(shape: FccTheme.focusShape(context, radius: 999)),
                  onPressed: enabled
                      ? () => showProfilePhotoOptions(context)
                      : null,
                  icon: const Icon(Icons.photo_camera_outlined, size: 18),
                  label: const Text('Change photo'),
                ),
              ),
              const SizedBox(height: 24),
              const ProfileFormSectionTitle('Basic info'),
              field('username', 'Username', helper: presentation.usernameHint),
              field('name', 'Name'),
              field('location', 'Location', hint: 'City, country'),
              field(
                'about',
                'About',
                hint: 'A sentence or two about you and what you\'re learning',
                lines: 5,
                maxLength: 500,
                keyboard: TextInputType.multiline,
              ),
              const SizedBox(height: 14),
              const ProfileFormSectionTitle('Internet presence'),
              field(
                'githubProfile',
                'GitHub',
                hint: 'https://github.com/username',
                keyboard: TextInputType.url,
              ),
              field(
                'linkedin',
                'LinkedIn',
                hint: 'https://linkedin.com/in/username',
                keyboard: TextInputType.url,
              ),
              field(
                'twitter',
                'X',
                hint: 'https://x.com/username',
                keyboard: TextInputType.url,
              ),
              field(
                'bluesky',
                'Bluesky',
                hint: 'https://bsky.app/profile/username',
                keyboard: TextInputType.url,
              ),
              field(
                'website',
                'Personal website',
                hint: 'https://example.com',
                keyboard: TextInputType.url,
              ),
              const ProfileFormSectionTitle('Portfolio'),
              if (user.portfolio.isNotEmpty) ...[
                Card(
                  clipBehavior: Clip.antiAlias,
                  child: Column(
                    children: [
                      for (final (index, project)
                          in user.portfolio.indexed) ...[
                        if (index > 0) const Divider(),
                        _EntryRow(
                          icon: Icons.image_outlined,
                          title: project.title ?? '',
                          detail: project.url ?? '',
                          image: project.image,
                          onTap: enabled
                              ? () => ProfileProjectRoute(
                                  projectId: project.id,
                                ).push<void>(context)
                              : null,
                        ),
                      ],
                    ],
                  ),
                ),
                const SizedBox(height: 10),
              ],
              _AddEntry(
                label: 'Add project',
                onPressed: enabled
                    ? () => const ProfileProjectRoute().push<void>(context)
                    : null,
              ),
              const SizedBox(height: 18),
              const ProfileFormSectionTitle('Experience'),
              if (user.experience.isNotEmpty) ...[
                Card(
                  clipBehavior: Clip.antiAlias,
                  child: Column(
                    children: [
                      for (final (index, experience)
                          in user.experience.indexed) ...[
                        if (index > 0) const Divider(),
                        _EntryRow(
                          icon: Icons.work_outline,
                          title: experience.title,
                          detail:
                              presentation.experienceDetails[experience.id] ??
                              '',
                          onTap: enabled
                              ? () => ProfileExperienceRoute(
                                  experienceId: experience.id,
                                ).push<void>(context)
                              : null,
                        ),
                      ],
                    ],
                  ),
                ),
                const SizedBox(height: 10),
              ],
              _AddEntry(
                label: 'Add experience',
                onPressed: enabled
                    ? () => const ProfileExperienceRoute().push<void>(context)
                    : null,
              ),
            ],
          ),
          if (presentation.errorMessage != null &&
              presentation.errorMessage != _dismissedError)
            Positioned(
              top: 8,
              left: 12,
              right: 12,
              child: ProfileFormError(
                message: presentation.errorMessage!,
                margin: EdgeInsets.zero,
                floating: true,
                onDismiss: () =>
                    setState(() => _dismissedError = presentation.errorMessage),
              ),
            ),
        ],
      ),
    );
  }
}

class _EntryRow extends StatelessWidget {
  const _EntryRow({
    required this.icon,
    required this.title,
    required this.detail,
    required this.onTap,
    this.image,
  });
  final IconData icon;
  final String title;
  final String detail;
  final VoidCallback? onTap;
  final String? image;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final fallback = ColoredBox(
      color: theme.colorScheme.surfaceContainer,
      child: Icon(icon, color: theme.colorScheme.onSurfaceVariant, size: 22),
    );
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      leading: ClipRRect(
        borderRadius: BorderRadius.circular(9),
        child: SizedBox(
          width: 40,
          height: 40,
          child: image?.isNotEmpty ?? false
              ? CachedNetworkImage(
                  imageUrl: image!,
                  width: 40,
                  height: 40,
                  fit: BoxFit.cover,
                  placeholder: (_, _) => fallback,
                  errorWidget: (_, _, _) => fallback,
                )
              : fallback,
        ),
      ),
      title: Text(title, style: theme.textTheme.titleMedium),
      subtitle: detail.isEmpty
          ? null
          : Text(detail, style: theme.textTheme.bodySmall),
      trailing: const Icon(Icons.chevron_right, size: 20),
      onTap: onTap,
    );
  }
}

class _AddEntry extends StatelessWidget {
  const _AddEntry({required this.label, required this.onPressed});
  final String label;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) => OutlinedButton.icon(
    onPressed: onPressed,
    icon: const Icon(Icons.add, size: 20),
    label: Text(label),
  );
}
