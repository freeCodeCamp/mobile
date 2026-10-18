import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:mobile_app_new/fcc_theme.dart';
import 'package:mobile_app_new/learn/models/challenge_model.dart';
import 'package:mobile_app_new/learn/ui/challenge/widgets/parsed_html.dart';

class TestList extends StatelessWidget {
  const TestList({super.key, required this.tests, required this.results});

  final List<ChallengeTest> tests;
  final List<bool>? results;

  static final _styles = {
    '*:not(h1):not(h2):not(h3):not(h4):not(h5):not(h6)': Style(
      color: FccColors.gray00,
    ),
    'p': Style(margin: Margins.zero),
  };

  @override
  Widget build(BuildContext context) {
    final results = this.results;

    return ListView.separated(
      itemCount: tests.length,
      separatorBuilder: (_, _) => const Divider(color: Colors.white, height: 1),
      itemBuilder: (context, i) => Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            Expanded(child: ParsedHtml(tests[i].text, customStyles: _styles)),
            if (results != null && i < results.length) ...[
              const SizedBox(width: 8),
              Icon(
                results[i] ? Icons.check_circle_rounded : Icons.cancel_rounded,
              ),
            ],
          ],
        ),
      ),
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

  static final _styles = {
    'body': Style(margin: Margins.symmetric(vertical: 0, horizontal: 8)),
    'p': Style(margin: Margins.zero),
    'ol': Style(padding: HtmlPaddings.only(inlineStart: 20)),
  };

  @override
  Widget build(BuildContext context) {
    final messages = [
      if (testConsole.isEmpty)
        '<p>/**<br/>* Your test output will go here<br/>*/</p>'
      else
        ...testConsole,
      if (userConsole.isNotEmpty) '<p>// console output</p>',
      ...userConsole,
    ];

    return ListView(
      padding: const EdgeInsets.all(8),
      children: [
        for (final message in messages)
          ParsedHtml(message, customStyles: _styles),
      ],
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
