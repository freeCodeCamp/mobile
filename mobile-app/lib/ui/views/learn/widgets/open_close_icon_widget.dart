import 'package:flutter/material.dart';
import 'package:freecodecamp/models/learn/curriculum_model.dart';
import 'package:freecodecamp/ui/views/learn/block/block_viewmodel.dart';

class OpenCloseIcon extends StatelessWidget {
  const OpenCloseIcon({
    super.key,
    required this.block,
    required this.model,
  });

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
