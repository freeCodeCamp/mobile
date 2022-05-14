import 'package:flutter/material.dart';
import 'package:freecodecamp/ui/views/profile/profile_viemodel.dart';
import 'package:freecodecamp/ui/widgets/drawer_widget/drawer_widget_view.dart';
import 'package:stacked/stacked.dart';

class ProfileView extends StatelessWidget {
  const ProfileView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<ProfileViewModel>.reactive(
      onModelReady: (model) => model.initState(),
      viewModelBuilder: () => ProfileViewModel(),
      builder: (context, model, child) => Scaffold(
        backgroundColor: const Color(0xFF0a0a23),
        appBar: AppBar(
          title: const Text('PROFILE'),
        ),
        drawer: const DrawerWidgetView(),
        body: const Center(
          child: Text('Profile view coming here'),
        ),
      ),
    );
  }
}
