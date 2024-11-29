import 'package:flutter/material.dart';
import 'package:freecodecamp/models/learn/curriculum_model.dart';
import 'package:freecodecamp/ui/views/learn/block/block_viewmodel.dart';

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
    return GestureDetector(
      child: model.isOpen
          ? const Icon(
              Icons.expand_less,
              size: 30,
            )
          : const Icon(
              Icons.expand_more,
              size: 30,
            ),
      onTap: () async {
        model.setBlockOpenState(
          block.name,
          model.isOpen,
        );
      },
    );
  }
}
