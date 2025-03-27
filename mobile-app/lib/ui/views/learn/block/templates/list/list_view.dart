import 'package:flutter/widgets.dart';
import 'package:freecodecamp/models/learn/curriculum_model.dart';
import 'package:freecodecamp/ui/views/learn/block/block_template_viewmodel.dart';
import 'package:freecodecamp/ui/views/learn/block/templates/grid/grid_viewmodel.dart';
import 'package:stacked/stacked.dart';

class BlockListView extends StatelessWidget {
  const BlockListView({
    Key? key,
    required this.block,
    required this.model,
  }) : super(key: key);

  final Block block;
  final BlockTemplateViewModel model;

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder.reactive(
      viewModelBuilder: () => BlockGridViewModel(),
      builder: (context, childModel, child) => const Text('list view'),
    );
  }
}
