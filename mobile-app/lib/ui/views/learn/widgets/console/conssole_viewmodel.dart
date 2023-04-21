import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:freecodecamp/ui/views/learn/widgets/console/console_model.dart';
import 'package:stacked/stacked.dart';

class JavaScriptConsole extends StatelessWidget {
  const JavaScriptConsole({Key? key, required this.messages}) : super(key: key);

  final List<ConsoleMessage> messages;

  static String defaultMessage = '''
  /**
  * Your test output will go here
  */
  ''';

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<JavaScriptConsoleViewModel>.reactive(
      viewModelBuilder: () => JavaScriptConsoleViewModel(),
      builder: (context, model, child) {
        return Column(
          children: [
            Container(
              color: Colors.blue,
              margin: const EdgeInsets.all(8),
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: messages.isEmpty ? 1 : messages.length,
                itemBuilder: (context, index) {
                  return consoleMessage(index, model);
                },
              ),
            ),
          ],
        );
      },
    );
  }

  ListTile consoleMessage(int index, JavaScriptConsoleViewModel model) {
    return ListTile(
      title: Text(
        messages.isEmpty ? defaultMessage : messages[index].message,
        style: TextStyle(
          color: model.getConsoleTextColor(
            messages.isEmpty
                ? ConsoleMessageLevel.LOG
                : messages[index].messageLevel,
          ),
          fontSize: 18,
        ),
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 8),
    );
  }
}
