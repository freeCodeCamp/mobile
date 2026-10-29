import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:freecodecamp/auth/ui/profile_project/profile_project_viewmodel.dart';
import 'package:freecodecamp/auth/ui/widgets/profile_form.dart';
import 'package:freecodecamp/fcc_theme.dart';

class ProfileProjectView extends ConsumerStatefulWidget {
  const ProfileProjectView({super.key, this.projectId});

  final String? projectId;

  @override
  ConsumerState<ProfileProjectView> createState() => _ProfileProjectViewState();
}

class _ProfileProjectViewState extends ConsumerState<ProfileProjectView> {
  final _formKey = GlobalKey<ProfileFormScaffoldState>();
  late final TextEditingController _title;
  late final TextEditingController _url;
  late final TextEditingController _description;

  @override
  void initState() {
    super.initState();
    final project = ref.read(profileProjectProvider(widget.projectId))?.draft;
    _title = TextEditingController(text: project?.title ?? '');
    _url = TextEditingController(text: project?.url ?? '');
    _description = TextEditingController(text: project?.description ?? '');
  }

  @override
  void dispose() {
    _title.dispose();
    _url.dispose();
    _description.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    if (ref.read(profileProjectProvider(widget.projectId).notifier).save()) {
      await _formKey.currentState?.close();
    }
  }

  Future<void> _delete() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete project?'),
        content: const Text(
          'This project will be removed when you save your profile.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancel'),
          ),
          TextButton(
            style: TextButton.styleFrom(
              foregroundColor: Theme.of(context).colorScheme.error,
            ),
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('Delete project'),
          ),
        ],
      ),
    );
    if (!mounted || confirmed != true) return;
    if (ref.read(profileProjectProvider(widget.projectId).notifier).delete()) {
      await _formKey.currentState?.close();
    }
  }

  @override
  Widget build(BuildContext context) {
    final form = ref.watch(profileProjectProvider(widget.projectId));
    final notifier = ref.read(
      profileProjectProvider(widget.projectId).notifier,
    );
    final available = form != null && form.available;
    final colors = Theme.of(context).colorScheme;
    final image = form?.draft.image?.trim() ?? '';
    return ProfileFormScaffold(
      key: _formKey,
      title: widget.projectId == null ? 'Add project' : 'Edit project',
      isDirty: form?.isDirty ?? false,
      navigationDirty: form?.navigationDirty ?? false,
      saving: form?.saving ?? false,
      onSave: available ? _save : null,
      child: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          if (!available)
            const ProfileFormError(
              message:
                  'This project is unavailable. Return to Edit profile to try again.',
            )
          else ...[
            if (form.errors['form'] case final message?)
              ProfileFormError(
                message: message,
                onDismiss: notifier.dismissError,
              ),
            Text(
              'Project image',
              style: Theme.of(context).textTheme.labelLarge,
            ),
            const SizedBox(height: 8),
            ProfileDashedBorder(
              color: colors.outline,
              child: Container(
                height: 180,
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: colors.surface,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    OutlinedButton.icon(
                      style: FccTheme.compactOutlineStyle(context).copyWith(
                        shape: FccTheme.focusShape(
                          context,
                          radius: 999,
                          color: FccDesignColors.of(context).accentText,
                        ),
                      ),
                      onPressed: null,
                      icon: const Icon(Icons.image_outlined, size: 18),
                      label: Text(image.isEmpty ? 'Add image' : 'Change image'),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Optional. Landscape images work best.',
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        fontSize: 13,
                        color: colors.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Project image changes are not available in the app yet.',
              style: Theme.of(context).textTheme.bodySmall,
            ),
            const SizedBox(height: 18),
            ProfileFormField(
              label: 'Project title',
              hintText: 'e.g. Weather dashboard',
              controller: _title,
              errorText: form.errors['title'],
              enabled: !form.saving,
              onChanged: (value) => notifier.update(title: value),
            ),
            ProfileFormField(
              label: 'Link',
              hintText: 'https://example.com',
              controller: _url,
              keyboardType: TextInputType.url,
              errorText: form.errors['url'],
              enabled: !form.saving,
              onChanged: (value) => notifier.update(url: value),
            ),
            ProfileFormField(
              label: 'Description',
              hintText: 'What it does and what you used to build it',
              controller: _description,
              maxLength: 288,
              maxLines: 4,
              errorText: form.errors['description'],
              enabled: !form.saving,
              onChanged: (value) => notifier.update(description: value),
            ),
            if (widget.projectId != null) ...[
              OutlinedButton.icon(
                onPressed: form.saving ? null : _delete,
                style: FccTheme.dangerOutlineStyle(context),
                icon: const Icon(Icons.delete_outline),
                label: const Text('Delete project'),
              ),
            ],
          ],
        ],
      ),
    );
  }
}
