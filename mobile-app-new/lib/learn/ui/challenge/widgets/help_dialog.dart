import 'dart:io';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:mobile_app_new/fcc_theme.dart';
import 'package:mobile_app_new/learn/models/challenge_model.dart';
import 'package:mobile_app_new/learn/models/curriculum_model.dart';
import 'package:url_launcher/url_launcher.dart';

const _forum = 'https://forum.freecodecamp.org';
const _readSearchAsk =
    '$_forum/t/how-to-get-help-when-you-are-stuck-coding/19514';
const _minDescription = 50;
// Keep the draft editable when the encoded URL exceeds the forum limit.
const _maxUrlLength = 8000;

Future<void> showHelpDialog(
  BuildContext context,
  Challenge challenge,
  Block block,
) async {
  final search = Uri.parse(
    '$_forum/search?q=${Uri.encodeComponent('${block.name} - ${challenge.title} in:title')}',
  );

  final proceed = await showModalBottomSheet<bool>(
    context: context,
    isScrollControlled: true,
    useSafeArea: true,
    backgroundColor: Theme.of(context).colorScheme.surface,
    builder: (context) => _HelpDialog(search: search),
  );
  if (proceed != true || !context.mounted) return;

  await showDialog<void>(
    context: context,
    useSafeArea: false,
    barrierDismissible: false,
    builder: (context) => _CreatePostDialog(
      search: search,
      postUrl: (description) => _forumPostUrl(challenge, block, description),
    ),
  );
}

Uri _forumPostUrl(Challenge challenge, Block block, String description) {
  final title = '${block.name} - ${challenge.title}';
  final ending =
      '**Your mobile information:**\n```txt\n${Platform.operatingSystem} ${Platform.operatingSystemVersion}\n```\n\n'
      '**Challenge:** $title\n\n'
      '**Link to the challenge:**\n'
      'https://www.freecodecamp.org/learn/${challenge.superBlock}/${challenge.block}/${challenge.dashedName}';

  final body =
      "**Tell us what's happening:**\nDescribe your issue in detail here. \n\n$description \n\n$ending";

  final base =
      '$_forum/new-topic?category=${Uri.encodeComponent(challenge.helpCategory)}&title=${Uri.encodeComponent(title)}&body=';
  final url = '$base${Uri.encodeComponent(body)}';

  return Uri.parse(url);
}

class _HelpDialog extends StatelessWidget {
  const _HelpDialog({required this.search});

