import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:freecodecamp/auth/ui/profile_project/profile_project_viewmodel.dart';
import 'package:freecodecamp/auth/ui/widgets/image_url_dialog.dart';
import 'package:freecodecamp/auth/ui/widgets/profile_form.dart';
import 'package:freecodecamp/fcc_theme.dart';
import 'package:freecodecamp/widgets/dialog/confirm_dialog.dart';

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

  Future<void> _changeImage() async {
    final notifier = ref.read(
      profileProjectProvider(widget.projectId).notifier,
    );
    final url = await showImageUrlDialog(
      context,
      initialUrl:
          ref.read(profileProjectProvider(widget.projectId))?.draft.image ?? '',
      validate: notifier.imageError,
    );
    if (mounted && url != null) notifier.update(image: url);
  }

  Future<void> _delete() async {
    final confirmed = await showConfirmDialog(
      context,
      title: 'Delete project?',
      description: 'This project will be removed when you save your profile.',
      confirmLabel: 'Delete project',
      destructive: true,
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
            CustomPaint(
              painter: _ImageBorder(Theme.of(context).colorScheme.outline),
              child: SizedBox(
                width: double.infinity,
                height: 180,
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    if (image.isNotEmpty)
                      Padding(
                        padding: const EdgeInsets.fromLTRB(8, 8, 8, 56),
                        child: CachedNetworkImage(
                          imageUrl: image,
                          width: double.infinity,
                          height: 116,
                          fit: BoxFit.contain,
                          errorWidget: (_, _, _) => const Center(
                            child: Icon(Icons.broken_image_outlined),
                          ),
                        ),
                      ),
                    Align(
                      alignment: image.isEmpty
                          ? Alignment.center
                          : Alignment.bottomCenter,
                      child: Padding(
                        padding: const EdgeInsets.all(8),
                        child: OutlinedButton(
                          style: FccTheme.compactOutlineStyle(context).copyWith(
                            shape: FccTheme.focusShape(context, radius: 999),
                          ),
                          onPressed: form.saving ? null : _changeImage,
                          child: Text(
                            image.isEmpty ? 'Add image' : 'Change image',
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Use an image URL. Uploading from your device is not available yet.',
              style: Theme.of(context).textTheme.bodySmall,
            ),
            if (image.isNotEmpty)
              Align(
                alignment: Alignment.centerLeft,
                child: TextButton(
                  onPressed: form.saving
                      ? null
                      : () => notifier.update(image: ''),
                  style: TextButton.styleFrom(
                    foregroundColor: Theme.of(context).colorScheme.error,
                  ),
                  child: const Text('Remove image'),
                ),
              ),
            if (form.errors['image'] case final message?)
              ProfileFieldError(message: message),
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
              maxLength: 500,
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

class _ImageBorder extends CustomPainter {
  const _ImageBorder(this.color);
  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final path = Path()
      ..addRRect(
        RRect.fromRectAndRadius(
          (Offset.zero & size).deflate(.5),
          const Radius.circular(12),
        ),
      );
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1;
    for (final metric in path.computeMetrics()) {
      for (var offset = 0.0; offset < metric.length; offset += 10) {
        canvas.drawPath(metric.extractPath(offset, offset + 6), paint);
      }
    }
  }

  @override
  bool shouldRepaint(_ImageBorder oldDelegate) => color != oldDelegate.color;
}
