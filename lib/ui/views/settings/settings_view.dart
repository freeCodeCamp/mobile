import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:freecodecamp/ui/views/settings/settings_viewmodel.dart';
import 'package:freecodecamp/ui/widgets/drawer_widget/drawer_widget_view.dart';
import 'package:stacked/stacked.dart';

class SettingsView extends StatelessWidget {
  const SettingsView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<SettingsViewModel>.reactive(
        viewModelBuilder: () => SettingsViewModel(),
        builder: (context, model, child) => Scaffold(
              backgroundColor: const Color.fromRGBO(0x2A, 0x2A, 0x40, 1),
              appBar: AppBar(
                backgroundColor: const Color(0xFF0a0a23),
                title: const Text('SETTINGS'),
                centerTitle: true,
              ),
              drawer: SizedBox(
                  width: MediaQuery.of(context).size.width,
                  child: const DrawerWidgetView()),
              body: ListView(
                children: [
                  Container(
                    decoration: const BoxDecoration(
                        border:
                            Border(bottom: BorderSide(color: Colors.white))),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ListTile(
                        onTap: () {
                          model.goToForumSettings();
                        },
                        title: const Text(
                          'FORUM',
                          style: TextStyle(color: Colors.white),
                        ),
                        subtitle: const Text(
                          'you can find the forum settings here',
                          style: TextStyle(color: Colors.white, fontSize: 18.0),
                        ),
                        trailing: const Icon(
                          Icons.arrow_forward_ios_sharp,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                  Container(
                    decoration: const BoxDecoration(
                        border:
                            Border(bottom: BorderSide(color: Colors.white))),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ListTile(
                        onTap: () {},
                        title: const Text(
                          'PODCAST',
                          style: TextStyle(color: Colors.white),
                        ),
                        subtitle: const Text(
                          'you can find the podcast settings here',
                          style: TextStyle(color: Colors.white, fontSize: 18.0),
                        ),
                        trailing: const Icon(
                          Icons.arrow_forward_ios_sharp,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ));
  }
}
