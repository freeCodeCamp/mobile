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
            body: SingleChildScrollView(
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      children: [
                        textfield(context, 'Username'),
                        textfield(context, 'Name'),
                        textfield(context, 'Location'),
                        textfield(context, 'Picture'),
                        textfield(context, 'About', 5),
                      ],
                    ),
                  )
                ],
              ),
            ),
          );
        }));
  }

  Container textfield(BuildContext context, String label, [int? maxLines]) {
    return Container(
      padding: const EdgeInsets.all(16),
      width: MediaQuery.of(context).size.width * 0.8,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: Text(
              label,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
          ),
          TextField(
            maxLines: maxLines ?? 1,
            decoration: const InputDecoration(
                border: OutlineInputBorder(),
                filled: true,
                fillColor: Color(0xFF0a0a23)),
          ),
        ],
      ),
    );
  }

  Container button() {
    return Container();
  }
}
