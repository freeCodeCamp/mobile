import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:freecodecamp/fcc_theme.dart';
import 'package:freecodecamp/learn/models/challenge_model.dart';
import 'package:freecodecamp/learn/models/curriculum_model.dart';
import 'package:freecodecamp/learn/ui/challenge/python_project_viewmodel.dart';
import 'package:freecodecamp/learn/ui/challenge/widgets/challenge_button.dart';
import 'package:freecodecamp/learn/ui/challenge/widgets/challenge_card.dart';
import 'package:freecodecamp/learn/ui/challenge/widgets/challenge_layout.dart';
import 'package:freecodecamp/learn/ui/challenge/widgets/complete_button.dart';
import 'package:freecodecamp/learn/ui/challenge/widgets/help_dialog.dart';
import 'package:freecodecamp/learn/ui/challenge/widgets/parsed_html.dart';

class PythonProjectView extends ConsumerStatefulWidget {
  const PythonProjectView({
    super.key,
    required this.challenge,
    required this.block,
  });

  final Challenge challenge;
  final Block block;

  @override
  ConsumerState<PythonProjectView> createState() => _PythonProjectViewState();
}

class _PythonProjectViewState extends ConsumerState<PythonProjectView> {
  final _link = TextEditingController();
  PythonProjectNotifierProvider get _provider =>
      pythonProjectProvider(widget.challenge);
  PythonProjectState get _state => ref.read(_provider);
  PythonProjectNotifier get _notifier => ref.read(_provider.notifier);
  bool get _valid => _state.valid;

  @override
  void dispose() {
    _link.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ref.watch(_provider);
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
            onPressed: () =>
                showHelpDialog(context, challenge, widget.block.name),
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
                    onChanged: _notifier.updateLink,
                    decoration: InputDecoration(
                      labelText: 'Solution URL',
                      hintText: 'https://your-project.example',
                      errorText: _state.error,
                      errorMaxLines: 5,
                      suffixIcon: _valid
                          ? Icon(
                              Icons.check_circle_outline,
                              color: FccDesignColors.of(context).success,
                            )
                          : null,
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
                solution: _state.link,
              )
            : ChallengeButton(
                label: 'Check link',
                onPressed: _state.canCheck ? _notifier.checkLink : null,
              ),
      ),
    );
  }
}
