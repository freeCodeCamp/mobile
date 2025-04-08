import 'package:flutter/material.dart';
import 'package:freecodecamp/models/learn/curriculum_model.dart';
import 'package:freecodecamp/ui/views/learn/block/block_template_viewmodel.dart';
import 'package:freecodecamp/ui/views/learn/block/templates/link/link_viewmodel.dart';
import 'package:stacked/stacked.dart';

class BlockLinkView extends StatelessWidget {
  const BlockLinkView({
    Key? key,
    required this.block,
    required this.model,
  }) : super(key: key);

  final Block block;
  final BlockTemplateViewModel model;

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder.reactive(
      viewModelBuilder: () => BlockLinkViewModel(),
      builder: (context, childModel, child) {
        return Expanded(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                Text(block.description.join(' ')),
                Row(
                  children: [
                    Expanded(
                      child: TextButton(
                        onPressed: () {
                          model.routeToCertification(block);
                        },
                        style: TextButton.styleFrom(
                          backgroundColor:
                              const Color.fromRGBO(0x99, 0xc9, 0xff, 1),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5),
                          ),
                        ),
                        child: const Text(
                          'Start',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
