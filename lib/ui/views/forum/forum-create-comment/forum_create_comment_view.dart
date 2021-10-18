import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ForumCreateCommentView extends StatelessWidget {
  const ForumCreateCommentView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            SizedBox(
                height: 200,
                width: MediaQuery.of(context).size.width,
                child: const TextField(
                  minLines: 10,
                  maxLines: null,
                  decoration:
                      InputDecoration(fillColor: Colors.white, filled: true),
                ))
          ],
        ),
        Row(
          children: [],
        )
      ],
    );
  }
}
