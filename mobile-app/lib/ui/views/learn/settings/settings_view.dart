import 'package:flutter/material.dart';
import 'package:freecodecamp/models/main/user_model.dart';
import 'package:freecodecamp/ui/views/learn/settings/settings_model.dart';
import 'package:stacked/stacked.dart';

class SettingsView extends StatelessWidget {
  const SettingsView({Key? key, required this.user}) : super(key: key);

  final FccUserModel user;

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<SettingsModel>.reactive(
        viewModelBuilder: () => SettingsModel(),
        onModelReady: (model) => model.init(user.profileUI),
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
                        button(context),
                        switchButton('isLocked', 'My profile', model),
                        switchButton('showName', 'My name', model),
                        switchButton('showLocation', 'My location', model),
                        switchButton('showAbout', 'My about', model),
                        switchButton('showPoints', 'My points', model),
                        switchButton('showHeatMap', 'My heatmap', model),
                        switchButton('showCerts', 'My certifications', model),
                        switchButton('showPortfolio', 'My portfolio', model),
                        switchButton('showTimeLine', 'My timeline', model),
                        switchButton('showDonation', 'My donations', model),
                        textfield(context, 'Name'),
                        textfield(context, 'Location'),
                        textfield(context, 'Picture'),
                        textfield(context, 'About', 5),
                        button(context),
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

  Widget button(BuildContext context) {
    return SizedBox(
        width: MediaQuery.of(context).size.width * 0.725,
        child: TextButton(onPressed: () {}, child: const Text('Save')));
  }

  Widget switchButton(String flag, String title, SettingsModel model) {
    bool isPublic = model.profile![flag];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 8, top: 16),
          child: Text(
            title,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
        ),
        Row(children: [
          InkWell(
            onTap: () {
              model.setNewValue(flag, false);
            },
            child: Container(
              decoration: BoxDecoration(
                color: !isPublic ? Colors.white : const Color(0x00858591),
                border: Border.all(
                    width: 2, color: const Color.fromARGB(255, 230, 230, 230)),
              ),
              width: 125,
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
              width: 125,
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
