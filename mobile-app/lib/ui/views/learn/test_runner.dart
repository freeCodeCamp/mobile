import 'dart:async';
import 'dart:developer';

import 'package:flutter/widgets.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:freecodecamp/app/app.locator.dart';
import 'package:freecodecamp/enums/ext_type.dart';
import 'package:freecodecamp/models/learn/challenge_model.dart';
import 'package:freecodecamp/service/learn/learn_file_service.dart';
import 'package:freecodecamp/ui/views/learn/challenge/challenge_viewmodel.dart';
import 'package:html/dom.dart';
import 'package:html/parser.dart';

enum WorkerType { python, frame, worker }

class Code {
  const Code({required this.contents, this.editableContents});

  final String contents;
  final String? editableContents;
}

// Compiles the document into a valid HTML and JS/CSS structure

class FrameBuilder {
  FrameBuilder({
    required this.controller,
    required this.builder,
    required this.challenge,
  });
  final InAppWebViewController controller;

  final TestRunnerBuilder builder;
  final LearnFileService fileService = locator<LearnFileService>();
  final Challenge challenge;

  // The parse test function will parse RegEx's and Comments and more for the eval function.
  // Cause the code is going through runtime twice, the already escaped '\\' need to be escaped
  // again.

  List<String> parseTest(List<ChallengeTest> test) {
    List<String> parsedTest = test
        .map((e) =>
            """`${e.javaScript.replaceAll('\\', '\\\\').replaceAll('`', '\\`').replaceAll('\$', r'\$')}`""")
        .toList();

    return parsedTest;
  }

  // This function is used in the returnScript function to correctly parse
  // HTML challenge (user code) it will firstly get the file from the cache, (it returns the first challenge file if in testing mode)
  // Otherwise it will return the first instance of that challenge in the cache. Next will be adding the style tags (only if
  // linked)

  Future<String> htmlFlow(
    Challenge challenge,
    Ext ext, {
    bool testing = false,
  }) async {
    String firstHTMlfile = await fileService.getFirstFileFromCache(
      challenge,
      ext,
      testing: testing,
    );

    firstHTMlfile = fileService.removeExcessiveScriptsInHTMLdocument(
      firstHTMlfile,
    );

    String parsedWithStyleTags = await fileService.parseCssDocmentsAsStyleTags(
      challenge,
      firstHTMlfile,
      testing: testing,
    );

    if (challenge.id != '646c48df8674cf2b91020ecc') {
      firstHTMlfile = fileService.changeActiveFileLinks(
        parsedWithStyleTags,
      );
    }

    return firstHTMlfile;
  }

  String getTestRunnerType(WorkerType type) {
    switch (type) {
      case WorkerType.python:
        return 'python';
      case WorkerType.frame:
        return 'frame';
      case WorkerType.worker:
        return 'worker';
    }
  }

