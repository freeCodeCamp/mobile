import 'package:flutter/material.dart';

import 'package:freecodecamp/ui/views/news/html_handler/html_handler.dart';

class AssignmentTile extends StatelessWidget {
  const AssignmentTile({
    super.key,
    required this.index,
    required this.assignment,
    required this.callback,
    required this.selected,
  });

  final int index;
  final String assignment;
  final Function callback;
  final bool selected;

  @override
  Widget build(BuildContext context) {
    HTMLParser parser = HTMLParser(context: context);

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: Material(
        child: ListTile(
          tileColor: const Color(0xFF0a0a23),
          onTap: () {
            callback();
          },
          leading: Checkbox(
            focusNode: FocusNode(),
            onChanged: (value) {
              callback();
            },
            value: selected,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(0),
            side: BorderSide(
              color: const Color(0xFFAAAAAA),
              width: 2,
            ),
          ),
          title: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: parser.parse(
                    assignment,
                    isSelectable: false,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
