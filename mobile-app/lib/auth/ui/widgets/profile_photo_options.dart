import 'package:flutter/material.dart';
import 'package:freecodecamp/fcc_theme.dart';

enum ProfilePhotoAction { url, remove }

Future<ProfilePhotoAction?> showProfilePhotoOptions(
  BuildContext context, {
  required bool hasPhoto,
}) => showModalBottomSheet<ProfilePhotoAction>(
  context: context,
  isScrollControlled: true,
  showDragHandle: true,
  builder: (context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;
    return SafeArea(
      top: false,
      child: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text('Profile photo', style: theme.textTheme.titleLarge),
            const SizedBox(height: 6),
            Text('Square images work best.', style: theme.textTheme.bodyMedium),
            const SizedBox(height: 12),
            Text(
              'Camera and library uploads need an image hosting service. You can use an image URL or remove your photo.',
              style: theme.textTheme.bodySmall,
            ),
            const SizedBox(height: 12),
            for (final option in const [
              (Icons.camera_alt_outlined, 'Take photo'),
              (Icons.photo_library_outlined, 'Choose from library'),
            ]) ...[
              ListTile(
                enabled: false,
                contentPadding: EdgeInsets.zero,
                leading: Icon(option.$1, color: colors.outline),
                title: Text(option.$2, style: TextStyle(color: colors.outline)),
              ),
              const Divider(height: 1),
            ],
            ListTile(
              contentPadding: EdgeInsets.zero,
              leading: const Icon(Icons.link),
              title: const Text('Use image URL'),
              onTap: () => Navigator.pop(context, ProfilePhotoAction.url),
            ),
            const Divider(height: 1),
            ListTile(
              enabled: hasPhoto,
              contentPadding: EdgeInsets.zero,
              leading: Icon(
                Icons.delete_outline,
                color: hasPhoto ? colors.error : colors.outline,
              ),
              title: Text(
                'Remove photo',
                style: TextStyle(
                  color: hasPhoto ? colors.error : colors.outline,
                ),
              ),
              onTap: hasPhoto
                  ? () => Navigator.pop(context, ProfilePhotoAction.remove)
                  : null,
            ),
            const SizedBox(height: 12),
            OutlinedButton(
              onPressed: () => Navigator.pop(context),
              style: FccTheme.dialogActionStyle(context),
              child: const Text('Cancel'),
            ),
          ],
        ),
      ),
    );
  },
);
