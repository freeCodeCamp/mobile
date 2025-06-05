import 'package:flutter/material.dart';
import 'package:freecodecamp/models/learn/curriculum_model.dart';
import 'package:freecodecamp/ui/theme/fcc_theme.dart';
import 'package:freecodecamp/ui/views/learn/block/block_template_viewmodel.dart';
import 'package:freecodecamp/ui/views/learn/block/templates/link/link_viewmodel.dart';
import 'package:freecodecamp/ui/views/news/html_handler/html_handler.dart';
import 'package:stacked/stacked.dart';

class BlockLinkView extends StatelessWidget {
  const BlockLinkView({
    super.key,
    required this.block,
    required this.model,
    required this.color,
  });

  final Block block;
  final BlockTemplateViewModel model;
  final Color color;

  @override
  Widget build(BuildContext context) {
    HTMLParser parser = HTMLParser(context: context);

    return ViewModelBuilder.reactive(
      viewModelBuilder: () => BlockLinkViewModel(),
      builder: (context, childModel, child) {
        return Expanded(
          child: Column(
            children: [
              Row(
                children: [
                  model.challengesCompleted == block.challenges.length
                      ? Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(right: 8.0),
                                child: Icon(
                                  Icons.check_circle,
                                  color: color,
                                ),
                              ),
                              Text(
                                'Completed',
                                style: TextStyle(
                                    color: color, fontWeight: FontWeight.bold),
                              )
                            ],
                          ),
                        )
                      : Container()
                ],
              ),
              ...parser.parse(
                '<p>${block.description.join(' ')}</p>',
                fontColor: FccColors.gray05,
                removeParagraphMargin: true,
                isSelectable: false,
              ),
              Row(
                children: [
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextButton(
                        onPressed: () {
                          model.routeToCertification(block);
                        },
                        style: TextButton.styleFrom(
                          backgroundColor: color,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5),
                          ),
                        ),
                        child: const Text(
                          'Start',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: FccColors.gray90,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}
