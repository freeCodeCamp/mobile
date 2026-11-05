import 'package:flutter/material.dart';
import 'package:freecodecamp/fcc_theme.dart';

Future<String?> showImageUrlDialog(
  BuildContext context, {
  required String initialUrl,
  required String? Function(String) validate,
}) => showDialog<String>(
  context: context,
  builder: (_) => _ImageUrlDialog(initialUrl: initialUrl, validate: validate),
);

class _ImageUrlDialog extends StatefulWidget {
  const _ImageUrlDialog({required this.initialUrl, required this.validate});
  final String initialUrl;
  final String? Function(String) validate;

  @override
  State<_ImageUrlDialog> createState() => _ImageUrlDialogState();
}

class _ImageUrlDialogState extends State<_ImageUrlDialog> {
  late final _controller = TextEditingController(text: widget.initialUrl);
  String? _error;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _submit() {
    final value = _controller.text.trim();
    final error = value.isEmpty
        ? 'Enter an image URL.'
        : widget.validate(value);
    if (error != null) {
      setState(() => _error = error);
    } else {
      Navigator.pop(context, value);
    }
  }

  @override
  Widget build(BuildContext context) => AlertDialog(
    title: const Text('Image URL'),
    content: SingleChildScrollView(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Use a publicly accessible image URL.'),
          const SizedBox(height: 12),
          TextField(
            controller: _controller,
            keyboardType: TextInputType.url,
            autocorrect: false,
            textInputAction: TextInputAction.done,
            onSubmitted: (_) => _submit(),
            decoration: InputDecoration(
              labelText: 'Image URL',
              hintText: 'https://example.com/image.png',
              errorText: _error,
              errorMaxLines: 3,
            ),
          ),
        ],
      ),
    ),
    actions: [
      Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          FilledButton(
            style: FccTheme.dialogActionStyle(context, primary: true),
            onPressed: _submit,
            child: const Text('Use image'),
          ),
          const SizedBox(height: 10),
          OutlinedButton(
            style: FccTheme.dialogActionStyle(context),
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
        ],
      ),
    ],
  );
}
