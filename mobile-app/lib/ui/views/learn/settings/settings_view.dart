import 'package:flutter/material.dart';
import 'package:freecodecamp/models/main/user_model.dart';

import 'package:freecodecamp/ui/views/learn/settings/settings_model.dart';
import 'package:stacked/stacked.dart';

class SettingsView extends StatelessWidget {
  const SettingsView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<SettingsModel>.reactive(
        viewModelBuilder: () => SettingsModel(),
        onModelReady: (model) => model.init(),
        builder: ((context, model, child) {
          return Scaffold(
            backgroundColor: const Color.fromRGBO(0x1b, 0x1b, 0x32, 1),
            appBar: AppBar(
              title: const Text('LEARN SETTINGS'),
              centerTitle: true,
            ),
            body: SingleChildScrollView(
                child: FutureBuilder<FccUserModel>(
              future: model.userFuture,
              builder: ((context, snapshot) {
                if (snapshot.hasData) {
                  FccUserModel user = snapshot.data as FccUserModel;

                  return Row(
                    children: [
                      Expanded(
                        child: Column(
                          children: [
                            textfieldUsername('Username', user.username, model),
                            button(model),
                            textfield('Name', user.name),
                            textfield('Location', user.location),
                            textfield('Picture', user.picture),
                            textfield('About', user.about, 5),
                            button(model),
                            switchButton('isLocked', 'My profile', model),
                            switchButton('showName', 'My name', model),
                            switchButton('showLocation', 'My location', model),
                            switchButton('showAbout', 'My about', model),
                            switchButton('showPoints', 'My points', model),
                            switchButton('showHeatMap', 'My heatmap', model),
                            switchButton(
                                'showCerts', 'My certifications', model),
                            switchButton(
                                'showPortfolio', 'My portfolio', model),
                            switchButton('showTimeLine', 'My timeline', model),
                            switchButton('showDonation', 'My donations', model),
                            button(model),
                          ],
                        ),
                      )
                    ],
                  );
                }

                return const Center(
                  child: CircularProgressIndicator(),
                );
              }),
            )),
          );
        }));
  }

  Container textfield(String label, String? initValue, [int? maxLines]) {
    return Container(
      padding: const EdgeInsets.all(16),
      width: 340,
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
          TextFormField(
            initialValue: initValue,
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

  Widget textfieldUsername(
      String label, String? initValue, SettingsModel model) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(16),
          width: 340,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Text(
                  label,
                  style: const TextStyle(
                      fontWeight: FontWeight.bold, fontSize: 16),
                ),
              ),
              TextFormField(
                initialValue: initValue,
                onChanged: (String changedName) {
                  model.searchUsername(changedName);
                },
                decoration: InputDecoration(
                    helperText: model.helperText,
                    errorText: model.errorText,
                    helperStyle: model.helperText == 'username is available'
                        ? const TextStyle(color: Colors.green)
                        : null,
                    border: const OutlineInputBorder(),
                    filled: true,
                    fillColor: const Color(0xFF0a0a23)),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget button(SettingsModel model) {
    return SizedBox(
        width: 300,
        child: TextButton(
            onPressed: () {
              model.save();
            },
            child: const Text('Save')));
  }

  Widget switchButton(String flag, String title, SettingsModel model) {
    bool isPublic =
        flag != 'isLocked' ? model.profile![flag] : !model.profile![flag];

    String? description = model.getDescriptions(flag);

    return Column(
      children: [
        Container(
          width: 300,
          alignment: Alignment.centerLeft,
          child: Padding(
            padding: const EdgeInsets.only(bottom: 8, top: 16),
            child: Text(
              title,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
          ),
        ),
        if (description != null)
          Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: SizedBox(
                width: 300,
                child: Text(
                  description,
                  style: const TextStyle(
                      fontStyle: FontStyle.italic,
                      fontWeight: FontWeight.bold,
                      color: Color.fromRGBO(0xd0, 0xd0, 0xd5, 1)),
                )),
          ),
        Row(mainAxisAlignment: MainAxisAlignment.center, children: [
          InkWell(
            onTap: () {
              model.setNewValue(flag, false);
            },
            child: Container(
              decoration: BoxDecoration(
                color: !isPublic
                    ? Colors.white
                    : const Color.fromRGBO(0x3b, 0x3b, 0x4f, 1),
                border: Border.all(
                    width: 2, color: const Color.fromARGB(255, 230, 230, 230)),
              ),
              width: 150,
              height: 40,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (!isPublic)
                    const Icon(
                      Icons.check,
                      color: Colors.black,
                      size: 15,
                    ),
                  Text(
                    'Private',
                    style: TextStyle(
                        color: !isPublic ? Colors.black : Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w200,
                        fontFamily: 'RobotoMono'),
                  ),
                ],
              ),
            ),
          ),
          InkWell(
            onTap: () {
              model.setNewValue(flag, true);
            },
            child: Container(
              decoration: BoxDecoration(
                  border: Border.all(width: 2, color: Colors.white),
                  color: isPublic
                      ? const Color.fromARGB(255, 230, 230, 230)
                      : const Color(0x002a2a40)),
              width: 150,
              height: 40,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Public',
                      style: TextStyle(
                          color: isPublic ? Colors.black : Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w200,
                          fontFamily: 'RobotoMono')),
                  if (isPublic)
                    const Icon(
                      Icons.check,
                      color: Colors.black,
                      size: 15,
                    ),
                ],
              ),
            ),
          )
        ]),
      ],
    );
  }
}
