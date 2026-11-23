import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:freecodecamp/fcc_theme.dart';
import 'package:freecodecamp/learn/models/challenge_model.dart';
import 'package:freecodecamp/learn/ui/challenge/widgets/parsed_html.dart';
import 'package:freecodecamp/widgets/error_retry.dart';

class TestList extends StatelessWidget {
  const TestList({super.key, required this.tests, required this.results});

  final List<ChallengeTest> tests;
  final List<bool>? results;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final styles = {
      '*': Style(
        color: colors.onSurface,
        fontSize: FontSize(16),
        lineHeight: const LineHeight(1.4),
      ),
      'p': Style(margin: Margins.zero),
      'code': Style(fontSize: FontSize(16)),
    };
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        for (var i = 0; i < tests.length; i++)
          Padding(
            padding: const EdgeInsets.only(bottom: 16),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _TestStatus(
                  result: results != null && i < results!.length
                      ? results![i]
                      : null,
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: ParsedHtml(tests[i].text, customStyles: styles),
                ),
              ],
            ),
          ),
      ],
    );
  }
}

class _TestStatus extends StatelessWidget {
  const _TestStatus({required this.result});
  final bool? result;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return Icon(
      switch (result) {
        true => Icons.check_circle_rounded,
        false => Icons.cancel_rounded,
        null => Icons.radio_button_unchecked,
      },
      size: 20,
      color: switch (result) {
        true => FccDesignColors.of(context).success,
        false => colors.error,
        null => colors.outline,
      },
      semanticLabel: switch (result) {
        true => 'Passed',
        false => 'Failed',
        null => 'Not run',
      },
    );
  }
}

class ConsoleOutput extends StatelessWidget {
  const ConsoleOutput({super.key, required this.userConsole});

  final List<String> userConsole;

  // NOTE: pythonErrorHint trims tracebacks to start at the user's frame, so those open with 'File "<exec>"'.
  static final _errorPattern = RegExp(
    r'^(?:(?:Uncaught\s+)?\w*Error:|File "<exec>", line \d+|Traceback \(most recent call last\):)',
  );

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return ColoredBox(
      color: colors.surface,
      child: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          for (final message in userConsole)
            Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Text(
                message,
                style: TextStyle(
                  fontFamily: 'monospace',
                  fontSize: 13,
                  height: 1.5,
                  color: _errorPattern.hasMatch(message.trim())
                      ? colors.error
                      : colors.onSurface,
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class ProjectPreview extends StatefulWidget {
  const ProjectPreview({super.key, required this.load});

  final Future<String> Function() load;

  @override
  State<ProjectPreview> createState() => _ProjectPreviewState();
}

class _ProjectPreviewState extends State<ProjectPreview> {
  late Future<String> _html = widget.load();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _html,
      builder: (context, snapshot) => switch (snapshot) {
        AsyncSnapshot(connectionState: ConnectionState.done, :final data?) =>
          InAppWebView(
            initialData: InAppWebViewInitialData(data: data),
            initialSettings: InAppWebViewSettings(isInspectable: kDebugMode),
          ),
        AsyncSnapshot(connectionState: ConnectionState.done, hasError: true) =>
          ErrorRetry(
            message: 'The preview could not be built.',
            onRetry: () {
              final html = widget.load();
              setState(() {
                _html = html;
              });
            },
          ),
        _ => const Center(child: CircularProgressIndicator()),
      },
    );
  }
}
