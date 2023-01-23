import 'package:flutter/material.dart';
import 'package:freecodecamp/models/learn/curriculum_model.dart';
import 'package:freecodecamp/ui/views/learn/block/block_model.dart';

class OpenCloseIcon extends StatelessWidget {
  const OpenCloseIcon({
    Key? key,
    required this.block,
    required this.model,
  }) : super(key: key);

  final Block block;
  final BlockViewModel model;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        IconButton(
          iconSize: 35,
          icon: model.isOpen
              ? const Icon(Icons.expand_less)
              : const Icon(Icons.expand_more),
          onPressed: () async {
            model.setBlockOpenState(
              block.name,
              model.isOpen,
            );
          },
        ),
      ],
    );
  }
}
