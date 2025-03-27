import 'package:flutter/widgets.dart';
import 'package:freecodecamp/ui/views/learn/block/templates/grid/grid_viewmodel.dart';
import 'package:stacked/stacked.dart';

class BlockListView extends StatelessWidget {
  const BlockListView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder.reactive(
      viewModelBuilder: () => BlockGridViewModel(),
      builder: (context, model, child) => Container(),
    );
  }
}
