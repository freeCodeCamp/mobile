import 'package:flutter/material.dart';
import 'package:freecodecamp/models/learn/curriculum_model.dart';
import 'package:freecodecamp/ui/views/learn/block/block_template_viewmodel.dart';

import 'package:stacked/stacked.dart';

class BlockTemplateView extends StatelessWidget {
  final Block block;
  final bool isOpen;
  final Function isOpenFunction;

  const BlockTemplateView({
    super.key,
    required this.block,
    required this.isOpen,
    required this.isOpenFunction,
  });

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<BlockTemplateViewModel>.reactive(
      onViewModelReady: (model) async {
        model.init(block.challengeTiles);
        model.setIsDev = await model.developerService.developmentMode();
      },
      viewModelBuilder: () => BlockTemplateViewModel(),
      builder: (
        context,
        model,
        child,
      ) {
        final (icon, color) = model.getIconData(block.label);

        return Padding(
          padding: const EdgeInsets.only(bottom: 16.0),
          child: StreamBuilder<Object>(
              stream: model.auth.progress.stream,
              builder: (context, snapshot) {
                return Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                      color: const Color.fromRGBO(0x3b, 0x3b, 0x4f, 1),
                    ),
                    color: const Color.fromRGBO(0x1b, 0x1b, 0x32, 1),
                  ),
                  padding: const EdgeInsets.all(8),
                  width: MediaQuery.of(context).size.width,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                if (icon != null)
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Icon(icon, color: color, size: 30),
                                  ),
                                Expanded(
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text(
                                      block.name,
                                      style: TextStyle(
                                        wordSpacing: 0,
                                        letterSpacing: 0,
                                        fontSize: 22,
                                        fontWeight: FontWeight.bold,
                                        color: color,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            Row(
                              children: [
                                model.getLayout(
                                  block.layout,
                                  model,
                                  block,
                                  isOpen,
                                  isOpenFunction,
                                  color,
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              }),
        );
      },
    );
  }
}
