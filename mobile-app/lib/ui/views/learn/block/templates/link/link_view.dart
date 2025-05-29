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
  });

  final Block block;
  final BlockTemplateViewModel model;

  @override
  Widget build(BuildContext context) {
    HTMLParser parser = HTMLParser(context: context);

    return ViewModelBuilder.reactive(
      viewModelBuilder: () => BlockLinkViewModel(),
      builder: (context, childModel, child) {
        return Expanded(
          child: Column(
            children: [
              ...parser.parse(
                '<p>${block.description.join(' ')}</p>',
                fontColor: FccColors.gray05,
                removeParagraphMargin: true,
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
                          backgroundColor: FccColors.gray80,
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
