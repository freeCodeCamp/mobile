import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:freecodecamp/ui/views/learn/widgets/console/console_viewmodel.dart';
import 'package:freecodecamp/ui/views/news/html_handler/html_handler.dart';
import 'package:stacked/stacked.dart';

class JavaScriptConsole extends StatelessWidget {
  const JavaScriptConsole({super.key, required this.messages});

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
        HTMLParser parser = HTMLParser(
          context: context,
        );

        return Expanded(
          child: Row(
            children: [
              Expanded(
                child: Scrollbar(
                  child: ListView.builder(
                    padding: const EdgeInsets.all(8),
                    physics: const ClampingScrollPhysics(),
                    itemCount: messages.isEmpty ? 1 : messages.length,
                    itemBuilder: (context, index) {
                      List<Widget> htmlWidgets = parser.parse(
                        messages.isEmpty
                            ? defaultMessage
                            : messages[index].message,
                      );

                      return consoleMessage(htmlWidgets, model, context);
                    },
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget consoleMessage(
    List<Widget> htmlWidgets,
    JavaScriptConsoleViewModel model,
    BuildContext context,
  ) {
    return messages.isEmpty
        ? Text(
            defaultMessage,
            style: TextStyle(
              color: model.getConsoleTextColor(
                ConsoleMessageLevel.LOG,
              ),
            ),
          )
        : Row(
            children: [
              for (int i = 0; i < htmlWidgets.length; i++)
                Expanded(
                  child: htmlWidgets[i],
                )
            ],
          );
  }
}
