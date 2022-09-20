import 'package:flutter/material.dart';
import 'package:freecodecamp/ui/views/learn/console/console_model.dart';
import 'package:stacked/stacked.dart';

class ConsoleView extends StatelessWidget {
  const ConsoleView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<ConsoleModel>.reactive(
        viewModelBuilder: () => ConsoleModel(),
        builder: (context, model, child) => const Scaffold());
  }
}
