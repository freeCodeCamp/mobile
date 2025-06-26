import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:freecodecamp/ui/views/news/html_handler/html_handler.dart';

class Assignment extends StatelessWidget {
  const Assignment(
      {super.key,
      required this.label,
      required this.value,
      required this.onChanged,
      required this.onTap});

  final String label;
  final bool value;
  final ValueChanged<bool> onChanged;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    HTMLParser parser = HTMLParser(context: context);

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: ListTile(
        selected: value,
        tileColor: const Color(0xFF0a0a23),
        selectedTileColor: const Color(0xDEFFFFFF),
        onTap: () {
          onTap();
        },
        leading: Checkbox(
          focusNode: FocusNode(),
          value: value,
          onChanged: (value) {
            if (value != null) {
              onChanged(!value);
            }
          },
          activeColor: const Color(0xDEFFFFFF),
          checkColor: const Color(0xFF0a0a23),
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(0),
          side: BorderSide(
            color: value ? const Color(0xFF0a0a23) : const Color(0xFFAAAAAA),
            width: 2,
          ),
        ),
        title: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: parser.parse(
                  label,
                  isSelectable: false,
                  customStyles: value
                      ? {
                          '*:not(h1):not(h2):not(h3):not(h4):not(h5):not(h6)':
                              Style(
                            color: const Color(0xDEFFFFFF),
                          ),
                        }
                      : {},
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