  Future<InAppWebViewController> buildFrame() async {
    Document document = Document();
    document = parse('');

    String tail = challenge.files[0].tail!;
    String firstHtmlFile = await htmlFlow(challenge, Ext.html);

    List<String> imports = [
      '<script src="http://localhost:8080/index.mjs">console.log("hello")</script>',
      '<script src="https://unpkg.com/chai@4.3.10/chai.js"></script>',
      '<script src="https://unpkg.com/mocha@10.3.0/mocha.js"></script>',
      '<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.6.0/jquery.min.js"></script>',
      '<link rel="stylesheet" href="https://unpkg.com/mocha/mocha.css" />'
    ];

    for (String import in imports) {
      Document importToNode = parse(import);

      Node node = importToNode.getElementsByTagName('HEAD')[0].children.first;

      document.getElementsByTagName('HEAD')[0].append(node);
    }

    String script = '''
    <script type="module">
    const code = `${builder.code.contents.replaceAll('\\', '\\\\').replaceAll('`', '\\`').replaceAll('\$', r'\$')}`;
    const doc = new DOMParser().parseFromString(code, 'text/html');

    ${tail.isNotEmpty ? """
    const parseTail  = new DOMParser().parseFromString(`${tail.replaceAll('/', '\\/')}`,'text/html');
    const tail = parseTail.getElementsByTagName('SCRIPT')[0].innerHTML;
    """ : ''}

    const assert = chai.assert;
    const __checkForBrowserExtensions = false;
    const tests = ${parseTest(challenge.tests)};
    const testText = ${challenge.tests.map((e) => '''"${e.instruction.replaceAll('"', '\\"').replaceAll('\n', ' ')}"''').toList().toString()};

    doc.__runTest = async function runtTests(testString) {
      let error = false;
      const runner = await window.FCCSandbox.createTestRunner({
						source: `$firstHtmlFile`,
						type: "${getTestRunnerType(builder.workerType)}",
						code: {
							contents: `$firstHtmlFile`,
						},
            assetPath: "${builder.assetPath}",
					})

      const results = [];
      for(let i = 0; i < tests.length; i++){
        const result =  await runner.runTest(tests[i]);
        results.push(result);
      }

      for(let i = 0; i < results.length; i++){
        if(Object.keys(results[i]).includes('err')){
          console.log(`testMSG: \${testText[i]}`);
          break;
        }

        if(i === results.length -1){
          console.log('completed');
        }
      }

    };

    document.querySelector('*').innerHTML = code;
    doc.__runTest(tests);
  </script>''';

    Document scriptToNode = parse(script);

    Node bodyNode =
        scriptToNode.getElementsByTagName('BODY').first.children.isNotEmpty
            ? scriptToNode.getElementsByTagName('BODY').first.children.first
            : scriptToNode.getElementsByTagName('HEAD').first.children.first;

    document.body!.append(bodyNode);

    // TODO: find everything I f'ed up, also add back testing the test runner

    controller.loadData(
      data: document.outerHtml,
      mimeType: 'text/html',
      encoding: 'utf-8',
      baseUrl: WebUri('http://localhost:8080'),
    );

    return controller;
  }
}

class TestRunnerBuilder {
  const TestRunnerBuilder({
    required this.source,
    required this.code,
    required this.workerType,
    this.assetPath = '/',
    this.testing = false,
  });
  final String source;
  final Code code;
  final String? assetPath;
  final WorkerType workerType;
  final bool testing;
}

class TestRunner extends StatefulWidget {
  const TestRunner({
    Key? key,
    required this.builder,
    required this.challenge,
    required this.model,
  }) : super(key: key);

  final TestRunnerBuilder builder;
  final Challenge challenge;
  final ChallengeViewModel model;

  @override
  State<TestRunner> createState() => _TestRunnerState();
}

class _TestRunnerState extends State<TestRunner> {
  InAppWebViewController? webViewController;

  @override
  Widget build(BuildContext context) {
    if (webViewController != null) {
      Future.delayed(const Duration(seconds: 0), () async {
        FrameBuilder frame = FrameBuilder(
          challenge: widget.challenge,
          controller: webViewController!,
          builder: widget.builder,
        );

        webViewController = await frame.buildFrame();
      });
    }

    return InAppWebView(
      onWebViewCreated: (controller) async {
        if (webViewController == null) {
          FrameBuilder frame = FrameBuilder(
            challenge: widget.challenge,
            controller: controller,
            builder: widget.builder,
          );

          webViewController = await frame.buildFrame();
        }
      },

      onConsoleMessage: (controller, console) {
        widget.model.handleConsoleLogMessagges(console, widget.challenge);
        log(console.message);
      },
      // onLoadStop: (controller, url) async {
      //   var html = await controller.evaluateJavascript(source: """
      //   document.documentElement.innerHTML;
      // """);

      //   log("FULL DOCUMENT HTML: $html");
      // },
    );
  }
}