  final Uri search;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return SafeArea(
      top: false,
      child: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                CircleAvatar(
                  backgroundColor: colors.primaryContainer,
                  foregroundColor: colors.primary,
                  radius: 22,
                  child: const Icon(Icons.chat_bubble_outline),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    'Stuck? Get help',
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            _HelpStep(
              number: 1,
              child: _LinkedText(
                before: 'Try ',
                link: 'Read-Search-Ask',
                after: ' first.',
                url: Uri.parse(_readSearchAsk),
              ),
            ),
            const SizedBox(height: 12),
            const _HelpStep(
              number: 2,
              child: Text('Search the forum for your question.'),
            ),
            const SizedBox(height: 12),
            const _HelpStep(
              number: 3,
              child: Text(
                'Still stuck? Create a post. We add your device information and the challenge link.',
              ),
            ),
            const SizedBox(height: 24),
            OutlinedButton.icon(
              style: OutlinedButton.styleFrom(
                backgroundColor: colors.surfaceContainer,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              onPressed: () => launchUrl(search),
              icon: const Icon(Icons.search),
              label: const Text('Search the forum'),
            ),
            const SizedBox(height: 12),
            _PrimaryButton(
              label: 'Create a post',
              onPressed: () => Navigator.of(context).pop(true),
            ),
            const SizedBox(height: 12),
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: Text(
                'Not now',
                style: TextStyle(color: colors.onSurfaceVariant),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _HelpStep extends StatelessWidget {
  const _HelpStep({required this.number, required this.child});

  final int number;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CircleAvatar(
          radius: 14,
          backgroundColor: colors.surfaceContainer,
          foregroundColor: colors.onSurface,
          child: Text(
            '$number',
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: DefaultTextStyle.merge(
            style: Theme.of(context).textTheme.bodyLarge,
            child: child,
          ),
        ),
      ],
    );
  }
}

class _CreatePostDialog extends StatefulWidget {
  const _CreatePostDialog({required this.search, required this.postUrl});

  final Uri search;
  final Uri Function(String description) postUrl;

  @override
  State<_CreatePostDialog> createState() => _CreatePostDialogState();
}

class _CreatePostDialogState extends State<_CreatePostDialog> {
  final _description = TextEditingController();
  bool _triedReadSearchAsk = false;
  bool _searched = false;
  bool _opening = false;
  String? _launchError;

  Future<void> _openForum() async {
    setState(() {
      _opening = true;
      _launchError = null;
    });
    try {
      final opened = await launchUrl(widget.postUrl(_description.text));
      if (!mounted) return;
      if (opened) {
        Navigator.of(context).pop();
        return;
      }
    } catch (_) {
      // Retain the draft if the browser cannot be opened.
    }
    if (mounted) {
      setState(() {
        _opening = false;
        _launchError =
            'Could not open the forum. Your draft is still here. Try again.';
      });
    }
  }

  @override
  void dispose() {
    _description.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;
    final remaining = _minDescription - _description.text.length;
    final tooLong =
        widget.postUrl(_description.text).toString().length >= _maxUrlLength;
    final canSubmit =
        _triedReadSearchAsk &&
        _searched &&
        remaining <= 0 &&
        !tooLong &&
        !_opening;

    return Dialog.fullscreen(
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            tooltip: 'Close',
            icon: const Icon(Icons.close),
            onPressed: () => Navigator.of(context).pop(),
          ),
          title: const Text('Create a post'),
        ),
        body: SafeArea(
          top: false,
          child: Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Text(
                        'Before you post, please confirm:',
                        style: theme.textTheme.bodyLarge?.copyWith(
                          color: colors.onSurfaceVariant,
                        ),
                      ),
                      const SizedBox(height: 16),
                      _Statement(
                        value: _triedReadSearchAsk,
                        onChanged: (v) =>
                            setState(() => _triedReadSearchAsk = v),
                        child: _LinkedText(
                          before: 'I have tried the ',
                          link: 'Read-Search-Ask',
                          after: ' method',
                          url: Uri.parse(_readSearchAsk),
                        ),
                      ),
                      const SizedBox(height: 16),
                      _Statement(
                        value: _searched,
                        onChanged: (v) => setState(() => _searched = v),
                        child: _LinkedText(
                          before: 'I have searched for ',
                          link:
                              'similar questions that have already been answered on the forum',
                          url: widget.search,
                        ),
                      ),
                      const SizedBox(height: 24),
                      Text(
                        'Describe your issue',
                        style: theme.textTheme.titleMedium,
                      ),
                      const SizedBox(height: 8),
                      TextField(
                        controller: _description,
                        onChanged: (_) => setState(() => _launchError = null),
                        minLines: 5,
                        maxLines: 8,
                        decoration: InputDecoration(
                          errorMaxLines: 4,
                          errorText: tooLong
                              ? 'This description is too long to open on the forum. Shorten it before continuing; your text has been kept.'
                              : null,
                          hintText: 'What did you try, and what happened?',
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        tooLong
                            ? 'Shorten your description to continue.'
                            : remaining > 0
                            ? 'Add at least $remaining more characters.'
                            : "Great, that's enough detail.",
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: tooLong
                              ? colors.error
                              : remaining > 0
                              ? colors.onSurfaceVariant
                              : FccDesignColors.of(context).success,
                        ),
                      ),
                      const SizedBox(height: 16),
                      Card(
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "We'll attach automatically",
                                style: theme.textTheme.titleMedium?.copyWith(
                                  color: colors.onSurfaceVariant,
                                ),
                              ),
                              const SizedBox(height: 8),
                              const _Attachment('Your device information'),
                              const _Attachment(
                                'The challenge and a link to it',
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const Divider(),
              Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(
                      !_triedReadSearchAsk || !_searched
                          ? 'Tick both boxes to continue.'
                          : 'Review and publish your post on the forum.',
                      textAlign: TextAlign.center,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: colors.onSurfaceVariant,
                      ),
                    ),
                    const SizedBox(height: 8),
                    if (_launchError != null)
                      Padding(
                        padding: const EdgeInsets.only(bottom: 8),
                        child: Text(
                          _launchError!,
                          style: TextStyle(color: colors.error),
                        ),
                      ),
                    _PrimaryButton(
                      label: _opening ? 'Opening forum…' : 'Continue to forum',
                      onPressed: canSubmit ? _openForum : null,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _Attachment extends StatelessWidget {
  const _Attachment(this.text);
  final String text;

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.symmetric(vertical: 3),
    child: Row(
      children: [
        Icon(Icons.check, size: 18, color: FccDesignColors.of(context).success),
        const SizedBox(width: 8),
        Expanded(child: Text(text)),
      ],
    ),
  );
}

class _Statement extends StatelessWidget {
  const _Statement({
    required this.value,
    required this.onChanged,
    required this.child,
  });

  final bool value;
  final ValueChanged<bool> onChanged;
  final Widget child;

  @override
  Widget build(BuildContext context) => Row(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Checkbox(
        value: value,
        onChanged: (v) => onChanged(v ?? false),
        activeColor: Theme.of(context).colorScheme.primary,
        checkColor: Theme.of(context).colorScheme.onPrimary,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
      ),
      const SizedBox(width: 4),
      Expanded(
        child: Padding(padding: const EdgeInsets.only(top: 10), child: child),
      ),
    ],
  );
}

class _PrimaryButton extends StatelessWidget {
  const _PrimaryButton({required this.label, required this.onPressed});
  final String label;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) => FilledButton(
    style: FilledButton.styleFrom(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      minimumSize: const Size(double.infinity, 48),
      disabledBackgroundColor: Theme.of(context).colorScheme.surfaceContainer,
      disabledForegroundColor: Theme.of(context).colorScheme.onSurfaceVariant,
    ),
    onPressed: onPressed,
    child: Text(
      label,
      style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
    ),
  );
}

class _LinkedText extends StatefulWidget {
  const _LinkedText({
    required this.before,
    required this.link,
    this.after = '',
    required this.url,
  });
  final String before;
  final String link;
  final String after;
  final Uri url;

  @override
  State<_LinkedText> createState() => _LinkedTextState();
}

class _LinkedTextState extends State<_LinkedText> {
  late final _recognizer = TapGestureRecognizer()
    ..onTap = () => launchUrl(widget.url);

  @override
  void dispose() {
    _recognizer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Text.rich(
    TextSpan(
      children: [
        TextSpan(text: widget.before),
        TextSpan(
          text: widget.link,
          recognizer: _recognizer,
          style: TextStyle(
            color: FccDesignColors.of(context).accentText,
            decoration: TextDecoration.underline,
            decorationColor: FccDesignColors.of(context).accentText,
          ),
        ),
        TextSpan(text: widget.after),
      ],
    ),
    style: Theme.of(context).textTheme.bodyLarge,
  );
}
