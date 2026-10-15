import 'package:flutter/material.dart';
import 'package:mobile_app_new/fcc_theme.dart';
import 'package:mobile_app_new/learn/ui/challenge/widgets/challenge_card.dart';
import 'package:mobile_app_new/learn/ui/challenge/widgets/challenge_layout.dart';
import 'package:mobile_app_new/learn/models/challenge_model.dart';
import 'package:mobile_app_new/learn/models/curriculum_model.dart';
import 'package:mobile_app_new/learn/ui/challenge/widgets/challenge_button.dart';
import 'package:mobile_app_new/learn/ui/challenge/widgets/complete_button.dart';
import 'package:mobile_app_new/learn/ui/challenge/widgets/help_dialog.dart';
import 'package:mobile_app_new/learn/ui/challenge/widgets/parsed_html.dart';

String? _linkError(String link) {
  final uri = Uri.tryParse(link);
  if (uri == null ||
      uri.host.isEmpty ||
      !['https', 'http'].contains(uri.scheme)) {
    return 'Please enter a valid HTTPS link.';
  }
  final host = uri.host.toLowerCase();
  if (host == 'localhost' ||
      host.endsWith('.localhost') ||
      host == '127.0.0.1' ||
      host == '::1') {
    return 'Remember to submit a publicly visible app URL.';
  }
  if (uri.scheme != 'https') return 'Please use a secure (https) URL.';
  if (host == 'freecodecamp.org' ||
      host.endsWith('.freecodecamp.org') ||
      host == 'freecodecamp.rocks' ||
      host.endsWith('.freecodecamp.rocks') ||
      (['github.com', 'codepen.io'].contains(host) &&
          uri.pathSegments.firstOrNull?.toLowerCase() == 'freecodecamp')) {
    return 'Remember to submit your own work.';
  }
  return null;
}

class PythonProjectView extends StatefulWidget {
  const PythonProjectView({
    super.key,
    required this.challenge,
    required this.block,
  });

  final Challenge challenge;
  final Block block;

  @override
  State<PythonProjectView> createState() => _PythonProjectViewState();
}

class _PythonProjectViewState extends State<PythonProjectView> {
  final _link = TextEditingController();
  bool _checked = false;
  String? _error;

  bool get _valid => _checked && _error == null;

  @override
  void dispose() {
    _link.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final challenge = widget.challenge;
    final colors = Theme.of(context).colorScheme;
    return Scaffold(
      appBar: challengeAppBar(
        context,
        title: widget.block.name,
        subtitle:
            'Project ${widget.block.challenges.indexWhere((c) => c.id == challenge.id) + 1} of ${widget.block.challenges.length}',
        actions: [
          IconButton(
            tooltip: 'Ask for help',
            icon: const Icon(Icons.help_outline),
            onPressed: () => showHelpDialog(context, challenge, widget.block),
          ),
        ],
      ),
      body: SafeArea(
        bottom: false,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            Text(
              challenge.title,
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            const SizedBox(height: 20),
            ChallengeCard(
              title: '1. Build it',
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  ParsedHtml(challenge.description),
                  if (challenge.instructions.isNotEmpty)
                    ParsedHtml(challenge.instructions),
                ],
              ),
            ),
            ChallengeCard(
              title: '2. Submit it',
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    'Paste a public link to your finished project.',
                    style: TextStyle(color: colors.onSurfaceVariant),
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: _link,
                    keyboardType: TextInputType.url,
                    autocorrect: false,
                    onChanged: (_) => setState(() {
                      _checked = false;
                      _error = null;
                    }),
                    decoration: InputDecoration(
                      labelText: 'Solution URL',
                      hintText: 'https://your-project.example',
                      errorText: _error,
                      errorMaxLines: 5,
                      suffixIcon: _valid
                          ? Icon(
                              Icons.check_circle_outline,
                              color: FccDesignColors.of(context).success,
                            )
                          : null,
                    ),
                  ),
                  if (_valid)
                    Padding(
                      padding: const EdgeInsets.only(top: 12),
                      child: Text(
                        'Your link is ready to submit.',
                        style: TextStyle(
                          color: FccDesignColors.of(context).success,
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: ChallengeFooter(
        child: _valid
            ? CompleteButton(
                challenge: challenge,
                block: widget.block,
                label: 'Submit project',
                solution: _link.text.trim(),
              )
            : ChallengeButton(
                label: 'Check link',
                onPressed: _link.text.trim().isEmpty
                    ? null
                    : () => setState(() {
                        _checked = true;
                        _error = _linkError(_link.text.trim());
                      }),
              ),
      ),
    );
  }
}
