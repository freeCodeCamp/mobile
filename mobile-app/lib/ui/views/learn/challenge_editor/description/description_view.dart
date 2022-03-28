import 'package:flutter/material.dart';
import 'package:freecodecamp/ui/views/learn/challenge_editor/description/description_model.dart';
import 'package:freecodecamp/ui/views/news/html_handler/html_handler.dart';
import 'package:stacked/stacked.dart';

class DescriptionView extends StatelessWidget {
  const DescriptionView(
      {Key? key, required this.description, required this.instructions})
      : super(key: key);

  final String description;
  final String instructions;

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<DescriptionModel>.reactive(
        viewModelBuilder: () => DescriptionModel(),
        builder: (context, model, child) => Scaffold(
              body: SingleChildScrollView(
                child: Column(
                  children: [
                    Row(children: [
                      Expanded(
                          child: Column(
                        children:
                            HtmlHandler.smallHtmlHandler(description, context),
                      ))
                    ]),
                    Row(children: [
                      Expanded(
                          child: Column(
                        children:
                            HtmlHandler.smallHtmlHandler(instructions, context),
                      ))
                    ]),
                  ],
                ),
              ),
            ));
  }
}
