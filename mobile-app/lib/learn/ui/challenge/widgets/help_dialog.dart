import 'dart:async';
import 'dart:io';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:freecodecamp/fcc_theme.dart';
import 'package:freecodecamp/learn/models/challenge_model.dart';
import 'package:freecodecamp/services/analytics_service.dart';
import 'package:url_launcher/url_launcher.dart';

const _forum = 'https://forum.freecodecamp.org';
const _readSearchAsk =
    '$_forum/t/how-to-get-help-when-you-are-stuck-coding/19514';
const _minDescription = 50;
// NOTE: Above this the forum rejects the URL, so the post body falls back to a shorter template.
const _maxUrlLength = 8000;

Future<void> showHelpDialog(
  BuildContext context,
  Challenge challenge,
  String blockName, {
  String code = '',
}) async {
  final search = Uri.parse(
    '$_forum/search?q=${Uri.encodeComponent('$blockName - ${challenge.title} in:title')}',
  );

  final proceed = await showDialog<bool>(
    context: context,
    builder: (context) => _HelpDialog(search: search),
  );
  if (proceed != true || !context.mounted) return;

  final description = await showDialog<String>(
    context: context,
    barrierDismissible: false,
    builder: (context) => _CreatePostDialog(search: search),
  );
  if (description == null || !context.mounted) return;

  unawaited(
    ProviderScope.containerOf(context, listen: false)
        .read(analyticsProvider)
        .helpRequested(
          superBlock: challenge.superBlock,
          block: challenge.block,
          challengeType: challenge.challengeType,
        ),
  );
  await launchUrl(_forumPostUrl(challenge, blockName, description, code));
}

Uri _forumPostUrl(
  Challenge challenge,
  String blockName,
  String description,
  String code,
) {
  final title = '$blockName - ${challenge.title}';
  final ending =
      '**Your mobile information:**\n```txt\n${Platform.operatingSystem} ${Platform.operatingSystemVersion}\n```\n\n'
      '**Challenge:** $title\n\n'
      '**Link to the challenge:**\n'
      'https://www.freecodecamp.org/learn/${challenge.superBlock}/${challenge.block}/${challenge.dashedName}';

  final body =
      "**Tell us what's happening:**\nDescribe your issue in detail here. \n\n$description \n\n"
      '${code.isEmpty ? '' : '**Your code so far**$code\n\n'}$ending';
  final shortBody = "**Tell us what's happening:**\n\n\n\n$ending";

  final base =
      '$_forum/new-topic?category=${Uri.encodeComponent(challenge.helpCategory)}&title=${Uri.encodeComponent(title)}&body=';
  final url = '$base${Uri.encodeComponent(body)}';

  return Uri.parse(
    url.length < _maxUrlLength ? url : '$base${Uri.encodeComponent(shortBody)}',
  );
}

TextSpan _link(String text, Uri url) => TextSpan(
  text: text,
  style: const TextStyle(
    color: FccColors.gray00,
    decoration: TextDecoration.underline,
    decorationColor: FccColors.gray00,
  ),
  recognizer: TapGestureRecognizer()..onTap = () => launchUrl(url),
);

class _DialogButton extends StatelessWidget {
  const _DialogButton({required this.label, required this.onPressed});

  final String label;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        minimumSize: const Size(double.infinity, 50),
        backgroundColor: FccColors.gray75,
        foregroundColor: FccColors.gray00,
        side: const BorderSide(width: 2, color: FccColors.gray00),
        shape: const RoundedRectangleBorder(),
      ),
      onPressed: onPressed,
      child: Text(
        label,
        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
      ),
    );
  }
}

class _HelpDialog extends StatelessWidget {
  const _HelpDialog({required this.search});

  final Uri search;

