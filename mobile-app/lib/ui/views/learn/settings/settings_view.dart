import 'package:flutter/material.dart';
import 'package:freecodecamp/ui/views/learn/settings/settings_model.dart';
import 'package:stacked/stacked.dart';

class SettingsView extends StatelessWidget {
  const SettingsView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<SettingsModel>.reactive(
        viewModelBuilder: () => SettingsModel(),
        builder: ((context, model, child) {
          return Scaffold(
            appBar: AppBar(
              title: const Text('LEARN SETTINGS'),
              centerTitle: true,
            ),
            body: Column(
              children: const [],
            ),
          );
        }));
  }

  Container button() {
    return Container();
  }
}
