import 'package:flutter/material.dart';
import 'package:mobile_app_new/fcc_theme.dart';
import 'package:mobile_app_new/learn/models/challenge_model.dart';
import 'package:mobile_app_new/learn/models/curriculum_model.dart';
import 'package:mobile_app_new/learn/ui/challenge/widgets/challenge_button.dart';
import 'package:mobile_app_new/learn/ui/challenge/widgets/complete_button.dart';
import 'package:mobile_app_new/learn/ui/challenge/widgets/help_dialog.dart';
import 'package:mobile_app_new/learn/ui/challenge/widgets/parsed_html.dart';

final _fccRegex = RegExp(
  r'codepen\.io\/freecodecamp|freecodecamp\.rocks|github\.com\/freecodecamp|\.freecodecamp\.org',
  caseSensitive: false,
);
final _localhostRegex = RegExp(r'localhost:');
final _httpRegex = RegExp(r'http(?!s|([^s]+?localhost))');

String? _linkError(String link) {
  if (!(Uri.tryParse(link)?.isAbsolute ?? false)) {
    return 'Please enter a valid link.';
  }
  if (_fccRegex.hasMatch(link)) return 'Remember to submit your own work.';
  if (_httpRegex.hasMatch(link)) {
    return 'An unsecure (http) URL cannot be used.';
  }
  if (_localhostRegex.hasMatch(link)) {
    return 'Remember to submit a publicly visible app URL.';
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
    final border = BorderSide(
      color: _valid ? Colors.green : FccColors.gray00,
      width: 2,
    );

    return Scaffold(
      appBar: AppBar(title: Text(challenge.title)),
      body: SafeArea(
        bottom: false,
        child: ListView(
          padding: const EdgeInsets.fromLTRB(12, 12, 12, 48),
          children: [
            ParsedHtml(challenge.description),
            const Divider(color: FccColors.gray00),
            ParsedHtml(challenge.instructions),
            const Divider(color: FccColors.gray00),
            const Padding(
              padding: EdgeInsets.fromLTRB(12, 8, 12, 8),
              child: Text(
                'Solution Link',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: TextField(
                controller: _link,
                keyboardType: TextInputType.url,
                autocorrect: false,
                onChanged: (_) => setState(() {
                  _checked = false;
                  _error = null;
                }),
                decoration: InputDecoration(
                  hintText: 'ex: https://replit.com/@camperbot/hello',
                  errorText: _error,
                  errorMaxLines: 5,
                  enabledBorder: OutlineInputBorder(
                    borderSide: border.copyWith(width: 1),
                  ),
                  focusedBorder: OutlineInputBorder(borderSide: border),
                ),
              ),
            ),
            const SizedBox(height: 8),
            if (_valid)
              CompleteButton(
                challenge: challenge,
                block: widget.block,
                label: 'Submit',
                solution: _link.text,
              )
            else
              ChallengeButton(
                label: 'Check Link',
                onPressed: _link.text.isEmpty
                    ? null
                    : () => setState(() {
                        _checked = true;
                        _error = _linkError(_link.text);
                      }),
              ),
            ChallengeButton(
              label: 'Ask for Help',
              onPressed: () => showHelpDialog(context, challenge, widget.block),
            ),
          ],
        ),
      ),
    );
  }
}
