import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:freecodecamp/ui/views/learn/widgets/console/console_viewmodel.dart';
import 'package:freecodecamp/ui/views/news/html_handler/html_handler.dart';
import 'package:stacked/stacked.dart';

class JavaScriptConsole extends StatelessWidget {
  const JavaScriptConsole({super.key, required this.messages});

  final List<String> messages;

  static final String defaultMessage = '''
  <p>/**<br/>
  * Your test output will go here<br/>
  */</p>
  ''';

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<JavaScriptConsoleViewModel>.reactive(
      viewModelBuilder: () => JavaScriptConsoleViewModel(),
      builder: (context, model, child) {
        HTMLParser parser = HTMLParser(
          context: context,
        );

        final scrollController = ScrollController();

        return Expanded(
          child: Row(
            children: [
              Expanded(
                child: Scrollbar(
                  controller: scrollController,
                  child: ListView.builder(
                    padding: const EdgeInsets.all(8),
                    physics: const ClampingScrollPhysics(),
                    controller: scrollController,
                    primary: false,
                    itemCount: messages.isEmpty ? 1 : messages.length,
                    itemBuilder: (context, index) {
                      List<Widget> htmlWidgets = parser.parse(
                        messages.isEmpty ? '' : messages[index],
                        customStyles: {
                          'body': Style(
                            margin: Margins.symmetric(
                              vertical: 0,
                              horizontal: 8,
                            ),
                          ),
                          'p': Style(margin: Margins.zero),
                          'ol': Style(
                            padding: HtmlPaddings.only(inlineStart: 20),
                          ),
                        },
                      );

                      return Row(
                        children: [
                          for (int i = 0; i < htmlWidgets.length; i++)
                            Expanded(
                              child: htmlWidgets[i],
                            )
                        ],
                      );
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
}
