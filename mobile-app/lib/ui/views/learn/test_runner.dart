import 'dart:developer';

import 'package:flutter/widgets.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:freecodecamp/app/app.locator.dart';
import 'package:freecodecamp/enums/ext_type.dart';
import 'package:freecodecamp/models/learn/challenge_model.dart';
import 'package:freecodecamp/service/learn/learn_file_service.dart';
import 'package:html/dom.dart';
import 'package:html/parser.dart';

enum WorkerType { python, frame, worker }

class Code {
  const Code({required this.contents, this.editableContents});

  final String contents;
  final String? editableContents;
}

// Compiles the document into a valid HTML and JS/CSS structure

class FrameCompiler {
  FrameCompiler({
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

  InAppWebViewController buildFrame(InAppWebViewController controller) {
    Document document = Document();
    document = parse('');

    String tail = challenge.files[0].tail!;

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

    // const worker = new Worker('http://localhost:8080/debug.js');
    // worker.onmessage = function(e) {
    //   console.log('Message received from worker: ', e.data);
    // };
    // worker.postMessage('Hello from main thread');
    console.log('this sucks');

    const code = `${htmlFlow(challenge, Ext.html)}`;
    const doc = new DOMParser().parseFromString(code, 'text/html');

    ${tail.isNotEmpty ? """
    const parseTail  = new DOMParser().parseFromString(`${tail.replaceAll('/', '\\/')}`,'text/html');
    const tail = parseTail.getElementsByTagName('SCRIPT')[0].innerHTML;
    """ : ''}

    const assert = chai.assert;
    const __checkForBrowserExtensions = false;
    const tests = ${parseTest(challenge.tests)};
    const testText = ${challenge.tests.map((e) => '''"${e.instruction.replaceAll('"', '\\"').replaceAll('\n', ' ')}"''').toList().toString()};

    const editableContents = `${builder.code.editableContents}`;

    doc.__runTest = async function runtTests(testString) {
      let error = false;
      console.log(window.FCCSandbox);
      const runner = await window.FCCSandbox.createTestRunner({
						source: "var x = 5;",
						type: "worker",
						code: {
							contents: "",
						},
            assetPath: "/",
					})
    const result = await runner.runTest("assert.equal(x, 4);")
    console.log(JSON.stringify(result));
    console.log('testing', testString);

      for(let i = 0; i < testString.length; i++){
        try {
            const testPromise = new Promise((resolve, reject) => {
              try {
                const test = eval(${tail.isNotEmpty ? 'tail + "\\n" +' : ""} testString[i]);
                resolve(test);
              } catch (e) {
                reject(e);
              }
            });
            await testPromise;
        } catch (e) {
            error = true;
            console.log('testMSG: ' + testText[i]);
            break;
        }
      }
      if(!error){
        console.log('completed');
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

    log(document.outerHtml);

    return controller;
  }

  InAppWebViewController paintedFrame() {
    return buildFrame(controller);
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
  }) : super(key: key);

  final TestRunnerBuilder builder;
  final Challenge challenge;

  @override
  State<TestRunner> createState() => _TestRunnerState();
}

class _TestRunnerState extends State<TestRunner> {
  InAppWebViewController? webViewController;

  @override
  Widget build(BuildContext context) {
    return InAppWebView(
      onWebViewCreated: (controller) {
        FrameCompiler frame = FrameCompiler(
          challenge: widget.challenge,
          controller: controller,
          builder: widget.builder,
        );

        webViewController = frame.paintedFrame();
      },
      onConsoleMessage: (controller, console) {
        //TODO : implement console log stream

        log('LOGGER:${console.message}');
      },
    );
  }
}
