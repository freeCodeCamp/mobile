import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:freecodecamp/fcc_theme.dart';
import 'package:freecodecamp/learn/models/challenge_model.dart';
import 'package:freecodecamp/learn/ui/challenge/widgets/parsed_html.dart';
import 'package:html/parser.dart' as html_parser;

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
  const ConsoleOutput({
    super.key,
    required this.testConsole,
    required this.userConsole,
  });

  final List<String> testConsole;
  final List<String> userConsole;

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: Theme.of(context).colorScheme.surface,
      child: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          if (testConsole.isEmpty)
            _message(context, '<p>// Your test output will go here</p>')
          else
            for (final message in testConsole)
              _message(context, message, testOutput: true),
          if (userConsole.isNotEmpty)
            _message(context, '<p>// console output</p>'),
          for (final message in userConsole) _message(context, message),
        ],
      ),
    );
  }

  Widget _message(
    BuildContext context,
    String html, {
    bool testOutput = false,
  }) {
    final colors = Theme.of(context).colorScheme;
    final text = (html_parser.parseFragment(html).text ?? '').trim();
    final comment = text.startsWith('//');
    final error =
        !comment &&
        (testOutput ||
            RegExp(r'^(?:Uncaught\s+)?(?:\w*Error):').hasMatch(text));
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: ParsedHtml(
        html,
        customStyles: {
          '*': Style(
            fontFamily: 'monospace',
            fontSize: FontSize(13),
            lineHeight: const LineHeight(1.5),
            color: error
                ? colors.error
                : comment
                ? colors.onSurfaceVariant
                : colors.onSurface,
          ),
          'p': Style(margin: Margins.zero),
          'code': Style(fontFamily: 'monospace', fontSize: FontSize(13)),
          'ol': Style(
            margin: Margins.zero,
            padding: HtmlPaddings.only(inlineStart: 20),
          ),
        },
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
  late final Future<String> _html = widget.load();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _html,
      builder: (context, snapshot) => switch (snapshot) {
        AsyncSnapshot(:final data?) => InAppWebView(
          initialData: InAppWebViewInitialData(data: data),
          initialSettings: InAppWebViewSettings(isInspectable: kDebugMode),
        ),
        AsyncSnapshot(hasError: true) => const Center(
          child: Text('The preview could not be built.'),
        ),
        _ => const Center(child: CircularProgressIndicator()),
      },
    );
  }
}
