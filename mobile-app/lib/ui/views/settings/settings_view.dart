import 'package:flutter/material.dart';
import 'package:freecodecamp/ui/views/settings/settings_viewmodel.dart';
import 'package:stacked/stacked.dart';

class SettingsView extends StatelessWidget {
  const SettingsView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder.reactive(
      viewModelBuilder: () => SettingsViewModel(),
      builder: (context, model, child) => Scaffold(
        appBar: AppBar(
          title: const Text('SETTIGNS'),
        ),
        body: const Center(
          child: Text('SettingsView'),
        ),
      ),
    );
  }
}
