import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:freecodecamp/models/learn/challenge_model.dart';
import 'package:freecodecamp/ui/views/learn/challenge_editor/test_runner/test_model.dart';
import 'package:stacked/stacked.dart';
import 'package:webview_flutter/webview_flutter.dart';

class TestViewModel extends StatelessWidget {
  const TestViewModel({Key? key, required this.tests}) : super(key: key);

  final List<ChallengeTest> tests;

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<TestModel>.reactive(
        viewModelBuilder: () => TestModel(),
        builder: (context, model, child) => Column(
              children: [
                Stack(
                  children: [
                    Row(
                      children: [
                        Expanded(
                            child: Container(
                          decoration: BoxDecoration(
                              border:
                                  Border.all(width: 2, color: Colors.white)),
                          child: TextButton(
                              style: TextButton.styleFrom(
                                  padding: EdgeInsets.zero),
                              onPressed: () {},
                              child: Text('Run tests')),
                        ))
                      ],
                    ),
                    WebView(
                      javascriptMode: JavascriptMode.unrestricted,
                      onPageFinished: (str) {},
                    )
                  ],
                ),
                for (int i = 0; i < tests.length; i++) testTile(i, tests[i])
              ],
            ));
  }

  Widget testTile(int i, ChallengeTest test) {
    return Row(
      children: [
        Expanded(
          child: ListTile(
            title: Html(
              data: test.instruction,
              style: {'body': Style(fontSize: FontSize.large)},
            ),
            leading: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(50),
                    color: const Color.fromRGBO(0x42, 0x42, 0x55, 1),
                  ),
                  padding: const EdgeInsets.all(16),
                  child: const Icon(
                    Icons.science_outlined,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
            minVerticalPadding: 16,
            tileColor: i % 2 == 0
                ? const Color(0xFF0a0a23)
                : const Color.fromRGBO(0x2A, 0x2A, 0x40, 1),
          ),
        ),
      ],
    );
  }
}
