import 'package:flutter/material.dart';

Future<void> showProfilePhotoOptions(BuildContext context) =>
    showModalBottomSheet<void>(
      context: context,
      showDragHandle: true,
      builder: (context) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                'Change photo',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 12),
              const Text('Photo changes are not available in the app yet.'),
              const SizedBox(height: 12),
              const ListTile(
                enabled: false,
                leading: Icon(Icons.photo_camera_outlined),
                title: Text('Take photo'),
              ),
              const ListTile(
                enabled: false,
                leading: Icon(Icons.photo_library_outlined),
                title: Text('Choose from library'),
              ),
              const ListTile(
                enabled: false,
                leading: Icon(Icons.delete_outline),
                title: Text('Remove photo'),
              ),
            ],
          ),
        ),
      ),
    );
