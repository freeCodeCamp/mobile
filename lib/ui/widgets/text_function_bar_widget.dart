// ignore_for_file: prefer_const_constructors_in_immutables

import 'package:flutter/material.dart';
import 'package:freecodecamp/models/forum_post_model.dart';
import 'dart:developer' as dev;

class ForumTextFunctionBar extends StatelessWidget {
  ForumTextFunctionBar({Key? key, required this.textController})
      : super(key: key);

  late final TextEditingController textController;
  late final PostModel post;

  void quoteText(String selectedText) {
    TextSelection textSelection = textController.selection;

    dev.log(selectedText.length.toString());

    if (selectedText.length < 2) {
      String newText = textController.text.replaceRange(
          textSelection.start, textSelection.end, ' > Blockquote ');
      textController.text = newText;
    } else {
      textController.text =
          textController.text.replaceFirst(selectedText, "> $selectedText");
    }
  }

  void boldText(String selectedText) {
    TextSelection textSelection = textController.selection;

    dev.log(selectedText.length.toString());

    if (selectedText.length < 2) {
      String newText = textController.text.replaceRange(
          textSelection.start, textSelection.end, '**strong text**');
      textController.text = newText;
    } else {
      textController.text =
          textController.text.replaceFirst(selectedText, "**$selectedText**");
    }
  }

  void codeText(String selectedText) {
    TextSelection textSelection = textController.selection;

    dev.log(selectedText.length.toString());

    if (selectedText.length < 2) {
      String newText = textController.text.replaceRange(textSelection.start,
          textSelection.end, '\n```\npaste your code here\n```\n');
      textController.text = newText;
    } else {
      textController.text = textController.text
          .replaceFirst(selectedText, "\n```\n$selectedText\n```\n");
    }
  }

  void linkText(String selectedText) {
    TextSelection textSelection = textController.selection;
    String newText = textController.text
        .replaceRange(textSelection.start, textSelection.end, '[txt](link)');
    textController.text = newText;
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Padding(
            padding: const EdgeInsets.only(left: 16, right: 16),
            child: Container(
              width: MediaQuery.of(context).size.width,
              height: 50,
              color: const Color(0xFF0a0a23),
              child: Row(
                children: [
                  Column(
                    children: [
                      IconButton(
                        onPressed: () {
                          quoteText(textController.selection
                              .textInside(textController.text));
                        },
                        tooltip: 'blockquote',
                        icon: const Icon(Icons.format_quote_sharp),
                        color: Colors.white,
                      )
                    ],
                  ),
                  Column(
                    children: [
                      IconButton(
                        onPressed: () {
                          boldText(textController.selection
                              .textInside(textController.text));
                        },
                        tooltip: 'bold text',
                        icon: const Icon(Icons.format_bold_sharp),
                        color: Colors.white,
                      )
                    ],
                  ),
                  Column(
                    children: [
                      IconButton(
                        onPressed: () {
                          codeText(textController.selection
                              .textInside(textController.text));
                        },
                        tooltip: 'format code',
                        icon: const Icon(Icons.code),
                        color: Colors.white,
                      )
                    ],
                  ),
                  Column(
                    children: [
                      IconButton(
                        onPressed: () {
                          linkText(textController.selection
                              .textInside(textController.text));
                        },
                        tooltip: 'place link',
                        icon: const Icon(Icons.insert_link),
                        color: Colors.white,
                      )
                    ],
                  )
                ],
              ),
            ),
          ),
        )
      ],
    );
  }
}