  @override
  Widget build(BuildContext context) {
    const body = TextStyle(fontSize: 16, color: FccColors.gray05);

    return Dialog(
      backgroundColor: FccColors.gray90,
      shape: const RoundedRectangleBorder(),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Wrap(
          runSpacing: 20,
          children: [
            const Text(
              'Ask for Help',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            Text.rich(
              TextSpan(
                style: body,
                children: [
                  const TextSpan(text: "If you've already tried the "),
                  _link('Read-Search-Ask', Uri.parse(_readSearchAsk)),
                  const TextSpan(
                    text:
                        ' method, then you can ask for help on the freeCodeCamp forum.',
                  ),
                ],
              ),
            ),
            Text.rich(
              TextSpan(
                style: body,
                children: [
                  const TextSpan(text: 'Before making a new post please '),
                  _link(
                    'check if your question has already been answered on the forum',
                    search,
                  ),
                  const TextSpan(text: '.'),
                ],
              ),
            ),
            _DialogButton(
              label: 'Create a post',
              onPressed: () => Navigator.of(context).pop(true),
            ),
            _DialogButton(
              label: 'Cancel',
              onPressed: () => Navigator.of(context).pop(false),
            ),
          ],
        ),
      ),
    );
  }
}

class _CreatePostDialog extends StatefulWidget {
  const _CreatePostDialog({required this.search});

  final Uri search;

  @override
  State<_CreatePostDialog> createState() => _CreatePostDialogState();
}

class _CreatePostDialogState extends State<_CreatePostDialog> {
  final _description = TextEditingController();
  bool _triedReadSearchAsk = false;
  bool _searched = false;

  @override
  void dispose() {
    _description.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final remaining = _minDescription - _description.text.length;
    final canSubmit = _triedReadSearchAsk && _searched && remaining <= 0;

    return Dialog(
      backgroundColor: FccColors.gray90,
      shape: const RoundedRectangleBorder(),
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Wrap(
          runSpacing: 20,
          children: [
            const Text(
              'Create a post',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const Text(
              'You must confirm the following statements before you can submit your post to the forum.',
              style: TextStyle(fontSize: 16, color: FccColors.gray05),
            ),
            _Statement(
              value: _triedReadSearchAsk,
              onChanged: (v) => setState(() => _triedReadSearchAsk = v),
              text: TextSpan(
                children: [
                  const TextSpan(text: 'I have tried the '),
                  _link('Read-Search-Ask', Uri.parse(_readSearchAsk)),
                  const TextSpan(text: ' method'),
                ],
              ),
            ),
            _Statement(
              value: _searched,
              onChanged: (v) => setState(() => _searched = v),
              text: TextSpan(
                children: [
                  const TextSpan(text: 'I have searched for '),
                  _link(
                    'similar questions that have already been answered on the forum',
                    widget.search,
                  ),
                ],
              ),
            ),
            if (remaining > 0)
              Text(
                'Please enter at least $remaining more characters.',
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            TextField(
              controller: _description,
              onChanged: (_) => setState(() {}),
              maxLines: 5,
              decoration: const InputDecoration(
                hintText: 'Describe your issue in detail here...',
                border: OutlineInputBorder(),
              ),
            ),
            _DialogButton(
              label: 'Submit',
              onPressed: canSubmit
                  ? () => Navigator.of(context).pop(_description.text)
                  : null,
            ),
            _DialogButton(
              label: 'Cancel',
              onPressed: () => Navigator.of(context).pop(),
            ),
          ],
        ),
      ),
    );
  }
}

class _Statement extends StatelessWidget {
  const _Statement({
    required this.value,
    required this.onChanged,
    required this.text,
  });

  final bool value;
  final ValueChanged<bool> onChanged;
  final TextSpan text;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Checkbox(
          value: value,
          onChanged: (v) => onChanged(v ?? false),
          activeColor: FccColors.gray00,
        ),
        Flexible(
          child: Text.rich(
            text,
            style: const TextStyle(fontSize: 14, color: FccColors.gray00),
          ),
        ),
      ],
    );
  }
}
