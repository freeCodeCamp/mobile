import 'package:flutter/widgets.dart';
import 'package:freecodecamp/ui/views/learn/block/templates/link/link_viewmodel.dart';
import 'package:stacked/stacked.dart';

class BlockLinkView extends StatelessWidget {
  const BlockLinkView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder.reactive(
      viewModelBuilder: () => BlockLinkViewModel(),
      builder: (context, model, child) => Container(),
    );
  }
}
