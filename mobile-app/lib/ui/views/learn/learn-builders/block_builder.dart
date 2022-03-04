import 'package:flutter/material.dart';
import 'package:freecodecamp/models/learn/curriculum_model.dart';
import 'package:freecodecamp/ui/views/learn/learn-builders/challenge_builder.dart';

import 'package:freecodecamp/ui/views/learn/learn_viewmodel.dart';

// ignore: must_be_immutable
class BlockBuilder extends StatefulWidget {
  BlockBuilder(
      {Key? key, required this.model, required this.block, this.isOpen = false})
      : super(key: key);

  final Block block;
  final LearnViewModel model;
  bool isOpen;

  @override
  State<StatefulWidget> createState() => _BlockBuilderState();
}

class _BlockBuilderState extends State<BlockBuilder> {
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.only(top: 16),
          color: const Color(0xFF0a0a23),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(24.0),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    widget.block.blockName,
                    textAlign: TextAlign.left,
                    style: const TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              ListTile(
                leading: Icon(widget.isOpen
                    ? Icons.arrow_drop_down_sharp
                    : Icons.arrow_right_sharp),
                title:
                    Text(widget.isOpen ? 'collapse course' : 'expand course'),
                trailing: Text(
                  '0/${widget.block.challenges.length}',
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                onTap: () {
                  setState(() {
                    widget.isOpen = !widget.isOpen;
                  });
                },
              ),
              Row(
                children: [
                  Expanded(
                    child: widget.isOpen
                        ? ChallengeBuilder(
                            block: widget.block, model: widget.model)
                        : Container(),
                  )
                ],
              )
            ],
          ),
        ),
      ],
    );
  }
}
