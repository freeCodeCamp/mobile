import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:freecodecamp/ui/views/learn/widgets/console/console_model.dart';
import 'package:stacked/stacked.dart';

class JavaScriptConsole extends StatelessWidget {
  const JavaScriptConsole({Key? key, required this.messages}) : super(key: key);

  final List<ConsoleMessage> messages;

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<JavaScriptConsoleViewModel>.reactive(
      viewModelBuilder: () => JavaScriptConsoleViewModel(),
      builder: (context, model, child) {
        return ListView.builder(
          itemCount: messages.length,
          itemBuilder: (context, index) {
            return ListTile(
              subtitle: Text(messages[index].message),
            );
          },
        );
      },
    );
  }
}
