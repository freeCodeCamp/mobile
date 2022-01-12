import 'dart:math';

import 'package:flutter/material.dart';

class TagButton extends StatefulWidget {
  const TagButton({Key? key, required this.tagName}) : super(key: key);

  final String tagName;

  Color randomColor() {
    var randomNum = Random();

    List colors = [
      const Color.fromRGBO(0xdb, 0xb8, 0xff, 1),
      const Color.fromRGBO(0xf1, 0xbe, 0x32, 1),
      const Color.fromRGBO(0x99, 0xc9, 0xff, 1),
      const Color.fromRGBO(0xac, 0xd1, 0x57, 1)
    ];

    return colors[randomNum.nextInt(4)];
  }

  @override
  State<TagButton> createState() => _TagButtonState();
}

class _TagButtonState extends State<TagButton> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8),
      child: Container(
        color: widget.randomColor(),
        child: Padding(
          padding: const EdgeInsets.all(3.0),
          child: Text(
            '#' + widget.tagName,
            style: const TextStyle(
              fontSize: 18,
            ),
          ),
        ),
      ),
    );
  }
}
